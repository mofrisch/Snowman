//
//  Game.swift
//  Snowman
//
//  Created by Moritz Frisch on 09.11.26.
//

struct Game {
    var incorrectGuessCount = 0
    var statusText = "Enter a letter to start the game."
    var word = "SNOWMAN"
    var guesses: [String] = []
}
