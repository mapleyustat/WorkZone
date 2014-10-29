__author__ = 'Vignesh Prakasam'

T = int(raw_input())
val = []
for i in range(T):
    height = 1
    N = int(raw_input())
    for j in range(1,N+1):
        if j%2 != 0:
            height = height*2
        else:
            height = height+1
    val.append(height)
for k in val: print k