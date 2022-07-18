# #!/usr/bin/python3

"""
search for an item in a list
"""

import argparse
import inspect
import random

class SearchAlgos:

    def __init__(self, target_list, target):
        self.target_list = target_list
        self.target = target
        self.tries = 0
        self.depth = 0
        self.result = None
        self.target_list.sort()
        self.recursive_list = self.target_list
        print("the length of this list is", len(self.target_list))
        print('the target is', self.target)

    def print_start(self):
        # for index, item in enumerate(inspect.stack()[1]):
        #     print(index, ':', item)
        print('')
        print(inspect.stack()[1][3], '.' * 30)

    def print_result(self, result):
        found_position = 'was not found' if result is None else ('was found at position: ' + str(result))
        print('the target ', self.target, found_position , 'after', self.tries, 'tries')

    def recursive_search(self):
        self.depth += 1
        print('depth:', self.depth)
        if len(self.recursive_list) == 0:
            return False
        else:
            self.tries += 1
            midpoint = len(self.recursive_list)//2
            midpoint_value = self.recursive_list[midpoint]
            if  midpoint_value == self.target:
                return midpoint
            elif midpoint_value < self.target:
                self.recursive_list = self.recursive_list[midpoint:]
                print('target list length:', len(self.recursive_list))
                return self.recursive_search()
            elif midpoint_value > self.target:
                self.recursive_list = self.recursive_list[:midpoint]
                print('target list length:', len(self.recursive_list))
                return self.recursive_search()
            else:
                return False

    def linear_search(self):
        self.tries = 0
        self.print_start()
        for i in range(0, len(self.target_list)):
            self.tries += 1
            if self.target_list[i] == self.target:
                return i
        return None


    def binary_search(self):
        self.print_start()
        self.tries = 0
        first = 0
        last = len(self.target_list) - 1

        while first <= last:
            self.tries += 1
            midpoint = (first + last)//2
            print('first:', first, 'last:', last, 'midpoint', midpoint)

            if self.target_list[midpoint] == self.target:
                return midpoint
            elif self.target_list[midpoint] < self.target:
                first = midpoint + 1
            else:
                # the number is somewhere in here, split this half
                last = midpoint - 1

class Exerciser:

    def __init__(self, target_list, target):
        self.target_list = target_list
        self.target = target

    def run(self):
        self.sorts()

    def sorts(self):
        random.shuffle(self.target_list)
        searcher = SearchAlgos(self.target_list, self.target)

        print('recursive_search ....................')
        result = searcher.recursive_search()
        searcher.print_result(result)

        result = searcher.binary_search()
        searcher.print_result(result)

        result = searcher.linear_search()
        searcher.print_result(result)



def main(list_length, target):
    target_list = list(range(0, list_length))
    ex = Exerciser(target_list, target)
    print('ex vars?')
    print(vars(ex)['target'])
    ex.run()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='search some lists')
    parser.add_argument('--list_length', '-l', metavar='length', type=int, help='length of the list to search in')
    parser.add_argument('--target','-t', metavar='target', type=int, help='the integer we are searching for')
    args = parser.parse_args()
    print(args)
    print('vars', vars(args))
    print('list length is', args.list_length)
    print('target is', args.target)
    main(args.list_length, args.target)
