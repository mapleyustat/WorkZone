__author__ = 'Vignesh Prakasam'

from fractions import gcd
T = int(raw_input())
for k in range(T):
    combiList = []
    N = int(raw_input())
    A = map(int, raw_input().split())
    for i in A:
        if i > 1:
            for j in A:
                if j > 1:
                    if gcd(i, j) != 1:
                        combiList.append('NO')
                    else:
                        combiList.append('YES')
                else:
                    combiList.append('YES')
        else:
            combiList.append('YES')
    if 'YES' in combiList:
        print 'YES'
    else:
        print 'NO'