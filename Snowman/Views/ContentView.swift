//
//  ContentView.swift
//  Snowman
//
//  Created by Moritz Frisch on 09.11.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            GameView()
        }
    }
}

#Preview {
    ContentView()
}
