# 5611-animation
# Assignment 1
# author: Shirley Su
# date: Sep 22nd, 2023

This assignment is do design the collision detection library for three shapes, 
Circles, Lines, Box. So there will be 3! = 6 cases, in detail, Circle-circle, 
Circle-line, Circle-box, Line-line, Line-box and Box-box collisions. This 
assignment is write in processing. 

NOTE: Currently, the running time is calculated base on running one task file every-time.
So it may need to manual update which task needs to be run. Also, don't forget to change 
The file path. It is running on a PC with CPU i7-12700 and GPU NVIDIA 3070.


# Files
# "Box.pde, Circle.pde, Line.pde"
I design three class Box, Line, Circle including their id and shape info.

# "CollisionTest.pde"
This is the main function including reading, writing, and collision detection
cases mention above. More details of function explain are in the comment of file. 
Circle-circle: calculate the center distance
Circle-line: CCD method
Circle-box: find closest point between box and circle and check inside
Line-line: cross product to check
Line-box: check if outside or end-point inside first, then check line-line collides
Box-box: align box check is to compare the min and max of boxes

Some results from the collision detection are in the chart below.
    Task	Circle  Line    Box	    Circle-Line Circle-Box	Line-Box    Num-Collision   Duration (ms)
    1       0	    0	    0	    2	        0	        0           2               0.0187
    2	    0	    0	    0	    0	        2	        0           2               0.0179
    3	    0	    6	    0	    0	        0	        2           7               0.0309
    4	    0	    2	    0	    0	        0	        5           6               0.0540
    5       15	    3	    0	    12	        8	        3           30              0.2798
    6	    29	    4	    21	    11	        71	        17          121             1.8044
    7	    14	    2	    602	    11	        262	        54          794             15.7606
    8	    325	    2	    514	    41	        794	        58          1183            24.0951
    9	    8	    2	    3456	6	        265	        126         3635            88.7302
    10	    0	    4	    10151	0	        152	        234         10298           673.2474