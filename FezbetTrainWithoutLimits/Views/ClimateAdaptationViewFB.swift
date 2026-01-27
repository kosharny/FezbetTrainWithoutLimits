import SwiftUI

struct ClimateAdaptationViewFB: View {
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header Image
                    ZStack(alignment: .topLeading) {
                        Image("article_heat_recovery")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .overlay(Color.black.opacity(0.3))
                        
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.black.opacity(0.5)))
                                .padding(.top, 40)
                                .padding(.leading, 20)
                        }
                        
                        Text("CLIMATE\nADAPTATION")
                            .font(.system(size: 40, weight: .black))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .padding(.top, 100)
                    }
                    
                    VStack(alignment: .leading, spacing: 25) {
                        InfoBlockFB(
                            icon: "thermometer.sun.fill",
                            title: "Acclimatization Protocol",
                            text: "It takes 14 days to fully acclimatize. Start with 20 min sessions and increase by 10% daily."
                        )
                        
                        InfoBlockFB(
                            icon: "drop.fill",
                            title: "Fluid Dynamics",
                            text: "You lose up to 2.5L of sweat per hour. Weigh yourself before and after every session."
                        )
                        
                        InfoBlockFB(
                            icon: "lungs.fill",
                            title: "Oxygen Intake",
                            text: "Hot air is less dense. Your lungs must work harder. Practice diaphragm breathing."
                        )
                        
                        InfoBlockFB(
                            icon: "sun.max.fill",
                            title: "Solar Loading",
                            text: "Direct sunlight increases heat stress by 10°C. Seek shade immediately during rest intervals."
                        )
                    }
                    .padding()
                    .background(themeManager.currentTheme.backgroundColor)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .offset(y: -30)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { withAnimation { mainViewModel.isTabBarVisible = false } }
        .onDisappear { withAnimation { mainViewModel.isTabBarVisible = true } }
    }
}

struct InfoBlockFB: View {
    let icon: String
    let title: String
    let text: String
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(themeManager.currentTheme.primaryColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(text)
                    .font(.body)
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }
        }
        .padding()
        .background(Color(hex: "2A2824"))
        .cornerRadius(15)
    }
}

#Preview {
    ClimateAdaptationViewFB()
        .environmentObject(ThemeManagerFB())
}
