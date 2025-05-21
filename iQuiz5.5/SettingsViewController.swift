import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var checkNowButton: UIButton!
    @IBOutlet weak var intervalTextField: UITextField!
    @IBOutlet weak var openSettingsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        urlTextField.text = SettingsManager.shared.dataSourceURL
        intervalTextField.text = SettingsManager.shared.refreshInterval > 0 ? String(Int(SettingsManager.shared.refreshInterval)) : ""
    }
    
    @IBAction func checkNowTapped(_ sender: UIButton) {
        guard let urlString = urlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !urlString.isEmpty else {
            showAlert(title: "Error", message: "Please enter a valid URL")
            return
        }
        
        if !SettingsManager.shared.validateURL(urlString) {
            showAlert(title: "Error", message: "Invalid URL format")
            return
        }
        
        SettingsManager.shared.dataSourceURL = urlString
        NetworkManager.shared.checkDataSource(urlString: urlString, from: self)
    }
    
    @IBAction func intervalChanged(_ sender: UITextField) {
        if let text = sender.text,
           let value = Double(text),
           value > 0 {
            SettingsManager.shared.refreshInterval = value
        }
    }
    
    @IBAction func openSettingsTapped(_ sender: UIButton) {
        SettingsManager.shared.openSettings()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 
