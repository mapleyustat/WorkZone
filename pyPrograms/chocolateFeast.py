__author__ = 'Vignesh Prakasam'

for i in range(int(raw_input())):
    pocket, cost, wrapper = raw_input().split()
    pocket, cost, wrapper = int(pocket), int(cost), int(wrapper)
    initialBuy = pocket/cost
    initialWrappers = initialBuy
    while initialWrappers >= wrapper:
        nextBuy = 1
        initialBuy += nextBuy
        remainingWrappers = initialWrappers - wrapper
        initialWrappers = remainingWrappers + nextBuy
    print initialBuy