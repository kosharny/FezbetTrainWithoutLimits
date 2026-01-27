import SwiftUI

struct ContentListViewFB: View {
    let title: String
    let content: ContentTypeFB
    
    @EnvironmentObject var themeManager: ThemeManagerFB
    @Environment(\.presentationMode) var presentationMode
    
    enum ContentTypeFB {
        case articles([ArticleFB])
        case tasks([TaskFB])
    }
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Back Button
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(themeManager.currentTheme.secondaryColor)
                    }
                    
                    Spacer()
                    
                    Text(title.uppercased())
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                    
                    Spacer()
                    
                    // Invisible spacer to balance title
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.clear)
                }
                .padding()
                .background(Color(hex: "2A2824"))
                
                ScrollView {
                    VStack(spacing: 15) {
                        switch content {
                        case .articles(let articles):
                            ForEach(articles) { article in
                                NavigationLink(destination: ArticleDetailsViewFB(article: article)) {
                                    ArticleRowCardFB(article: article)
                                }
                            }
                        case .tasks(let tasks):
                            ForEach(tasks) { task in
                                NavigationLink(destination: TaskDetailsViewFB(task: task)) {
                                    TaskRowCardFB(task: task)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Spacer(minLength: 80)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
