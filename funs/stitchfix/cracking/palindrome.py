from collections import defaultdict

class Palindrome:
    def __init__(self, p1:str, p2:str = ''):
        self.p1 = p1
        self.p2 = p2

    def __letter_count__(self, phrase:str) -> dict:
        letter_count = defaultdict(int)
        for letter in phrase:
            letter_count[letter] += 1
        return(letter_count)

    def __verify_odds__(self, letter_count:dict) -> bool:
        odd_found = False
        for count in letter_count.values():
            if(count % 2 == 1):
                if(odd_found):
                    return(False)
                else:
                    odd_found = True
        return(True)

    def permutation_comparison(self) -> bool:

        if len(self.p1) != len(self.p2):
            return(False)

        p1_count = self.__letter_count__(self.p1)

        # only one odd? - indicates a valid palindrome
        correct_odds = self.__verify_odds__(p1_count)
        if not correct_odds:
            return False

        # equal across strings?
        for letter in self.p2:
            p1_count[letter] -= 1

        for key, value in p1_count.items():
            if value != 0:
                return False

        return True

    def true_palindrome(self) -> bool:
        phrase = self.p1
        letter_count = self.__letter_count__(phrase)
        correct_odds = self.__verify_odds__(letter_count)
        if not correct_odds:
            return False
        return True

    def true_palindrome_bitmap(self) -> bool:
        phrase = self.p1
        base = ord('a')
        print(f"base is {base}")
        bitVector = 0
        print(f'bitVector starts as {bin(bitVector)}')
        for letter in phrase:
            ordinal = ord(letter) - base
            print(f'ord for {letter} is {ordinal}')
            mask = 1 << ordinal
            print(f'mask is {bin(mask)}')

            if (bitVector & mask == 0):
                print(f'not seen: or-ing with {bin(mask)}')
                # we have not seen this one before
                bitVector |= mask
            else:
                # we have, turn the bit back off
                mask = ~mask
                print(f'already seen: and-ing with {bin(mask)}')
                bitVector &= mask
            print(f'bitVector is {bin(bitVector)}')

        compliment = bitVector - 1
        print(f'compliment is {bin(compliment)}')

        anded = bitVector & compliment
        print(f'anded they are: {bin(anded)}')
        valid_palindrome = (anded == 0)

        return(valid_palindrome)


def test_reject_true_palindrome_bitmap():
    # invalid palindrome
    string1 = 'yabrxefoexrbay'
    palindrome = Palindrome(string1)
    assert(palindrome.true_palindrome_bitmap()) == False

# def test_true_palindrome_bitmap():
#     # valid palindrome
#     string1 = 'yabrxefexrbay'
#     palindrome = Palindrome(string1)
#     assert(palindrome.true_palindrome_bitmap()) == True

# def test_detect_palindrome_permutation():
#     string1 = 'abcdcba'
#     string2 = 'aabbccd'
#     palindrome = Palindrome(string1, string2)
#     assert(palindrome.permutation_comparison()) == True

# def test_reject_palindrome():
#     string1 = 'abcdcbx'
#     string2 = 'aabbccd'
#     palindrome = Palindrome(string1, string2)
#     assert(palindrome.permutation_comparison()) == False

# def test_unequal_lengths():
#     string1 = 'abcdefedcba'
#     string2 = 'aabbccd'
#     palindrome = Palindrome(string1, string2)
#     assert(palindrome.permutation_comparison()) == False

# def test_reject_single_string_is_not_a_palindrome():
#     string1 = 'abcdefxedcbanotapalindorme'
#     palindrome = Palindrome(string1)
#     assert(palindrome.true_palindrome()) == False

# def test_accept_single_string_is_a_palindrome():
#     string1 = 'abcdefedcba'
#     palindrome = Palindrome(string1)
#     assert(palindrome.true_palindrome()) == True

