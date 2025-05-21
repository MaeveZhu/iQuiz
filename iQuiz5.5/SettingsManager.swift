import Foundation
import UIKit

class SettingsManager {
    static let shared = SettingsManager()
    private let urlKey = "dataSourceURL"
    private let intervalKey = "refreshInterval"
    private let defaultURL = "https://tednewardsandbox.site44.com/questions.json"
    
    private init() {
        // Register default values
        let defaults: [String: Any] = [
            urlKey: defaultURL,
            intervalKey: 300.0
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
    
    var dataSourceURL: String? {
        get {
            return UserDefaults.standard.string(forKey: urlKey)
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: urlKey)
                // Clear local storage when URL changes
                StorageManager.shared.saveQuizzes([])
            }
        }
    }
    
    var refreshInterval: Double {
        get {
            return UserDefaults.standard.double(forKey: intervalKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: intervalKey)
        }
    }
    
    func validateURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    var isConfigured: Bool {
        guard let url = dataSourceURL, !url.isEmpty else { return false }
        return validateURL(url)
    }
} 
