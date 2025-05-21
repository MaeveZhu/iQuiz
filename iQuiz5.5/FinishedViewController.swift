import UIKit

class FinishedViewController: UIViewController {
    
    @IBOutlet weak var performanceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var quizManager: QuizManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let quizManager = quizManager else { return }
        
        let score = quizManager.getScore()
        let total = quizManager.getTotalQuestions()
        let percentage = Double(score) / Double(total) * 100
        
        scoreLabel.text = "Score: \(score) of \(total) correct"
        
        switch percentage {
        case 100:
            performanceLabel.text = "Perfect! 🎉"
        case 80...:
            performanceLabel.text = "Excellent! 🌟"
        case 60...:
            performanceLabel.text = "Good job! 👍"
        case 40...:
            performanceLabel.text = "Almost there! 💪"
        default:
            performanceLabel.text = "Keep practicing! 📚"
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
} 
