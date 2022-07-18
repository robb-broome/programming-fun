# tuple
var = 'robb'
mytuple = (1, 2, 3, var)
print(mytuple)
print(len(mytuple))
print('is 3 in the tuple')
print(3 in(mytuple))
print('is 9 in the tuple')
print(9 in(mytuple))


yourtuple = ('a',)
mytuple += yourtuple
print(mytuple)
print(yourtuple)

var = 'jon'
print('mytuple after changing var')
print(mytuple)
print('multiple the tuple')
print(mytuple * 5)
mytuple = (1, 2, 3, var)
print('mytuple after recreating')
print(mytuple)


myset = {1, 2, 3, 4}
mytupleset = (myset,)
mytuple += mytupleset
print(mytuple)
print('is 1 in the set?')
print(1 in(myset))
print('is 9 in the set?')
print(9 in(myset))

# print('comprehansion of a set')
# a_list = [x for x in myset in range(4)]
# print('a list is ')
# print(a_list)


# mydict = { myset: 'a' }
# print(mydict)

mytuple = (1, 2, 3)
mydict = { mytuple: myset, 'a': 'a' }
print(mydict)
print('is a in mydict')
print('a' in(mydict))

mylist = [1, 2, 3, mytuple, 4, 5, 6]
print('print th elist?')
[print(x * 3) for x in  mylist]
print(mylist)
print('conditional printing if less than 5')
[print(x) for x in mylist if x < 5]
print('comprehansion of a list')
a_list = [x for x in  range(100)]
print('a list is ')
print(a_list)

mylist[3] = 'not a tuple'
print(mylist)

