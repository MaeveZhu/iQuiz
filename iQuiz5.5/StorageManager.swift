import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let quizzesKey = "savedQuizzes"
    
    private init() {}
    
    // MARK: - Quiz Storage
    
    func saveQuizzes(_ quizzes: [QuizTopic]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(quizzes)
            UserDefaults.standard.set(data, forKey: quizzesKey)
        } catch {
            print("Error saving quizzes: \(error)")
        }
    }
    
    func loadQuizzes() -> [QuizTopic]? {
        guard let data = UserDefaults.standard.data(forKey: quizzesKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([QuizTopic].self, from: data)
        } catch {
            print("Error loading quizzes: \(error)")
            return nil
        }
    }
    
    // MARK: - Settings Storage
    
    func saveQuizURL(_ url: String) {
        UserDefaults.standard.set(url, forKey: "quizURL")
    }
    
    func getQuizURL() -> String? {
        return UserDefaults.standard.string(forKey: "quizURL")
    }
    
    // MARK: - Offline Status
    
    func isOffline() -> Bool {
        return !NetworkManager.shared.isConnected
    }
} 