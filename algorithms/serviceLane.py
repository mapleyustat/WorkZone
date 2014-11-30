__author__ = 'Vignesh Prakasam'

import sys

userinput = sys.stdin.readline()
N, T = userinput.split()
N = int(N)
T = int(T)
userinput = sys.stdin.readline()
width = [int(elem) for elem in userinput.split()]
t = 1
while t <= T:
    userinput = sys.stdin.readline()
    enter, out = userinput.split()
    enter = int(enter)
    out = int(out)
    veh = []
    val = range(enter, out+1, 1)
    for i in val:
        if width[i] == 1:
            veh.append('1')
        elif width[i] == 2:
            veh.append('2')
        else:
            veh.append('3')
    if '1' in veh:
        print 1
    elif '2' in veh:
        print 2
    else:
        print 3
    t += 1