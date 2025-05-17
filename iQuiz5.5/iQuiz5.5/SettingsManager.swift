import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    private let urlKey = "dataSourceURL"
    private let intervalKey = "refreshInterval"
    private init() {}
    
    var dataSourceURL: String? {
        get {
            UserDefaults.standard.string(forKey: urlKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: urlKey)
        }
    }
    
    var refreshInterval: Double {
        get {
            UserDefaults.standard.double(forKey: intervalKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: intervalKey)
        }
    }
} 