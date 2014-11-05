__author__ = 'Vignesh Prakasam'

from collections import Counter

occurences, oddCount, evenCount = Counter(raw_input()).viewvalues(), 0, 0
print occurences
for i in occurences:
    if i%2 == 1: oddCount += 1
    else: evenCount += 1
if (oddCount == 1 and evenCount >= 0) or (oddCount == 0 and evenCount > 0): print 'YES'
else: print 'NO'