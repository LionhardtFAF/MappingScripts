-- returns length of table
function tablelength(T)
   local count = 0
   for _ in pairs(T) do count = count + 1 end
   return count
end

-- recurisvely prints table with f and g applied to key and value
function frprinttable(T, f, g)
   local count = 0
   for p, q in pairs(T) do
      if type(q) == 'table' then
         frprinttable(q, f, g)
      else
         print(f(p), g(q))
      end
   end
   return count
end

function deepcopy(orig)
   local orig_type = type(orig)
   local copy
   if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
         copy[deepcopy(orig_key)] = deepcopy(orig_value)
      end
      setmetatable(copy, deepcopy(getmetatable(orig)))
   else -- number, string, boolean, etc
      copy = orig
   end
   return copy
end

function table.copy(t)
   local u = { }
   for k, v in pairs(t) do u[k] = v end
   return setmetatable(u, getmetatable(t))
end

function table.size(t)
   local count = 0
   for _ in pairs(t) do count=count+1 end
   return count
end

function table.print(t)
   print(table.tostring(t))
end
