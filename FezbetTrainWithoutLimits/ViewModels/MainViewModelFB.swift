import SwiftUI
import Combine

class MainViewModelFB: ObservableObject {
    @Published var articles: [ArticleFB] = []
    @Published var tasks: [TaskFB] = []
    
    // User State
    @Published var favoriteArticleIDs: Set<UUID> = []
    @Published var favoriteTaskIDs: Set<UUID> = []
    @Published var completedTaskIDs: Set<UUID> = []
    @Published var readArticleIDs: Set<UUID> = []
    @Published var isTabBarVisible: Bool = true
    
    // Streak State
    @Published var streakCount: Int = 0
    
    // Services
    private let dataManager = DataManagerFB.shared
    
    init() {
        loadData()
    }
    
    func loadData() {
        self.articles = dataManager.load("articles.json")
        self.tasks = dataManager.load("tasks.json")
        
        // Load persistence
        self.favoriteArticleIDs = dataManager.loadFavorites()
        self.completedTaskIDs = dataManager.loadCompletedTasks()
        self.readArticleIDs = dataManager.loadReadArticles()
        self.streakCount = dataManager.loadStreak()
        
        // Check streak on launch
        checkStreak()
    }
    
    // MARK: - Streak Logic
    private func checkStreak() {
        let calendar = Calendar.current
        guard let lastDate = dataManager.loadLastActiveDate() else { return }
        
        if calendar.isDateInYesterday(lastDate) {
            // Continued streak
        } else if calendar.isDateInToday(lastDate) {
            // Already active today
        } else {
            // Streak broken
            streakCount = 0
            dataManager.saveStreak(0)
        }
    }
    
    private func updateStreak() {
        let calendar = Calendar.current
        let today = Date()
        
        if let lastDate = dataManager.loadLastActiveDate() {
            if calendar.isDateInToday(lastDate) {
                return // Already updated for today
            } else if calendar.isDateInYesterday(lastDate) {
                streakCount += 1
            } else {
                streakCount = 1 // Reset or start new
            }
        } else {
            streakCount = 1 // First ever activity
        }
        
        dataManager.saveStreak(streakCount)
        dataManager.saveLastActiveDate(today)
    }
    
    // MARK: - Article Logic
    func markArticleAsRead(articleId: UUID) {
        if !readArticleIDs.contains(articleId) {
            readArticleIDs.insert(articleId)
            dataManager.saveReadArticles(ids: readArticleIDs)
            updateStreak()
        }
    }
    
    func toggleFavorite(articleId: UUID) {
        if favoriteArticleIDs.contains(articleId) {
            favoriteArticleIDs.remove(articleId)
        } else {
            favoriteArticleIDs.insert(articleId)
        }
        dataManager.saveFavorites(ids: favoriteArticleIDs)
    }
    
    func isFavorite(articleId: UUID) -> Bool {
        favoriteArticleIDs.contains(articleId)
    }
    
    // MARK: - Task Logic
    func toggleFavorite(taskId: UUID) {
        if favoriteArticleIDs.contains(taskId) {
            favoriteArticleIDs.remove(taskId)
        } else {
            favoriteArticleIDs.insert(taskId)
        }
        dataManager.saveFavorites(ids: favoriteArticleIDs)
    }
    
    func isFavorite(taskId: UUID) -> Bool {
        favoriteArticleIDs.contains(taskId)
    }
    
    func completeTask(taskId: UUID) {
        completedTaskIDs.insert(taskId)
        dataManager.saveCompletedTasks(ids: completedTaskIDs)
        updateStreak()
    }
    
    func isCompleted(taskId: UUID) -> Bool {
        completedTaskIDs.contains(taskId)
    }
    
    // MARK: - Computed Properties
    var featuredArticles: [ArticleFB] {
        Array(articles.prefix(3))
    }
    
    var progress: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(completedTaskIDs.count) / Double(tasks.count)
    }
}
