import Foundation
import UIKit

class SettingsManager {
    static let shared = SettingsManager()
    private let urlKey = "dataSourceURL"
    private let intervalKey = "refreshInterval"
    private let defaultURL = "https://tednewardsandbox.site44.com/questions.json"
    
    private init() {
        // Set default URL if not already set
        if UserDefaults.standard.string(forKey: urlKey) == nil {
            UserDefaults.standard.set(defaultURL, forKey: urlKey)
        }
    }
    
    var dataSourceURL: String {
        get {
            UserDefaults.standard.string(forKey: urlKey) ?? defaultURL
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: urlKey)
            // Clear local storage when URL changes
            StorageManager.shared.saveQuizzes([])
        }
    }
    
    var refreshInterval: Double {
        get {
            let interval = UserDefaults.standard.double(forKey: intervalKey)
            return interval > 0 ? interval : 300 // Default to 5 minutes if not set
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
} 
