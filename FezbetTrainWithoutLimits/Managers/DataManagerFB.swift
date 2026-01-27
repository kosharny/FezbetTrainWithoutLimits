import Foundation

class DataManagerFB {
    static let shared = DataManagerFB()
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "FavoritesFB"
    private let completedTasksKey = "CompletedTasksFB"
    
    private init() {}
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    func saveFavorites(ids: Set<UUID>) {
        if let data = try? JSONEncoder().encode(ids) {
            userDefaults.set(data, forKey: favoritesKey)
        }
    }
    
    func loadFavorites() -> Set<UUID> {
        guard let data = userDefaults.data(forKey: favoritesKey),
              let ids = try? JSONDecoder().decode(Set<UUID>.self, from: data) else {
            return []
        }
        return ids
    }
    
    func loadCompletedTasks() -> Set<UUID> {
        let array = UserDefaults.standard.stringArray(forKey: "completedTaskIDs") ?? []
        return Set(array.compactMap { UUID(uuidString: $0) })
    }
    
    func saveCompletedTasks(ids: Set<UUID>) {
        let array = ids.map { $0.uuidString }
        UserDefaults.standard.set(array, forKey: "completedTaskIDs")
    }
    
    // MARK: - Article History
    func loadReadArticles() -> Set<UUID> {
        let array = UserDefaults.standard.stringArray(forKey: "readArticleIDs") ?? []
        return Set(array.compactMap { UUID(uuidString: $0) })
    }
    
    func saveReadArticles(ids: Set<UUID>) {
        let array = ids.map { $0.uuidString }
        UserDefaults.standard.set(array, forKey: "readArticleIDs")
    }
    
    // MARK: - Theme Persistence
    func loadThemeIndex() -> Int {
        return UserDefaults.standard.integer(forKey: "selectedThemeIndex")
    }
    
    func saveThemeIndex(_ index: Int) {
        UserDefaults.standard.set(index, forKey: "selectedThemeIndex")
    }
    
    // MARK: - Streak Logic
    func loadStreak() -> Int {
        return UserDefaults.standard.integer(forKey: "userStreakCount")
    }
    
    func saveStreak(_ streak: Int) {
        UserDefaults.standard.set(streak, forKey: "userStreakCount")
    }
    
    func loadLastActiveDate() -> Date? {
        return UserDefaults.standard.object(forKey: "lastActiveDate") as? Date
    }
    
    func saveLastActiveDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: "lastActiveDate")
    }
}
