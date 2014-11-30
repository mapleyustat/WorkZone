__author__ = 'Vignesh Prakasam'

L, R = int(raw_input()), int(raw_input())
print [i^j for i in range(L, R+1) for j in range(L, R+1)]