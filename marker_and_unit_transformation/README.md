# mulin-transform

## Overview

The script *transform.lua* applies linear transformation to markers and units stored in a `<mapname>_save.lua` file. The transformations supported so far are:

* **rotation**    : rotates markers or units around a specified point on the map by a given angle
* **projection**  : projects markers or units from a specified point by a given factor
* **translation** : translates units or markers in a given direction by given distance 

All transformations will be performed on the horizontal plane. Enable *auto snap to land layer* in your map editor to make all transformed objects accquire ground level height again after loading the map with the data output from this script! You might need to select all objects that were transformed and move them 1 field in any direction and then back again for land layer snap to engage.The output of this script will look a little messed up, but the map editor will process it jut fine; and once you save your map, the file will be correctly formatted again.

## Usage

```
Usage: transform.lua [--rotate <degrees> <point>]
       [--project <factor> <point>]
       [--translate <degrees> <magnitude>] [-m] [-u] [-t <times>] [-c]
       [-h] <file>

Applies linear transformations (rotation, projection, translation) to
objects specified in an input file (<map name>_save.lua).

Arguments:
   file                  input file (e.g. MyMap_save.lua)

Options:
   --rotate <degrees> <point>
                         rotate objects by angle around point
   --project <factor> <point>
                         project objects by factor from point
   --translate <degrees> <magnitude>
                         translate objects by vector
   -m, --markers         Apply transformation to markers.
   -u, --units           Apply transformation to units.
   -t <times>, --times <times>
                         number of times to apply transformation (default: 1)
   -c, --copy            Copy objects each transformation.
   -h, --help            Show this help message and exit.
```
