# mulin-transform

## Overview

The script *transform.lua* applies linear transformation to markers and units stored in a `<mapname>_save.lua` file. The transformations supported so far are:

* **rotation**    : rotates markers or units around a specified point on the map by a given angle
* **projection**  : projects markers or units from a specified point by a given factor
* **translation** : translates units or markers in a given direction by given distance 

All transformations will be performed on the horizontal plane. Enable
"auto snap to land layer" in your map editor to make all transformed
objects accquire ground level height again after loading the map with
the data output from this script! You might need to select all objects
that were transformed and move them 1 field in any direction and then
back again for land layer snap to engage.
The output of this script will look a little messed up, but the map editor
will process it jut fine; and once you save your map, the file will be
correctly formatted again.

## Usage

