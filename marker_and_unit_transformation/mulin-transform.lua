local Info       = debug.getinfo (1, 'S');
local ScriptPath = Info.source:match[[^@?(.*[\/])[^\/]-$]];

if ScriptPath ~= nil then
   package.path     =   package.path .. ';'..ScriptPath .. '?.lua';
end

require 'incl.algorithm'

local argparse = require 'incl.argparse'

local function str_degr_to_rad(x) return math.rad((tonumber(x))) end

local parser = argparse()
   :description(
      'Applies linear transformations (rotation, projection, translation) to\n'
       ..'objects specified in an input file (<map name>_save.lua).')

parser:argument('file', 'input file (e.g. MyMap_save.lua)')
   :convert(remove_extension)
   :target('infile')

parser:option('--rotate ', 'rotate objects by angle around point')
   :argname {'<degrees>', '<point>'}
   :convert(multi_convert(str_degr_to_rad, tocoords))
   :args(2)
   :count "0-1"

parser:option('--project ', 'project objects by factor from point')
   :argname {'<factor>', '<point>'}
   :convert(multi_convert(tonumber, tocoords))
   :args(2)
   :count "0-1"

parser:option('--translate ', 'translate objects by vector')
   :argname {'<degrees>', '<magnitude>'}
   :convert(multi_convert(str_degr_to_rad, tonumber))
   :args(2)
   :count "0-1"

parser:flag('-m --markers', 'Apply transformation to markers.')
   :count '0-1'
parser:flag('-u --units', 'Apply transformation to units.')
   :count '0-1'
parser:option('-t --times', 'number of times to apply transformation', '1')
   :count '0-1'
   :convert(function(x) return tonumber(x)-0 end)
parser:flag('-c --copy', 'Copy objects each transformation.')
   :count '0-1'

local args = parser:parse()

if args['rotate'] ~= nil then
   args['rotation angle'] = args['rotate'][1]
   args['point of rotation'] = args['rotate'][2]
end

if args['project'] ~= nil then
   args['factor'] = args['project'][1]
   args['point of projection'] = args['project'][2]
end

if args['translate'] ~= nil then
   args['translation angle'] = args['translate'][1]
   args['magnitude'] = args['translate'][2]
end



local Info       = debug.getinfo (1, 'S');
local ScriptPath = Info.source:match[[^@?(.*[\/])[^\/]-$]];
local fPath = args['infile']:match[[^@?(.*[\/])[^\/]-$]];

if fPath ~= nil then
   package.path     = package.path .. ';'.. fPath .. '?.lua';
end

infile = require(get_filename(args['infile']))

function transform_markers(container)
   if args['rotate'] then
      container = rotate_entries(container,
                                 args['point of rotation'],
                                 args['rotation angle'],
                                 args['copy'],
                                 args['times'],
                                 'markers')
   end
   if args['project'] then
      container = project_entries(container,
                                 args['point of projection'],
                                 args['factor'],
                                 args['copy'],
                                 args['times'],
                                 'markers')
   end
   if args['translate'] then
      container = translate_entries(container,
                                  args['magnitude'],
                                  args['translation angle'],
                                  args['copy'],
                                  args['times'],
                                  'markers')
   end
   return container
end

function transform_units(container)
   if args['rotate'] then
      container = rotate_entries(container,
                                 args['point of rotation'],
                                 args['rotation angle'],
                                 args['copy'],
                                 args['times'],
                                 'units')
   end

   
   if args['project'] then
      container = project_entries(container,
                                  args['point of projection'],
                                  args['factor'],
                                  args['copy'],
                                  args['times'],
                                  'units')
   end
   if args['translate'] then
      container = translate_entries(container,
                                  args['magnitude'],
                                  args['translation angle'],
                                  args['copy'],
                                  args['times'],
                                  'units')
   end
   return container
end

if args['markers'] then
   Scenario['MasterChain']['_MASTERCHAIN_']['Markers'] = transform_markers(Scenario['MasterChain']['_MASTERCHAIN_']['Markers'])
end

if args['units'] then
   Scenario = transform_units(Scenario)
end

print("Scenario = "..table.tostring(Scenario))
