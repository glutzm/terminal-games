#!/usr/bin/env python3

import random
import os

""" Rock, Paper, Scissors
    Author: Gustavo Antonio Lutz de Matos - gustavo.almatos@gmail.com
    This game was developed during the Introduction to Programming Nanodegree course at Udacity

    This program plays a game of Rock, Paper, Scissors between two Players,
    and reports both Player's scores each round."""

# Possible moves in the game
moves = ['rock', 'paper', 'scissors']


# Cool colors to print on Linux terminals
# Got this idea from Stack Overflow on:
# https://stackoverflow.com/questions/287871/print-in-terminal-with-colors
class PrintColors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    NORMAL = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


# Function to analyze which player won
def beats(one, two):
    return ((one == 'rock' and two == 'scissors') or
            (one == 'scissors' and two == 'paper') or
            (one == 'paper' and two == 'rock'))


class Player:

    # Initializing players first move memory before the
    # first round with random value
    def __init__(self):
        super().__init__()
        self.my_move = random.choice(moves)
        self.their_move = random.choice(moves)

    # Function to store players moves for each round
    def learn(self, my_move, their_move):
        self.my_move = my_move
        self.their_move = their_move
        pass

    def move(self):
        return 'rock'


# Class of machine player that returns only random moves
class RandomPlayer(Player):

    def move(self):
        return random.choice(moves)


# Class of machine player that returns the last move that
# the human player used
class ReflectPlayer(Player):

    def move(self):
        return self.their_move


# Class of machine player that returns the sequence of
# moves based on the last move
class CyclePlayer(Player):

    def move(self):
        if self.my_move == 'rock':
            return 'scissors'
        elif self.my_move == 'scissors':
            return 'paper'
        else:
            return 'rock'


# Class of user interaction
class HumanPlayer(Player):

    def move(self):
        while True:
            human_input = input(
                PrintColors.NORMAL +
                PrintColors.BOLD +
                "\nWhat's your choice?\n"
                "Type 'rock', 'paper' or 'scissors'\n"
            )
            if human_input == 'quit':
                exit()
            if human_input not in moves:
                print(
                    PrintColors.FAIL +
                    "\nPlease enter a valid throw: 'rock', 'paper',"
                    "'scissors', or 'quit' to end the game."
                )
            else:
                return human_input


# Begin playing the game
class Game:
    # Initializing players
    def __init__(self, p1, p2, rounds):
        self.p1 = p1
        self.p2 = p2
        self.win1 = 0
        self.win2 = 0
        self.move1 = ''
        self.move2 = ''
        self.player2 = ''
        self.rounds = rounds

    # Rounds
    def play_round(self):
        self.move1 = self.p1.move()
        self.move2 = self.p2.move()

        print(
            PrintColors.NORMAL +
            PrintColors.BOLD +
            f"\nPlayer 1: {self.move1} - Player 2: {self.move2}\n"
        )
        if self.move1 == self.move2:
            print(PrintColors.OKBLUE + "\tIt's a Tie!\n")
        elif beats(self.move1, self.move2):
            self.win1 += 1
            print(PrintColors.OKGREEN + "\tPlayer 1 Won!\n")
        else:
            self.win2 += 1
            print(PrintColors.OKGREEN + f"\t{self.player2} Won!\n")

        # Player 1 perspective
        self.p1.learn(self.move1, self.move2)
        # Player 2 perspective
        self.p2.learn(self.move2, self.move1)

    # Main game call
    def play_game(self):
        # How to name the player
        if isinstance(self.p2, HumanPlayer):
            self.player2 = '   You'
        else:
            self.player2 = 'Player 2'

        print(
            PrintColors.NORMAL +
            PrintColors.UNDERLINE +
            "Game start!\n"
        )
        for current_round in range(rounds):
            print(PrintColors.NORMAL +
                  PrintColors.HEADER +
                  f"Round {current_round + 1}:"
                  )
            self.play_round()
        print(
            PrintColors.NORMAL +
            PrintColors.UNDERLINE +
            "Game over!\n"
        )

        if self.win1 > self.win2:
            print(
                PrintColors.NORMAL +
                PrintColors.OKGREEN +
                "\tPlayer 1 Won!\n"
                f"\t    {self.win1} x {self.win2}\n"
                f"      Best of {self.rounds} rounds!\n"
            )
        elif self.win1 < self.win2:
            print(
                PrintColors.NORMAL +
                PrintColors.OKGREEN +
                f"\t{self.player2} Won!\n"
                f"\t    {self.win2} x {self.win1}\n"
                f"      Best of {self.rounds} rounds!\n"
            )
        else:
            print(
                PrintColors.NORMAL +
                PrintColors.OKBLUE +
                "\t It's a Tie!\n"
                f"\t    {self.win1} x {self.win2}\n"
                f"      Best of {self.rounds} rounds!\n"
            )


if __name__ == '__main__':
    # We want the game to only stops if the player wants so
    while True:
        # What type of game this user wants to play?
        print(
            PrintColors.NORMAL +
            PrintColors.BOLD +
            "\nWelcome to the awesome game of Rock, Paper or Scissors!\n\n"
            "Here are some rules:\n"
            "    This game consists on how many rounds you chose.\n"
            "    Press the number of the game you want to play.\n"
            "    Or type 'quit' to end the game at any time.\n\n"
        )
        rounds = 0
        while rounds < 1:
            rounds = input(
                PrintColors.NORMAL +
                "How many rounds do you want to play?\n"
            )
            if rounds == 'quit':
                exit()
            try:
                rounds = int(rounds)
                if rounds == 0:
                    print(
                        PrintColors.FAIL +
                        "It needs to be greater than 0!\n"
                    )
            except ValueError:
                print(
                    PrintColors.FAIL +
                    "Please enter a number!\n"
                )
                rounds = 0
        game_type = 0
        while game_type < 1 or game_type > 5:
            game_type = input(
                PrintColors.NORMAL +
                "What type of game do you want to play?\n"
                "1 - Watch a random game\n"
                "2 - Play random game\n"
                "3 - Play reflect game\n"
                "4 - Play cycle game\n"
                "5 - Play 'Rock' game\n"
            )
            if game_type == 'quit':
                exit()
            try:
                game_type = int(game_type)
                if game_type < 1 or game_type > 5:
                    print(
                        PrintColors.FAIL +
                        "\nPlease, type a number between 1 and 5!\n"
                    )
            except ValueError:
                print(
                    PrintColors.FAIL +
                    "\nYou need to type a number!\n"
                )
                game_type = 0

        # Based on the user input we play a different game
        if game_type == 1:
            game = Game(RandomPlayer(), RandomPlayer(), rounds)
            game.play_game()
        elif game_type == 2:
            game = Game(RandomPlayer(), HumanPlayer(), rounds)
            game.play_game()
        elif game_type == 3:
            game = Game(ReflectPlayer(), HumanPlayer(), rounds)
            game.play_game()
        elif game_type == 4:
            game = Game(CyclePlayer(), HumanPlayer(), rounds)
            game.play_game()
        elif game_type == 5:
            game = Game(Player(), HumanPlayer(), rounds)
            game.play_game()

        # Does the player wants to continue playing?
        continue_playing = ''
        while continue_playing != '1' and continue_playing != '2':
            continue_playing = input(
                PrintColors.WARNING +
                "Do you want to play again?\n"
                "1 - Yes\n"
                "2 - No\n"
            )
            if continue_playing == 'quit':
                exit()
            if continue_playing == '1':
                os.system('clear')
            elif continue_playing == '2':
                print(
                    PrintColors.NORMAL +
                    "\nGoodbye!"
                )
                exit()
            else:
                print(
                    PrintColors.FAIL +
                    "\nPlease, type a number between 1 and 2!\n"
                )
