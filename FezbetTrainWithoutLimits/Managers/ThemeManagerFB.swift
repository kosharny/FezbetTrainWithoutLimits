import SwiftUI
import Combine

class ThemeManagerFB: ObservableObject {
    @Published var selectedThemeIndex: Int {
        didSet {
            UserDefaults.standard.set(selectedThemeIndex, forKey: "selectedThemeIndex")
        }
    }
    
    init() {
        self.selectedThemeIndex = UserDefaults.standard.integer(forKey: "selectedThemeIndex")
    }
    
    let themes: [AppThemeFB] = [
        AppThemeFB(
            name: "Desert Gold",
            primaryColor: Color(hex: "F2C94C"),
            secondaryColor: Color(hex: "D89B3A"),
            backgroundColor: Color(hex: "1C1A17"),
            accentColor: Color(hex: "6B6A3D"),
            textColor: .white
        ),
        AppThemeFB(
            name: "Oasis Green",
            primaryColor: Color(hex: "6B6A3D"),
            secondaryColor: Color(hex: "8FBC8F"),
            backgroundColor: Color(hex: "1C1A17"),
            accentColor: Color(hex: "F2C94C"),
            textColor: .white
        ),
        AppThemeFB(
            name: "Sunset Red",
            primaryColor: Color(hex: "E07A5F"),
            secondaryColor: Color(hex: "F2CC8F"),
            backgroundColor: Color(hex: "3D405B"),
            accentColor: Color(hex: "81B29A"),
            textColor: .white
        )
    ]
    
    var currentTheme: AppThemeFB {
        themes[selectedThemeIndex]
    }
}

struct AppThemeFB {
    let name: String
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    let accentColor: Color
    let textColor: Color
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: 
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: 
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: 
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: 
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
