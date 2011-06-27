#!/usr/bin/env python
"""Axis movement tester

Creates gcode that homes given axis, then moves it at given
feedrate in varying moves, then returns 1 mm next to start.
If your printer returns consistently to the same position 1mm from start, 
probablility that you have missing steps is quite low.

Movement on Z axis is divided by three as its shorter.
"""


import sys
lastfeed = 0

def g1write(gcfile, axis, pos, feed):
    """ Creates G1 line, adding feedrate only when necessary """
    global lastfeed
    feedstr = " F%s" % (feed,)
    if feed == lastfeed:
        feedstr = ""
    gcfile.write("G1 %s%s%s\n" % (axis, pos, feedstr))
    lastfeed = feed


def main():

    if len(sys.argv) != 3:
        print("Give me axis and feedrate!")
        return 1

    axis = sys.argv[1].upper()

    if axis not in ("X","Y","Z"):
        print("First argument is not an axis (XYZ)")
        return 1

    try:
        feedrate = int(sys.argv[2])
    except:
        feedrate = 0

    if feedrate <= 0:
        print "Second argument must be feedrate (in mm/min)"
        return 1

    print("Creating testfile for %s at F%s" % (axis, feedrate))

    gc = open("testfile-%s-%s.gcode" % (axis, feedrate), 'w')
    gc.write("G90\n")
    gc.write("G21\n")
    g1write(gc, axis, -250, feedrate/2)
    gc.write("G92 %s0\n" % (axis,))
    #start whith move of this length [mm]
    bstep = 0.3
    #every time multiply it by this
    stepmul = 1.31
    #longest step if this long [mm]
    maxstep = 20
    if (axis == "Z"):
        maxstep = maxstep/3
        bstep = bstep/3
    #current postition
    cpos = 0
    cstep = bstep

    steps = []

    print ("Increasing step: %s to %s" % (cstep, maxstep))

    while(cstep < maxstep):
        steps.append(cstep)
        cpos = cpos + cstep
        cstep = cstep * stepmul
        g1write(gc, axis,cpos, feedrate)

    steps.reverse()

    for step in steps:
        cpos = cpos + step
        g1write(gc, axis,cpos, feedrate)

    print("Finished at %smm" % (cpos,))
    
    #return nearly to the start
    g1write(gc, axis, 1, feedrate)

if __name__ == "__main__":
    main()
