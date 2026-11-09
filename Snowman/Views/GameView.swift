//
//  GameView.swift
//  Snowman
//
//  Created by Moritz Frisch on 09.11.26.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        HStack {
            Image("0")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 230)

            Text("Enter a letter to guess the word.")
                .font(.title2)
        }
    }
}

#Preview {
    GameView()
}
