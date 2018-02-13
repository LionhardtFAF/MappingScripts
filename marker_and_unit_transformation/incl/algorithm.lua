local Info       = debug.getinfo (1, 'S');
local ScriptPath = Info.source:match[[^@?(.*[\/])[^\/]-$]];

if ScriptPath ~= nil then
   package.path     = ScriptPath .. '../incl/?.lua;'  .. package.path;
end

require 'functional'
require 'strict'
require 'typefunctions'
require 'misc_util'
require 'table_util'

-- compensates for differing interfaces of units and markers
-- keyword should be capitalized for this to make sense
function access(container, keyword)
   local ret = container[keyword]
   if ret == nil then
      ret = container[string.lower(keyword)]
   end
   if ret == nil then
      except("access error: unkown keys: "..keyword..", "..string.lower(keyword))
   end
   return ret
end

-- compensates for differing interfaces of units and markers
-- keyword should be capitalized for this to make sense
function insert(container, keyword, value)
   if container[keyword] == nil then
      if container[string.lower(keyword)] == nil then
         except("access error: unkown keys: "..keyword..", "..string.lower(keyword))
      else
         container[string.lower(keyword)] = value
      end
   else
      container[keyword] = value
   end
   return container
end

function translate_entries(container, magnitude, angle, copy, times, m_or_u)

   local translation_vector = {magnitude*math.sin(angle),magnitude*math.cos(angle)}

   -- define the function that performs the linear transformation on a given vector
   -- meta_factor is used for repeated transformations, where the nth transformation
   -- wil have a meta_factor of n, e.g. applying a rotation of d degrees n times
   -----------------------------------------------------------
   local function translate(v, meta_factor)
      return {v[1]+translation_vector[1], v[2], v[3]+translation_vector[2]}
   end
   -----------------------------------------------------------

   return transfrom_entries(container, copy, times, m_or_u, translate)

end

function rotate_entries(container, rotation_point, angle, copy, times, m_or_u)

   -- define the function that performs the linear transformation on a given vector
   -- meta_factor is used for repeated transformations, where the nth transformation
   -- wil have a meta_factor of n, e.g. applying a rotation of d degrees n times
   -----------------------------------------------------------
   local function rotate(v, meta_factor)
      local d = {v[1] - rotation_point[1], v[3] - rotation_point[2]}
      local drot = {math.cos(meta_factor*angle)*d[1] - math.sin(meta_factor*angle)*d[2],
                    math.sin(meta_factor*angle)*d[1] + math.cos(meta_factor*angle)*d[2]}
      return {drot[1] + rotation_point[1], v[2], drot[2] + rotation_point[2]}
   end
   -----------------------------------------------------------

   return transfrom_entries(container, copy, times, m_or_u, rotate)

end

function project_entries(container, projection_point, factor, copy, times, m_or_u)

   -- define the function that performs the linear transformation on a given vector
   -- meta_factor is used for repeated transformations, where the nth transformation
   -- wil have a meta_factor of n, e.g. applying a rotation of d degrees n times
   -----------------------------------------------------------
   -- projects vector in xy plane
   local function project(vector, meta_factor)
      return {meta_factor*factor*(vector[1] - projection_point[1])+vector[1],
              vector[2],
              meta_factor*factor*(vector[3] - projection_point[2])+vector[3]}
   end
   -----------------------------------------------------------
   
   return transfrom_entries(container, copy, times, m_or_u, project)

end

-- walks over table containing data for objects and units.
-- manipulates object and unit entries according to the linear transformation
-- passed as argument and according to wehther entries should ne copied and
-- hwo amny times the transformation is to be applied in succession
function transfrom_entries(container, copy, times, m_or_u, linear_transformation)

   -- takes a table holding the data for a unit or a marker
   -- applies transformation to the position data
   -- TODO: also manipulate teh orientation data
   -----------------------------------------------------------
   local function transform_object(object, meta_factor)

      meta_factor = meta_factor or 1

      return insert(
         object, 'Position',
         linear_transformation(
            access(object, 'Position'),
            meta_factor
         )
      )
   end
   -----------------------------------------------------------

   -- iterates over table holding marker objects (also tables)
   -- applies transformation to objects
   -----------------------------------------------------------
   local function transform_markers()

      if copy then
         for key, object in pairs(deepcopy(container)) do
            for i=0,times do
               container[key..'.'..tostring(i)] = transform_object(deepcopy(object), i)
            end
         end
      else
         -- for i=1,times do
         --    map(transform_object, container)
         -- end
         map(function(x) return transform_object(x, times) end, container)
      end

      return container
   end
   -----------------------------------------------------------

   -- iterates over table holding unit objects (also tables)
   -- applies transformation to objects
   -----------------------------------------------------------
   local function transform_units()

      -----------------------------------------------------------
      -- filters out nodes that are not units and applies transformation
      -- meta_factor either scales an angle or a vector, depending
      -- on the context; it is a generic factor to the transformation
      local function select_unit_and_transform(x, meta_factor)
         if type(x) == 'table' and x.Orientation ~= nil then
            transform_object(x, meta_factor)
         end
      end
      -----------------------------------------------------------

      local tree = container

      -----------------------------------------------------------
      -- performs pre-order tree walk
      -- modifies unit nodes when encountering any
      local function _transform_units(tree)
         -- adding copies of units will alter the tree,
         -- so walk over a deepcopy of it
         for k, v in pairs(deepcopy(tree)) do

            -- v is a unit
            if type(v) == 'table' and v.Orientation ~= nil then

               -- apply rotation to unit
               for i=0,times do
                  tree[k..'.'..tostring(i)] = transform_object(deepcopy(v), i)
               end
            end

            -- recurse
            if type(v) == 'table' then

               tree[k] = _transform_units(v)
            end
         end
         return tree
      end
      -----------------------------------------------------------

      if copy then
         tree = _transform_units(tree)
      else
         tree_map(function(x) return select_unit_and_transform(x, times) end, tree)
      end

      return tree

   end
   -----------------------------------------------------------
   if m_or_u == 'markers' then
      return transform_markers()
   end
   if m_or_u == 'units' then
      return transform_units()
   end
   except('neither markers not units')
end

-- specialized print function for tables for sc-maps save format
function table.tostring(x, indentation_level)

   indentation_level = indentation_level or 1

   local function wrap(t)
      if type(t) == 'string' then
         return "STRING( '"..t.."' )"
      end
      if type(t) == 'boolean' then
         return "BOOLEAN( "..tostring(t).." )"
      end
      if type(t) == 'table' then
         return "VECTOR3( "
            ..tostring(t[1])..', '
            ..tostring(t[2])..', '
            ..tostring(t[3]).." )"
      end
      if type(t) == 'number' then
         return "FLOAT( "..tostring(t).." )"
      end
      print('error')
      print(type(t), t)
      os.exit(1)
   end

   local function indent(k)
      k = k or 0
      local dent = ''
      for i=1,indentation_level+k do
         dent = dent..'   '
      end
      return dent
   end

   if type(x) ~= 'table' then
      return wrap(x)
   end

   -- heuristic to recognize GROUP entry
   if type(x) == 'table' and type(x[1]) == 'table' and x[1]['orders'] ~= nil then
      return 'GROUP '..table.tostring(x[1], indentation_level+1)
   end

   -- heuristic to recognize vector entry
   if type(x) == 'table'  and tablelength(x) == 3
   and all(function(z) return type(z) == 'number' end, x)
   then
      return wrap(x)
   end

   local rpr = ''
   for k, v in pairs(x) do
      rpr = rpr..indent()..'[\''..tostring(k)..'\']'..' = '..table.tostring(v, indentation_level+1)..',\n'
   end
   return '{\n'..rpr..indent(-1)..'}'
end
