//
//  GameView.swift
//  Snowman
//
//  Created by Moritz Frisch on 09.11.26.
//

import SwiftUI

struct GameView: View {
    private let language: GameLanguage
    @State private var game: Game

    init(language: GameLanguage = .system) {
        self.language = language
        _game = State(initialValue: Game(language: language))
    }
    
    var body: some View {
        HStack {
            Image("\(game.incorrectGuessCount)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 230)
            
            Spacer()

            VStack(spacing: 30) {
                Spacer()
                
                statusText
                    .font(.title2)
                
                LettersView(letters: game.letters)
                
                
                Spacer()
                
                Button("New Game") {
                    game = Game(language: game.language)
                }
                .keyboardShortcut(.defaultAction)
                .opacity(game.gameStatus == .inProgress ? 0 : 1)
                .disabled(game.gameStatus == .inProgress)
                
                Spacer()
                
                GuessesView(game: $game)
                
            }
            .padding()
            
            Spacer()
        }
        .onChange(of: language) { _, language in
            game = Game(language: language)
        }
    }

    private var statusText: Text {
        switch game.gameStatus {
        case .inProgress where game.guesses.isEmpty:
            Text("Enter a letter to start the game.")
        case .inProgress:
            Text("Enter another letter to guess the word.")
        case .won:
            Text("HOORAY!!!! YOU WON!")
        case .lost:
            Text("You lost. Better luck next time.")
        }
    }
}

#Preview {
    GameView()
}
