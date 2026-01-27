import SwiftUI

struct SplashViewFB: View {
    @Binding var isActive: Bool
    @State private var scale = 0.8
    @State private var opacity = 0.0
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        ZStack {
            ZStack {
                // Background
            ZStack {
                AngularGradient(gradient: Gradient(colors: [
                    themeManager.currentTheme.primaryColor,
                    themeManager.currentTheme.secondaryColor,
                    Color(hex: "3A2F24"),
                    themeManager.currentTheme.primaryColor
                ]), center: .center)
                .ignoresSafeArea()
                .opacity(0.2)
                .blur(radius: 50)
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        themeManager.currentTheme.primaryColor.opacity(0.4),
                        .black.opacity(0.8)
                    ]),
                    center: .center,
                    startRadius: 5,
                    endRadius: 600
                )
                .ignoresSafeArea()
            }
                
                VStack {
                    Image("mainLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Text("FEZBET")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                        .tracking(5)
                    
                    Text("TRAIN WITHOUT LIMITS")
                        .font(.caption)
                        .foregroundColor(themeManager.currentTheme.secondaryColor)
                        .tracking(2)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.5)) {
                        scale = 1.0
                        opacity = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            isActive = false
                        }
                    }
                }
            }
        }
    }
}
