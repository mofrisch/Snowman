//
//  ContentView.swift
//  Snowman
//
//  Created by Moritz Frisch on 09.11.26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("gameLanguage") private var preferredLanguage = GameLanguage.system
    @State private var showsLanguagePicker = false
    @State private var highlightedLanguage: GameLanguage?
    @FocusState private var languageOptionsFocused: Bool

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 250, ideal: 270, max: 290)
        } detail: {
            GameView(language: preferredLanguage)
                .disabled(showsLanguagePicker)
                .navigationSplitViewColumnWidth(min: 900, ideal: 970)
        }
        .overlay {
            if showsLanguagePicker {
                ZStack(alignment: .topTrailing) {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture { showsLanguagePicker = false }
                        .accessibilityHidden(true)

                    languageOptions
                        .padding(.top, 4)
                        .padding(.trailing, 8)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    highlightedLanguage = nil
                    showsLanguagePicker.toggle()
                } label: {
                    HStack(spacing: 8) {
                        languageTitle(preferredLanguage)
                        Image(systemName: "chevron.down")
                            .imageScale(.small)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, 6)
                }
                .accessibilityLabel(Text("Language"))
                .accessibilityValue(languageName(preferredLanguage))
                .help("Language")
            }
        }
        .environment(\.locale, Locale(identifier: preferredLanguage.rawValue))
    }
    // Present inside the window, aligned with the toolbar in both the app and previews.
    private var languageOptions: some View {
        VStack(spacing: 2) {
            languageOption(.german)
            languageOption(.english)
        }
        .frame(minWidth: 104)
        .fixedSize(horizontal: true, vertical: false)
        .padding(5)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 6, y: 2)
        .focusable()
        .focusEffectDisabled()
        .focused($languageOptionsFocused)
        .onAppear { languageOptionsFocused = true }
        .onKeyPress(keys: [.upArrow, .downArrow]) { _ in
            let current = highlightedLanguage ?? preferredLanguage
            highlightedLanguage = current == .german ? .english : .german
            return .handled
        }
        .onKeyPress(keys: [.return, .space], phases: .down) { _ in
            selectLanguage(highlightedLanguage ?? preferredLanguage)
            return .handled
        }
        .onExitCommand { showsLanguagePicker = false }
    }

    private func languageOption(_ language: GameLanguage) -> some View {
        let isSelected = preferredLanguage == language

        return Button {
            selectLanguage(language)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark")
                    .font(.caption.weight(.semibold))
                    .frame(width: 14)
                    .opacity(isSelected ? 1 : 0)
                    .accessibilityHidden(true)
                languageTitle(language)
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 28, alignment: .leading)
            .background {
                if highlightedLanguage == language {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.primary.opacity(0.12))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .onHover { isHovering in
            if isHovering {
                highlightedLanguage = language
            } else if highlightedLanguage == language {
                highlightedLanguage = nil
            }
        }
    }

    private func selectLanguage(_ language: GameLanguage) {
        showsLanguagePicker = false
        preferredLanguage = language
    }

    private func languageTitle(_ language: GameLanguage) -> Text {
        Text(verbatim: language == .german ? "🇩🇪 DE" : "🇺🇸 US")
            .accessibilityLabel(languageName(language))
    }

    private func languageName(_ language: GameLanguage) -> Text {
        Text(verbatim: language == .german ? "Deutsch" : "English")
    }
}

#Preview {
    ContentView()
}
