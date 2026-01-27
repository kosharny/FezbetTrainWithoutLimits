import SwiftUI

struct SearchViewFB: View {
    @EnvironmentObject var mainViewModel: MainViewModelFB
    @EnvironmentObject var themeManager: ThemeManagerFB
    @State private var searchText = ""
    
    @State private var selectedFilter: SearchFilter = .all
    @State private var selectedDifficulty: String = "Any"
    @State private var selectedTime: String = "Any"
    
    enum SearchFilter: String, CaseIterable {
        case all = "All"
        case articles = "Articles"
        case tasks = "Tasks"
    }
    
    let difficulties = ["Any", "Easy", "Medium", "Hard"]
    
    var filteredArticles: [ArticleFB] {
        if selectedFilter == .tasks { return [] }
        var result = mainViewModel.articles
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }
    
    var filteredTasks: [TaskFB] {
        if selectedFilter == .articles { return [] }
        var result = mainViewModel.tasks
        
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        if selectedDifficulty != "Any" {
            result = result.filter { $0.difficulty == selectedDifficulty }
        }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderFB(title: "Search")
                    
                    // Custom Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search topics...", text: $searchText)
                            .foregroundColor(.white)
                            .accentColor(themeManager.currentTheme.primaryColor)
                    }
                    .padding()
                    .background(Color(hex: "2A2824"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Filter Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(SearchFilter.allCases, id: \.self) { filter in
                                Button(action: { selectedFilter = filter }) {
                                    Text(filter.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 8)
                                        .background(selectedFilter == filter ? themeManager.currentTheme.primaryColor : Color(hex: "2A2824"))
                                        .foregroundColor(selectedFilter == filter ? themeManager.currentTheme.backgroundColor : .gray)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                    
                    if selectedFilter != .articles {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                Text("Difficulty:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                ForEach(difficulties, id: \.self) { diff in
                                    Button(action: { selectedDifficulty = diff }) {
                                        Text(diff)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(selectedDifficulty == diff ? themeManager.currentTheme.secondaryColor : Color(hex: "2A2824"))
                                            .foregroundColor(selectedDifficulty == diff ? .black : .gray)
                                            .cornerRadius(15)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                    }
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            if !filteredArticles.isEmpty {
                                Text("ARTICLES")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                ForEach(filteredArticles) { article in
                                    NavigationLink(destination: ArticleDetailsViewFB(article: article)) {
                                        ArticleRowCardFB(article: article)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            
                            if !filteredTasks.isEmpty {
                                Text("TASKS")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                ForEach(filteredTasks) { task in
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
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SearchViewFB()
        .environmentObject(MainViewModelFB())
        .environmentObject(ThemeManagerFB())
}
