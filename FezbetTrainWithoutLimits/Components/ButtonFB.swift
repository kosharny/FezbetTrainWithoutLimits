import SwiftUI

struct ButtonFB: View {
    let title: String
    let icon: String?
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title.uppercased())
                    .fontWeight(.bold)
            }
            .foregroundColor(themeManager.currentTheme.backgroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [
                        themeManager.currentTheme.primaryColor,
                        themeManager.currentTheme.secondaryColor
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(15)
            .shadow(color: themeManager.currentTheme.primaryColor.opacity(0.5), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyleFB())
    }
}

struct ScaleButtonStyleFB: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
