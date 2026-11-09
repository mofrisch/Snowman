//
//  Game.swift
//  Snowman
//
//  Created by Moritz Frisch on 09.11.26.
//
import SwiftUI

struct Game {
    private static let englishWords = loadWords(for: .english)
    private static let germanWords = loadWords(for: .german)

    let language: GameLanguage
    var incorrectGuessCount = 0
    var word: String
    var guesses: [String] = []
    var gameStatus = GameStatus.inProgress

    var letters: [Letter] {
        var lettersArray: [Letter] = []
        for (index, char) in word.enumerated() {
            let charString = String(char)
            if guesses.contains(charString) {
                let letter = Letter(id: index, char: charString)
                lettersArray.append(letter)
            } else if gameStatus == .lost {
                let letter = Letter(id: index, char: charString, color: .red)
                lettersArray.append(letter)
            } else {
                let letter = Letter(id: index, char: "")
                lettersArray.append(letter)
            }
        }
        return lettersArray
    }
    
    mutating func processGuess(letter: String) {
        guard let letter = letter.first, Self.isPlayableLetter(letter) else { return }

        let newGuess = letter.uppercased()
        guard !guesses.contains(newGuess) else { return }
        
        if !word.contains(newGuess) && incorrectGuessCount < 7 {
            incorrectGuessCount += 1
        }
        guesses.append(newGuess)
        checkForGameOver()
    }
    
    mutating func checkForGameOver() {
        let unmatchedLetters = word.filter { letter in
            !guesses.contains(String(letter))
        }
        if unmatchedLetters.isEmpty {
            gameStatus = .won
        } else if incorrectGuessCount == 7 {
            gameStatus = .lost
        }
    }

    private static func isPlayableLetter(_ letter: Character) -> Bool {
        letter.isASCII && letter.isLetter
    }

    private static func loadWords(for language: GameLanguage) -> [String] {
        guard
            let url = Bundle.main.url(forResource: language.wordListName, withExtension: "txt"),
            let wordsList = try? String(contentsOf: url, encoding: .utf8)
        else {
            return []
        }

        return wordsList.split(whereSeparator: \.isNewline)
            .filter { (4...10).contains($0.count) && $0.allSatisfy(isPlayableLetter) }
            .map { $0.uppercased() }
    }

    init(language: GameLanguage = .system) {
        self.language = language
        let words = language == .german ? Self.germanWords : Self.englishWords
        word = words.randomElement() ?? language.fallbackWord
    }
}
