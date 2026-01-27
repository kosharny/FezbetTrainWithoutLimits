import SwiftUI

struct StatisticsViewFB: View {
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var completedTasksCount: Int {
        mainViewModel.completedTaskIDs.count
    }
    
    var totalTasksCount: Int {
        mainViewModel.tasks.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderFB(title: "Statistics")
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("OVERALL PROGRESS")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            CircularProgressViewFB(progress: mainViewModel.progress)
                                .frame(width: 150, height: 150)
                                .padding()
                                .overlay(
                                    Text("\(Int(mainViewModel.progress * 100))%")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(themeManager.currentTheme.primaryColor)
                                )
                            
                            HStack(spacing: 20) {
                                StatCardFB(title: "COMPLETED", value: "\(completedTasksCount)", icon: "checkmark.circle.fill")
                                StatCardFB(title: "REMAINING", value: "\(totalTasksCount - completedTasksCount)", icon: "hourglass")
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 20) {
                                StatCardFB(title: "FAVORITES", value: "\(mainViewModel.favoriteArticleIDs.count + mainViewModel.favoriteTaskIDs.count)", icon: "heart.fill")
                                StatCardFB(title: "STREAK", value: "\(mainViewModel.streakCount) Days", icon: "flame.fill")
                            }
                            .padding(.horizontal)
                            
                            // Activity Graph
                            VStack(alignment: .leading, spacing: 15) {
                                Text("ACTIVITY (LAST 7 DAYS)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                HStack(alignment: .bottom, spacing: 12) {
                                    ForEach(0..<7) { index in
                                        VStack {
                                            Spacer()
                                            RoundedRectangle(cornerRadius: 3)
                                                .fill(index == 6 ? themeManager.currentTheme.primaryColor : Color.gray.opacity(0.3))
                                                .frame(height: CGFloat.random(in: 20...100)) // Dummy Data
                                            
                                            Text(["M", "T", "W", "T", "F", "S", "S"][index])
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .frame(height: 150)
                                .padding()
                                .background(Color(hex: "2A2824"))
                                .cornerRadius(15)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top)
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    StatisticsViewFB()
        .environmentObject(MainViewModelFB())
        .environmentObject(ThemeManagerFB())
}

struct StatCardFB: View {
    let title: String
    let value: String
    let icon: String
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(themeManager.currentTheme.secondaryColor)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "2A2824"))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
