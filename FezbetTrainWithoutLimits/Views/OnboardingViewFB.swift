import SwiftUI

struct OnboardingViewFB: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    let slides = [
        OnboardingSlide(image: "onboarding_1", title: "TRAIN IN THE HEAT", description: "Master the elements. Adopt to dry, arid climates and push your limits where others fail."),
        OnboardingSlide(image: "onboarding_2", title: "SCIENCE BASED HYDRATION", description: "Learn the secrets of hydration and recovery used by elite athletes in equatorial regions."),
        OnboardingSlide(image: "onboarding_3", title: "BECOME A LEGEND", description: "Follow our specialized tasks and articles to elevate your game to the next level.")
    ]
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Content
                TabView(selection: $currentPage) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            Image(slides[index].image) 
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 350, maxHeight: 250)
                                .cornerRadius(30)
                                .padding(.horizontal)
                                .shadow(color: themeManager.currentTheme.primaryColor.opacity(0.3), radius: 20)
                            
                            Text(slides[index].title)
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(themeManager.currentTheme.primaryColor)
                                .multilineTextAlignment(.center)
                            
                            Text(slides[index].description)
                                .font(.body)
                                .foregroundColor(themeManager.currentTheme.textColor.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer()
                
                // Indicators & Button
                VStack(spacing: 30) {
                    HStack(spacing: 10) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? themeManager.currentTheme.primaryColor : Color.gray.opacity(0.5))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                        }
                    }
                    
                    ButtonFB(title: currentPage == slides.count - 1 ? "Start Journey" : "Next") {
                        if currentPage < slides.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            withAnimation {
                                hasCompletedOnboarding = true
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
            // Skip Button
            .overlay(
                Button(action: {
                    withAnimation { hasCompletedOnboarding = true }
                }) {
                    Text("SKIP")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentTheme.textColor.opacity(0.6))
                        .padding()
                }
                .padding(.top, 20)
                .padding(.trailing, 20),
                alignment: .topTrailing
            )
        }
    }
}

struct OnboardingSlide {
    let image: String
    let title: String
    let description: String
}

#Preview {
    OnboardingViewFB(hasCompletedOnboarding: .constant(false))
        .environmentObject(ThemeManagerFB())
}
