import time
import numpy as np
class Game:

    def __init__(self, players):
        '1'

class Round:

    def play_round(players):
        results = []
        pot = []
        print('playing the round...')
        for player in players:
            card = player.emit()
            if card is not None:
                pot.append(card)
                outcome = (player, card)
                results.append(outcome)
            else:
              '''
              this player is out of the game
              so, just do not include them in
              any results
              '''

        # print('pot is now',pot)

        highest = 0
        winner = None
        for result in results:
            owner, card = result

            if card > highest:
                highest = card
                winner = owner

        if winner is None:
            print("Nobody Won!")
            print("here are the players")
            for player in players:
                print(player.name, player.cards)

            print("here are the results")
            for result in results:
                owner, card = result
                print(owner.name, card)

            return(-1)
        else:
            print('round winner is', winner.name, 'with', highest)
            # print('awarding the pot to', winner.name)

            for card in pot:
                winner.absorb(card)

            for player in players:
                # print(player.name, 'has cards', player.cards)
                None

        if len(results) == 1:
            print('.' * 99)
            print('this game is over and', winner.name, 'has won')
            return(-1)

        return(1)


class Player:

    def __init__(self, cards, name):
        self.cards = cards
        self.name = name

    def emit(self):
        try:
            popped = self.cards.pop()
            return(popped)
        except:
            # print('it looks like', self.name, 'is out of cards!')
            return(None)

    def absorb(self, card):
        self.cards.insert(0, card)

def ordinal_for(n):
    n = int(n)
    if 11 <= (n % 100) <= 13:
        suffix = 'th'
    else:
        suffix = ['th', 'st', 'nd', 'rd', 'th'][min(n % 10, 4)]
    return str(n) + suffix

p1 = Player([4,5,6,7,11,2,1], 'joe')
p2 = Player([0,1,2,3,4,0,9], 'bob')
p3 = Player([15, 20,20,99,77,74,74,73,76], 'sarah')
p3 = Player([8,1,11,4,9,1,2], 'gary')
p3 = Player([8,9,7,1,8,2,5], 'jon')

players = [p1, p2, p3]

round_count = 0
shuffle_count = 0
while True:
    round_count += 1
    print('')
    print('Round: ', round_count)
    if round_count > 50:
        shuffle_count += 1
        print('.' * 99)
        print("for the ", ordinal_for(shuffle_count), "time, this is going too long, so shuffling everyone's cards")
        print('.' * 99)
        round_count = 0
        for player in players:
            my_cards = player.cards
            np.random.shuffle(my_cards)
            player.cards = my_cards

    status = Round.play_round(players)
    if(status == -1):
        print("we had to shuffle", shuffle_count, "times")
        break

