import Foundation

struct ArticleFB: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let imageName: String
    let content: String
    let isPremium: Bool
    var isFavorite: Bool = false
    var isRead: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, imageName, content, isPremium
    }
}

struct TaskStepFB: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let durationSeconds: Int
}

struct TaskFB: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let difficulty: String
    let imageName: String
    let description: String
    let steps: [TaskStepFB]
    let isPremium: Bool
    var isCompleted: Bool = false
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, title, difficulty, imageName, description, steps, isPremium
    }
}

struct UserProfileFB: Codable {
    var completedTasksCount: Int = 0
    var readArticlesCount: Int = 0
    var totalTrainingTime: Int = 0
    var joinedDate: Date = Date()
}
