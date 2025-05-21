import Foundation
import UIKit
import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private(set) var isConnected = true
    
    private init() {
        setupNetworkMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    var topics: [QuizTopic] = []
    
    func fetchTopics(urlString: String, completion: @escaping ([QuizTopic]?) -> Void) {
        // First try to load from local storage if offline
        if !isConnected {
            if let localTopics = StorageManager.shared.loadQuizzes() {
                self.topics = localTopics
                completion(localTopics)
                return
            }
            completion(nil)
            return
        }
        
        // If online, fetch from network
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network error: \(error)")
                    // Try to load from local storage as fallback
                    if let localTopics = StorageManager.shared.loadQuizzes() {
                        self?.topics = localTopics
                        completion(localTopics)
                    } else {
                        completion(nil)
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil)
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("HTTP error: \(httpResponse.statusCode)")
                    // Try to load from local storage as fallback
                    if let localTopics = StorageManager.shared.loadQuizzes() {
                        self?.topics = localTopics
                        completion(localTopics)
                    } else {
                        completion(nil)
                    }
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                do {
                    let topics = try JSONDecoder().decode([QuizTopic].self, from: data)
                    self?.topics = topics
                    // Save to local storage
                    StorageManager.shared.saveQuizzes(topics)
                    completion(topics)
                } catch {
                    print("Decoding error: \(error)")
                    // Try to load from local storage as fallback
                    if let localTopics = StorageManager.shared.loadQuizzes() {
                        self?.topics = localTopics
                        completion(localTopics)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    func checkDataSource(urlString: String, from viewController: UIViewController) {
        guard let url = URL(string: urlString) else {
            self.showError(message: "Invalid URL format", from: viewController)
            return
        }
        
        if !isConnected {
            self.showError(message: "No internet connection available", from: viewController)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showError(message: "Network error: \(error.localizedDescription)", from: viewController)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showError(message: "Invalid server response", from: viewController)
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    self.showError(message: "Server error: \(httpResponse.statusCode)", from: viewController)
                    return
                }
                
                guard let data = data else {
                    self.showError(message: "No data received", from: viewController)
                    return
                }
                
                // Show a success alert
                let alert = UIAlertController(
                    title: "Success",
                    message: "Successfully connected to data source. Downloaded \(data.count) bytes.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                viewController.present(alert, animated: true)
            }
        }
        task.resume()
    }
    
    private func showError(message: String, from viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}

struct QuizTopic: Codable {
    let title: String
    let desc: String
    let questions: [QuizQuestion]
}

struct QuizQuestion: Codable {
    let text: String
    let answer: String
    let answers: [String]
}
