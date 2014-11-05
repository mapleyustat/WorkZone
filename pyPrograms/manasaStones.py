__author__ = 'Vignesh Prakasam'

import itertools
from collections import Counter

# T = int(raw_input())
# for t in range(T):
    # n, a, b, result = int(raw_input()), int(raw_input()), int(raw_input()), []
# for i in list(itertools.product([0, 1], repeat = n-1)):
#     print i
#     val = 0
#     for j in i:
#         val += j
#     result.append(val)
# print " ".join(map(str, sorted(Counter(result).keys())))
##########################
# n = 63
# a = 97
# b = 39
# val = map(str, bin(63))
# val.remove('0')
# val.remove('b')
# length = len(val)
# print length
# for i in range(pow(2, 15)):
#     j = 0
#     val = map(str, bin(i))
#     val.remove('0')
#     val.remove('b')
#     tempVal = val
#     if tempVal != length:
#         for i in range(length - len(tempVal)):
#             val.insert(j, '0')
#             j = j+1
#         print val
#         result = 0
#         for k in val:
#             if k == '0':
#                 result = result + a
#             else:
#                 result = result + b
#         print result
#
##############################33

T = int(raw_input())
for t in range(T):
    n, a, b, result = int(raw_input()), int(raw_input()), int(raw_input()), []
    for k in range(n):
        val1 = a*k
        val2 = b*(n-k-1)
        result.append(str(val1+val2))
    intResult = sorted(map(int, Counter(result).keys()))
    for i in intResult:
        print i,
    print '\r'

