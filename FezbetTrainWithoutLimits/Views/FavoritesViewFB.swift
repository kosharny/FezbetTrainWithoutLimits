import SwiftUI

struct FavoritesViewFB: View {
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var favoriteArticles: [ArticleFB] {
        mainViewModel.articles.filter { mainViewModel.isFavorite(articleId: $0.id) }
    }
    var favoriteTasks: [TaskFB] {
        mainViewModel.tasks.filter { mainViewModel.isFavorite(taskId: $0.id) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderFB(title: "Favorites")
                    
                    if favoriteArticles.isEmpty && favoriteTasks.isEmpty {
                        VStack {
                            Spacer()
                            Image(systemName: "heart.slash")
                                .font(.system(size: 60))
                                .foregroundColor(themeManager.currentTheme.secondaryColor.opacity(0.5))
                            Text("No favorites yet.")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 20) {
                                if !favoriteArticles.isEmpty {
                                    Text("ARTICLES")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                    
                                    ForEach(favoriteArticles) { article in
                                        NavigationLink(destination: ArticleDetailsViewFB(article: article)) {
                                            ArticleRowCardFB(article: article)
                                                .padding(.horizontal)
                                        }
                                    }
                                }
                                
                                if !favoriteTasks.isEmpty {
                                    Text("SAVED TASKS")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                    
                                    ForEach(favoriteTasks) { task in
                                        NavigationLink(destination: TaskDetailsViewFB(task: task)) {
                                            TaskRowCardFB(task: task)
                                                .padding(.horizontal)
                                        }
                                    }
                                }
                            }
                            .padding(.top)
                            
                            Spacer(minLength: 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    FavoritesViewFB()
        .environmentObject(MainViewModelFB())
        .environmentObject(ThemeManagerFB())
}
