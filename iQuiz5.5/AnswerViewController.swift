import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentQuestion: Question?
    var userAnswer: Int?
    var quizManager: QuizManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }
    
    private func setupUI() {
        guard let question = currentQuestion,
              let userAnswer = userAnswer else { return }
        
        questionLabel.text = question.text
        let isCorrect = userAnswer == question.correctAnswerIndex
        
        resultLabel.text = isCorrect ? "Correct!" : "Incorrect"
        resultLabel.textColor = isCorrect ? .systemGreen : .systemRed
        
        correctAnswerLabel.text = "Correct answer: \(question.options[question.correctAnswerIndex])"
        
        // Update quiz manager
        quizManager?.recordAnswer(isCorrect: isCorrect)
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        proceedToNext()
    }
    
    @objc private func handleSwipeRight() {
        proceedToNext()
    }
    
    private func proceedToNext() {
        if quizManager?.hasMoreQuestions() == true {
            performSegue(withIdentifier: "NextQuestion", sender: nil)
        } else {
            performSegue(withIdentifier: "ShowFinished", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let questionVC = segue.destination as? QuestionViewController {
            questionVC.currentQuestion = quizManager?.getNextQuestion()
            questionVC.quizManager = quizManager
        } else if let finishedVC = segue.destination as? FinishedViewController {
            finishedVC.quizManager = quizManager
        }
    }
} 
