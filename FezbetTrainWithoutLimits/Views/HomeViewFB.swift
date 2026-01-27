import SwiftUI

struct HomeViewFB: View {
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        // Header
                        CustomHeaderFB(title: "Training Camp")
                        
                        // Hero Content
                        if let heroArticle = mainViewModel.articles.first {
                            NavigationLink(destination: ArticleDetailsViewFB(article: heroArticle)) {
                                HeroCardFB(article: heroArticle)
                            }
                        }
                        
                        // Progress Section
                        VStack(alignment: .leading) {
                            Text("YOUR MASTERY")
                                .font(.headline)
                                .foregroundColor(themeManager.currentTheme.textColor.opacity(0.7))
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(Int(mainViewModel.progress * 100))%")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(themeManager.currentTheme.primaryColor)
                                    Text("Tasks Completed")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                CircularProgressViewFB(progress: mainViewModel.progress)
                                    .frame(width: 50, height: 50)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(hex: "2A2824"))
                                    .shadow(color: .black.opacity(0.2), radius: 5)
                            )
                        }
                        .padding(.horizontal)
                        
                        // Recent Articles
                        VStack(alignment: .leading) {
                            HStack {
                                Text("LATEST INSIGHTS")
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.textColor.opacity(0.7))
                                Spacer()
                                NavigationLink(destination: ContentListViewFB(title: "All Articles", content: .articles(mainViewModel.articles))) {
                                    Text("See All")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(themeManager.currentTheme.primaryColor)
                                }
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(mainViewModel.articles.dropFirst().prefix(5)) { article in
                                        NavigationLink(destination: ArticleDetailsViewFB(article: article)) {
                                            MiniArticleCardFB(article: article)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Tasks Preview
                        VStack(alignment: .leading) {
                            HStack {
                                Text("ACTIVE CHALLENGES")
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.textColor.opacity(0.7))
                                Spacer()
                                NavigationLink(destination: ContentListViewFB(title: "All Challenges", content: .tasks(mainViewModel.tasks))) {
                                    Text("See All")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(themeManager.currentTheme.primaryColor)
                                }
                            }
                            .padding(.horizontal)
                            
                            ForEach(mainViewModel.tasks.prefix(3)) { task in
                                NavigationLink(destination: TaskDetailsViewFB(task: task)) {
                                    TaskRowCardFB(task: task)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Extra Sections
                        VStack(spacing: 15) {
                            NavigationLink(destination: TrainingPlansViewFB()) {
                                ButtonFB(title: "Training Plans", icon: "calendar") {}
                                    .allowsHitTesting(false) // Let NavigationLink handle tap
                            }
                            
                            NavigationLink(destination: ClimateAdaptationViewFB()) {
                                ButtonFB(title: "Climate Adaptation Guide", icon: "thermometer") {}
                                    .allowsHitTesting(false)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        
                        Spacer(minLength: 80)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

// Subcomponents for Home
struct HeroCardFB: View {
    let article: ArticleFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(article.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("FEATURED")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.currentTheme.primaryColor)
                
                Text(article.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .background(Color(hex: "2A2824"))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

struct MiniArticleCardFB: View {
    let article: ArticleFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(article.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 100)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(article.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(article.subtitle)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    Spacer()
//                    if article.isPremium {
//                        Image(systemName: "lock.fill")
//                            .font(.caption2)
//                            .foregroundColor(.yellow)
//                    }
                }
            }
            .padding(10)
        }
        .frame(width: 160, height: 170)
        .background(Color(hex: "2A2824"))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

struct TaskRowCardFB: View {
    let task: TaskFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        HStack(spacing: 15) {
            Image(task.imageName) // Placeholder image handling
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack {
                    BadgeFB(text: task.difficulty, color: themeManager.currentTheme.secondaryColor)
                    
                    if task.isCompletionTimeUnknown {
                         // Fallback
                    } else {
                        // Text("\(task.steps.count * 5) min") .font(.caption).foregroundColor(.gray)
                    }
                    Text("\(task.steps.count) Steps")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(themeManager.currentTheme.primaryColor)
        }
        .padding(10)
        .background(Color(hex: "2A2824"))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

extension TaskFB {
    var isCompletionTimeUnknown: Bool { true }
}

struct ArticleRowCardFB: View {
    let article: ArticleFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        HStack(spacing: 15) {
            Image(article.imageName) // Placeholder
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(article.subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                HStack {
                    BadgeFB(text: "READ", color: themeManager.currentTheme.secondaryColor)
//                    if article.isPremium {
//                        Image(systemName: "lock.fill")
//                            .font(.caption)
//                            .foregroundColor(.yellow)
//                    }
                }
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(themeManager.currentTheme.primaryColor)
        }
        .padding(10)
        .background(Color(hex: "2A2824"))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    HomeViewFB()
        .environmentObject(MainViewModelFB())
        .environmentObject(ThemeManagerFB())
}


struct CircularProgressViewFB: View {
    let progress: Double
    @EnvironmentObject var themeManager: ThemeManagerFB
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 5)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(themeManager.currentTheme.primaryColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}


