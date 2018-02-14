import argparse
import sys
from sys import argv , stderr

def level_clouds(fileIn, targetHeight):
   with open(fileIn, "r") as fileIn:
      fileIn = fileIn.readlines()
      for i, line in enumerate(fileIn):
        if "'cloudHeight'" in line:
           for j in range(0,10):
              if "position" in fileIn[i+j]:
                 markerHeight = float(fileIn[i+j].split(", ")[1])
                 break
           left = line.split("FLOAT( ")[0]
           line = left+"FLOAT( "+str(targetHeight - markerHeight)+" ),\n"
        print(line,end='')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Adjust heights of all clouds specified in a <mapname>_save.lua file to the same value.')
    parser.add_argument('file', help='input file containing LUA table with cloud entries')
    parser.add_argument('height', help='the height to assign to all cloud objects')

    args = parser.parse_args()
