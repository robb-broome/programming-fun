from collections import defaultdict

class Palindrome:
    def __init__(self, p1:str, p2:str):
        self.p1 = p1
        self.p2 = p2


    def palindrome_permutation(self) -> bool:

        if len(self.p1) != len(self.p2):
            return False

        p1_count = defaultdict(int)
        for letter in self.p1:
            p1_count[letter] += 1

        # only one odd? - indicates a valid palindrome
        odd_found = False
        for count in p1_count.values():
            if count % 2 == 1:
                if odd_found:
                    return(False)
            else:
                odd_found = True


        # equal across strings?
        for letter in self.p2:
            p1_count[letter] -= 1

        print(p1_count)
        for key, value in p1_count.items():
            if value != 0:
                return False

        return True

