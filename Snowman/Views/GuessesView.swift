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
    @Environment(\.isEnabled) private var isEnabled
    @State var nextGuess = ""
    @State private var spellingHintID: UUID?
    @FocusState var entryFieldHasFocus: Bool
    var body: some View {
        let canEnterGuess = isEnabled && game.gameStatus == .inProgress

        VStack {
            if game.language == .german {
                Text("Use AE, OE, UE and SS for Ä, Ö, Ü and ß.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(spellingHintID == nil ? 0 : 1)
                    .accessibilityHidden(spellingHintID == nil)
            }

            HStack {
                Text("Letters used:")
                Text(game.guesses.joined(separator: ", "))
            }

            LabeledContent("Guess a letter:") {
                TextField(text: $nextGuess) { Text(verbatim: "") }
                    .frame(width: 50)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!canEnterGuess)
                    .onChange(of: nextGuess) { _, newValue in
                        if game.language == .german,
                           let letter = newValue.first,
                           "ÄÖÜäöüßẞ".contains(letter) {
                            spellingHintID = UUID()
                        }
                        game.processGuess(letter: newValue)
                        nextGuess = ""
                    }
                    .focused($entryFieldHasFocus)
                    .onChange(of: canEnterGuess, initial: true) {
                        entryFieldHasFocus = canEnterGuess
                    }
            }
        }
        .onChange(of: game.language) {
            spellingHintID = nil
        }
        .task(id: spellingHintID) { [id = spellingHintID] in
            guard let id else { return }
            do {
                try await Task.sleep(for: .seconds(3))
            } catch {
                return
            }
            if spellingHintID == id {
                spellingHintID = nil
            }
        }
    }
}

#Preview {
    @Previewable @State var game = Game()
    GuessesView(game: $game)
}
