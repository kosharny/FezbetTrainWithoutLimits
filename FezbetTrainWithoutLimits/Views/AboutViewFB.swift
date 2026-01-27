import SwiftUI

struct AboutViewFB: View {
    @EnvironmentObject var themeManager: ThemeManagerFB
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(themeManager.currentTheme.secondaryColor)
                    }
                    Spacer()
                    Text("ABOUT")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    Spacer()
                }
                .padding()
                
                ZStack {
                    AngularGradient(gradient: Gradient(colors: [
                        themeManager.currentTheme.primaryColor,
                        themeManager.currentTheme.secondaryColor,
                        Color(hex: "3A2F24"),
                        themeManager.currentTheme.primaryColor
                    ]), center: .center)
                    .frame(width: 200, height: 200)
                    .opacity(0.5)
                    .blur(radius: 50)
                    
                    Image("mainLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                
                Text("Fezbet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Version \(Bundle.main.version ?? "1.0")")
                    .foregroundColor(.gray)
                
                Text("Train without limits. Master the desert environment and elevate your football performance to professional standards.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .padding()
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    var version: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

#Preview {
    AboutViewFB()
        .environmentObject(ThemeManagerFB())
}
