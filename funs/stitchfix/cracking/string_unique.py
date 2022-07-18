def is_unique(tested_string: str) -> bool:
    accumulator = 0
    base = ord('a')
    for letter in tested_string:
        index = (1 << ord(letter) - base)
        letter_exists = accumulator & index
        if (letter_exists > 0):
            return(False)
        else:
            accumulator |= index

    return True
