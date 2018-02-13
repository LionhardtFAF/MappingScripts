-- not really an excpetion function... lua sucks
function except(message)
   -- print(message)
   io.stderr:write(string.format(message)..'\n')
   os.exit(1)
end

function warn(message)
   -- print(message)
   io.stderr:write(string.format(message)..'\n')
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
   if ret[3] ~= nil then
      warn("Warning: file names will be reduced to the part before the first dot. The file '"..filename.."' might cause unexpected behaviour.")
   end
   return ret[1]
end

function get_filename(path)
   local ret = path:match("^.+/(.+)$")
   if ret == nil then
      ret = path:match("^.+\\(.+)$")
   end
   return ret
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
      except('Error: Coordinate format invalid: '..coord_string..'. Required format <x-coordinate>, <y-coordinate>')
   else
      return coords
   end
end
