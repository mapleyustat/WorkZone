__author__ = 'Vignesh Prakasam'

from collections import Counter

numOfRocks,rock = int(raw_input()), map(str, raw_input())
keys = Counter(rock).keys()
tempKeys = keys
for i in range(numOfRocks - 1):
    resultKeys, rock = [], map(str, raw_input())
    keys = Counter(rock).keys()
    for j in keys:
        if j in tempKeys: resultKeys.append(j)
    tempKeys = resultKeys
print len(resultKeys)