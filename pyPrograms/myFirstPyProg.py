__author__ = 'Vignesh Prakasam'

def countingHoles():
    holes1 = [0, 4, 6, 9]
    holes2 = [8]
    count = 0
    num = 990
    k = map(int, str(num))
    for c in k:
        if c in holes1:
            count += 1
        elif c in holes2:
            count += 2
    print count

countingHoles()
# quotient = num
# while quotient != 0:
#     remainder = quotient % 10
#     if remainder in holes1:
#         count += 1
#     elif remainder in holes2:
#         count += 2
#     quotient /= 10