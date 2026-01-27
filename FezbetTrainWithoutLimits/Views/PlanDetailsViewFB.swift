import SwiftUI

struct PlanDetailsViewFB: View {
    let title: String
    let description: String
    let image: String
    
    @EnvironmentObject var themeManager: ThemeManagerFB
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Image
                    ZStack(alignment: .topLeading) {
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 300)
                            .clipped()
                            .overlay(
                                LinearGradient(colors: [.clear, themeManager.currentTheme.backgroundColor], startPoint: .center, endPoint: .bottom)
                            )
                        
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.black.opacity(0.5)))
                                .padding(.top, 50)
                                .padding(.leading, 20)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(title.uppercased())
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white) // themeManager.currentTheme.primaryColor
                        
                        HStack(spacing: 15) {
                            BadgeFB(text: "4 WEEKS", color: themeManager.currentTheme.primaryColor)
                            BadgeFB(text: "HARD", color: .red)
                        }
                        
                        Text("OVERVIEW")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                        
                        Text(description)
                            .font(.body)
                            .foregroundColor(themeManager.currentTheme.textColor)
                            .lineSpacing(5)
                        
                        Divider().background(Color.gray.opacity(0.3))
                        
                        Text("SCHEDULE")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                        
                        // Fake Schedule
                        ForEach(1...4, id: \.self) { week in
                            HStack {
                                Text("Week \(week)")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("3 Sessions")
                                    .foregroundColor(.gray)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(hex: "2A2824"))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .offset(y: -50)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { withAnimation { mainViewModel.isTabBarVisible = false } }
        .onDisappear { withAnimation { mainViewModel.isTabBarVisible = true } }
    }
}

#Preview {
    PlanDetailsViewFB(title: "Desert Storm", description: "A brutal conditioning plan.", image: "training_plan_desert_storm")
        .environmentObject(ThemeManagerFB())
        .environmentObject(MainViewModelFB())
}
