import SwiftUI

struct ArticleDetailsViewFB: View {
    let article: ArticleFB
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero Image
                    ZStack(alignment: .topLeading) {
                        Image(article.imageName) // Placeholder image handling
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                            .overlay(
                                LinearGradient(colors: [.black.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom)
                            )
                        
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.black.opacity(0.4)))
                                .padding(.top, 40)
                                .padding(.leading, 20)
                        }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text(article.title.uppercased())
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .foregroundColor(themeManager.currentTheme.primaryColor)
                            
                            Spacer()
                            
                            Button(action: {
                                mainViewModel.toggleFavorite(articleId: article.id)
                            }) {
                                Image(systemName: mainViewModel.isFavorite(articleId: article.id) ? "heart.fill" : "heart")
                                    .font(.title)
                                    .foregroundColor(themeManager.currentTheme.secondaryColor)
                            }
                        }
                        
                        Text(article.dateString)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Divider().background(themeManager.currentTheme.primaryColor)
                        
                        VStack(spacing: 15) {
                            ForEach(article.content.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                                if !paragraph.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    Text(paragraph)
                                        .font(.body)
                                        .foregroundColor(themeManager.currentTheme.textColor)
                                        .lineSpacing(6)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(hex: "2A2824"))
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(themeManager.currentTheme.primaryColor.opacity(0.3), lineWidth: 1)
                                        )
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                }
                            }
                        }
                        
                        Spacer(minLength: 20)
                        ButtonFB(title: "MARK AS READ") {
                            mainViewModel.markArticleAsRead(articleId: article.id)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .padding()
                    .background(themeManager.currentTheme.backgroundColor)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .offset(y: -40)
                }
                .ignoresSafeArea(edges: .top)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation { mainViewModel.isTabBarVisible = false }
        }
        .onDisappear {
            withAnimation { mainViewModel.isTabBarVisible = true }
        }
    }
}

extension ArticleFB {
    // Helper for date if needed, or just static string
    var dateString: String {
        "Published Today"
    }
}

#Preview {
    ArticleDetailsViewFB(article: ArticleFB(id: UUID(), title: "Test Article", subtitle: "Subtitle", imageName: "home_hero", content: "Content", isPremium: false))
        .environmentObject(MainViewModelFB())
        .environmentObject(ThemeManagerFB())
}
