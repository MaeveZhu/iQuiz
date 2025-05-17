import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    var topics: [QuizTopic] = []
    
    func fetchTopics(urlString: String, completion: @escaping ([QuizTopic]?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(nil)
                    return
                }
                guard let data = data else {
                    completion(nil)
                    return
                }
                do {
                    let topics = try JSONDecoder().decode([QuizTopic].self, from: data)
                    completion(topics)
                } catch {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func checkDataSource(urlString: String, from viewController: UIViewController) {
        guard let url = URL(string: urlString) else {
            self.showError(message: "Invalid URL", from: viewController)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showError(message: "Network not available", from: viewController)
                    print("Network error: \(error)")
                    return
                }
                guard let data = data else {
                    self.showError(message: "No data received", from: viewController)
                    print("No data received")
                    return
                }
                print("Downloaded data: \(data.count) bytes")
                // Show a success alert
                let alert = UIAlertController(title: "Success", message: "Downloaded \(data.count) bytes.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    private func showError(message: String, from viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
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
