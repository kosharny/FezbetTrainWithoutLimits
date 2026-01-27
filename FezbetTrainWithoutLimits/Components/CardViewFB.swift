import SwiftUI

struct CardViewFB<Content: View>: View {
    let content: Content
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(themeManager.currentTheme.backgroundColor)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    themeManager.currentTheme.primaryColor.opacity(0.6),
                                    themeManager.currentTheme.secondaryColor.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                }
            )
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// Extension to apply to any view
extension View {
    func cardStyleFB() -> some View {
        CardViewFB { self }
    }
}
