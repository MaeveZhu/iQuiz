import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var checkNowButton: UIButton!
    @IBOutlet weak var intervalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.text = SettingsManager.shared.dataSourceURL
        intervalTextField.text = SettingsManager.shared.refreshInterval > 0 ? String(Int(SettingsManager.shared.refreshInterval)) : ""
        intervalTextField.keyboardType = .numberPad
    }
    
    @IBAction func checkNowTapped(_ sender: UIButton) {
        guard let urlString = urlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        SettingsManager.shared.dataSourceURL = urlString
        NetworkManager.shared.checkDataSource(urlString: urlString, from: self)
    }
    
    @IBAction func intervalChanged(_ sender: UITextField) {
        if let text = sender.text, let value = Double(text), value > 0 {
            SettingsManager.shared.refreshInterval = value
        }
    }
} 
