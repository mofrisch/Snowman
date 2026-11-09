//
//  GuessesView.swift
//  Snowman
//
//  Created by Moritz Frisch on 09.11.26.
//

import SwiftUI

let guesses = ["E", "S", "R", "X"]

struct GuessesView: View {
    @Binding var game: Game
    @State var nextGuess = ""
    var body: some View {
        VStack {
            HStack {
                Text("Letters used:")
                Text(game.guesses.joined(separator: ", "))
            }

            LabeledContent("Guess a letter:") {
                TextField("", text: $nextGuess)
                    .frame(width: 50)
                    .textFieldStyle(.roundedBorder)
                    .disabled(game.gameStatus != .inProgress)
                    .onChange(of: nextGuess) { _, newValue in
                        game.processGuess(letter: newValue)
                        nextGuess = ""
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var game = Game()
    GuessesView(game: $game)
}
