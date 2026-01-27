import SwiftUI

@main
struct FezbetAppFB: App {
    @StateObject private var mainViewModel = MainViewModelFB()
    @StateObject private var themeManager = ThemeManagerFB()
    @StateObject private var storeManager = StoreManagerFB()
    
    var body: some Scene {
        WindowGroup {
            MainViewFB()
                .environmentObject(mainViewModel)
                .environmentObject(themeManager)
                .environmentObject(storeManager)
                .preferredColorScheme(.dark) // Force dark mode/custom look
        }
    }
}


