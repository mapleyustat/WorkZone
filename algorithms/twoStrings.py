__author__ = 'U430p'

from collections import Counter
T = int(raw_input())
for t in range(T):
    a = raw_input()
    uniqueA = Counter(sorted(a)).keys()
    b = raw_input()
    uniqueB = Counter(sorted(b)).keys()
    check = "NO"
    if len(a) > len(b):
        for i in range(0, len(uniqueB)):
            if uniqueB[i] in uniqueA:
                check = 'YES'
    else:
        for i in range(0, len(uniqueA)):
            if uniqueA[i] in uniqueB:
                check = 'YES'
    print check