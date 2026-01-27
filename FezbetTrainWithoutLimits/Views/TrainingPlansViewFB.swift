import SwiftUI

struct TrainingPlansViewFB: View {
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header with Back Button
                HStack {
                    Button(action: {
                        mainViewModel.isTabBarVisible = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(themeManager.currentTheme.secondaryColor)
                    }
                    Spacer()
                    Text("TRAINING PLANS")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        PlanCardFB(
                            title: "Pre-Season Conditioning",
                            duration: "4 Weeks",
                            level: "Advanced",
                            image: "training_plan_desert_storm",
                            description: "Build an engine that can withstand 90 minutes in 40°C heat. Focus on aerobic capacity and heat tolerance."
                        )
                        
                        PlanCardFB(
                            title: "In-Season Maintenance",
                            duration: "Ongoing",
                            level: "Intermediate",
                            image: "training_plan_oasis_calm",
                            description: "Balance training load with match demands. Protect your hydration levels and recovery status."
                        )
                        
                        PlanCardFB(
                            title: "Speed & Power Phase",
                            duration: "6 Weeks",
                            level: "Pro",
                            image: "task_sprint_sand",
                            description: "Convert your strength into explosive power on the pitch. Warning: High intensity."
                        )
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation { mainViewModel.isTabBarVisible = false }
        }
    }
}

struct PlanCardFB: View {
    let title: String
    let duration: String
    let level: String
    let image: String
    let description: String
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(image) // Placeholder
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title.uppercased())
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                    Spacer()
                    Text(duration)
                        .font(.caption)
                        .padding(5)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(5)
                        .foregroundColor(.white)
                }
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(themeManager.currentTheme.textColor.opacity(0.8))
                    .lineLimit(3)
                
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(themeManager.currentTheme.secondaryColor)
                    Text(level)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    
                    // Correct Navigation Link usage
                    NavigationLink(destination: PlanDetailsViewFB(title: title, description: description, image: image)) {
                        Text("VIEW PLAN")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(themeManager.currentTheme.primaryColor)
                            .foregroundColor(themeManager.currentTheme.backgroundColor)
                            .cornerRadius(15)
                    }
                }
            }
            .padding()
            .background(Color(hex: "2A2824"))
        }
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    TrainingPlansViewFB()
        .environmentObject(ThemeManagerFB())
}
