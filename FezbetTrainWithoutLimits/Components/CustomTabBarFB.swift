import SwiftUI

struct CustomTabBarFB: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    let tabs = [
        ("house.fill", "Home"),
        ("book.closed.fill", "Journal"),
        ("magnifyingglass", "Search"),
        ("heart.fill", "Favorites"),
        ("chart.bar.fill", "Stats")
    ]
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].0)
                            .font(.system(size: 24, weight: .bold))
                            .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                        
                        if selectedTab == index {
                            Circle()
                                .fill(themeManager.currentTheme.primaryColor)
                                .frame(width: 4, height: 4)
                                .transition(.scale)
                        }
                    }
                    .foregroundColor(selectedTab == index ? themeManager.currentTheme.primaryColor : .gray)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            ZStack {
                VisualEffectBlurFB(blurStyle: .systemUltraThinMaterialDark)
                themeManager.currentTheme.backgroundColor.opacity(0.8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(color: themeManager.currentTheme.primaryColor.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

// Helper for blur
struct VisualEffectBlurFB: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    CustomTabBarFB(selectedTab: .constant(0))
        .environmentObject(ThemeManagerFB())
}
