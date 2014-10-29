__author__ = 'Vignesh Prakasam'

import string
def rough():
    width = [7, 4, 5, 6, 7]
    i, j = 0, 4
    y = sorted(width[i:j+1])
    print(i,y)

def serviceLane():
    N,T = map(int,raw_input().split())
    width = map(int, raw_input().split())
    for i in range(T):
        x,y = map(int,raw_input().split())
        minVal = min(width[x:y+1])
        print minVal
def loveLetter():
    T = int(raw_input())
    for t in range(1,T+1):
        text, count = raw_input(), 0
        for i in range(len(text)-1,-1,-1):
            if text == text[::-1]:
                break
            for j in range(string.lowercase.index(text[i]),-1,-1):
                if text == text[::-1]:
                    break
                text = text[:i]+ string.lowercase[j-1] + text[i+1:]
                print text
                count += 1
                if string.lowercase[j-1] == 'a':
                        break
        print count

loveLetter()