import SwiftUI

struct MainViewFB: View {
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var showSplash: Bool = true
    @State private var selectedTab: Int = 0
    
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashViewFB(isActive: $showSplash)
                    .zIndex(2)
            } else if !hasCompletedOnboarding {
                OnboardingViewFB(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .zIndex(1)
            } else {
                // Main Content
                ZStack(alignment: .bottom) {
                    
                    // Background
                    LinearGradient(
                        colors: [
                            themeManager.currentTheme.backgroundColor,
                            themeManager.currentTheme.backgroundColor.opacity(0.9),
                            themeManager.currentTheme.secondaryColor.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    Group {
                        switch selectedTab {
                        case 0: HomeViewFB()
                        case 1: JournalViewFB()
                        case 2: SearchViewFB()
                        case 3: FavoritesViewFB()
                        case 4: StatisticsViewFB()
                        default: HomeViewFB()
                        }
                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .zIndex(0)
                .safeAreaInset(edge: .bottom) {
                    if mainViewModel.isTabBarVisible {
                        CustomTabBarFB(selectedTab: $selectedTab)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
        }
    }
}
