import SwiftUI

struct JournalViewFB: View {
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var completedTasks: [TaskFB] {
        mainViewModel.tasks.filter { mainViewModel.isCompleted(taskId: $0.id) }
    }
    
    var readArticles: [ArticleFB] {
        mainViewModel.articles.filter { mainViewModel.readArticleIDs.contains($0.id) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderFB(title: "Journal")
                    
                    if completedTasks.isEmpty && readArticles.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            Image(systemName: "book.closed")
                                .font(.system(size: 60))
                                .foregroundColor(themeManager.currentTheme.secondaryColor.opacity(0.5))
                            Text("No history yet.")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                if !completedTasks.isEmpty {
                                    Text("COMPLETED TASKS")
                                        .font(.headline)
                                        .foregroundColor(themeManager.currentTheme.primaryColor)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                    
                                    ForEach(completedTasks) { task in
                                        JournalRowFB(title: task.title, type: "Task Completed", icon: "checkmark.seal.fill")
                                    }
                                }
                                
                                if !readArticles.isEmpty {
                                    Text("READ ARTICLES")
                                        .font(.headline)
                                        .foregroundColor(themeManager.currentTheme.primaryColor)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                    
                                    ForEach(readArticles) { article in
                                        JournalRowFB(title: article.title, type: "Article Read", icon: "book.fill")
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

struct JournalRowFB: View {
    let title: String
    let type: String
    let icon: String
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(themeManager.currentTheme.primaryColor)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(type)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(hex: "2A2824"))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    JournalViewFB()
        .environmentObject(MainViewModelFB())
        .environmentObject(ThemeManagerFB())
}
