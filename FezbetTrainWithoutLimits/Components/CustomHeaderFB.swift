import SwiftUI

struct CustomHeaderFB: View {
    let title: String
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(themeManager.currentTheme.textColor)
                .shadow(color: themeManager.currentTheme.primaryColor.opacity(0.5), radius: 10)
            
            Spacer()
            
            NavigationLink(destination: SettingsViewFB()) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(themeManager.currentTheme.secondaryColor)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(themeManager.currentTheme.backgroundColor.opacity(0.5))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                            .overlay(
                                Circle().stroke(themeManager.currentTheme.accentColor.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
        }
        .padding(.horizontal)
        .padding(.top, 50) 
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [
                themeManager.currentTheme.backgroundColor,
                themeManager.currentTheme.backgroundColor.opacity(0.0)
            ], startPoint: .top, endPoint: .bottom)
        )
    }
}


