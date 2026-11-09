import Foundation

enum GameLanguage: String {
    case english = "en"
    case german = "de"

    static var system: Self {
        Bundle.main.preferredLocalizations.compactMap(Self.init(rawValue:)).first ?? .english
    }

    var wordListName: String {
        self == .german ? "words-de" : "words"
    }

    var fallbackWord: String {
        self == .german ? "SCHNEEMANN" : "SNOWMAN"
    }
}
