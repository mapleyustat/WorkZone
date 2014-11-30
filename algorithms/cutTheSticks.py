__author__ = 'Vignesh Prakasam'

T, stickLength, count = int(raw_input()), map(int, raw_input().split()), 0
if len(stickLength) == T:
    while any(stickLength) != 0:
        j = 0
        while 0 in stickLength:
            stickLength.remove(0)
        minVal = min(stickLength)
        for i in stickLength:
            if i > 0:
                stickLength[j] = i - minVal
                count += 1
            else:
                stickLength[j] = 0
            j += 1
        print count
        count = 0
