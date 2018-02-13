-- not really an excpetion function... lua sucks
function except(message)
   print(message)
   os.exit(1)
end

-- splits string inputstr at seperator sep and returns table
-- of substrings
function split(inputstr, sep)
   if sep == nil then
      sep = "%s"
   end
   local t={} ; local i=1
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
   end
   return t
end

-- removes extension from filename
function remove_extension(filename)
   local ret = split(filename, '.')
   return ret[1]
end

function all(f, container)
   local ret = true
   for k, v in pairs(container) do
      if not f(v) then
         ret = false
         break
      end
   end
   return ret
end

-- maps for tree like container such as a nested table
function tree_map(f, tree)

   for k, v in pairs(tree) do

      -- apply function to node
      f(v)

      -- if node is not a leaf, recurse
      if type(v) == 'table' then
         tree_map(f, v)
      end
   end

   return tree
end

function multi_convert(...)

   local index = 0
   local funcs = table.pack(...)

   return function(...)
      index = index + 1
      return funcs[index](...)
   end
end

-- expected form: <x>, <y>
function tocoords(coord_string)

   local coords = map(tonumber, split(coord_string, ','))

   if next(coords) == nil or tablelength(coords) ~= 2 then
      except('Coordinate format invalid: '..coord_string..'. Required format <x-coordinate>, <y-coordinate>')
   else
      return coords
   end
end
