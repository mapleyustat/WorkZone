__author__ = 'Vignesh Prakasam'

import string

T = int(raw_input())
for t in range(1,T+1):
    text, diff, init = map(str, raw_input()), 0, 0
    textLen = len(text)
    print text
    last = textLen-1
    if textLen%2 == 0: iter = textLen/2
    else: iter = (textLen-1)/2
    for i in range(1,iter+1):
        if string.lowercase.index(text[init]) < string.lowercase.index(text[last]):
            diff += string.lowercase.index(text[last])-string.lowercase.index(text[init])
        else:
            diff += string.lowercase.index(text[init]) - string.lowercase.index(text[last])
        init += 1
        last -= 1
    print diff