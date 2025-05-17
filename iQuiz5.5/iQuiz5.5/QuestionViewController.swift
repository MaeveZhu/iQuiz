import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var swipeHintLabel: UILabel!
    
    var currentQuestion: Question?
    var selectedAnswer: Int?
    var quizManager: QuizManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        setupTableView()
    }
    
    private func setupUI() {
        guard let question = currentQuestion else { return }
        questionLabel.text = question.text
        submitButton.isEnabled = false
    }
    
    private func setupTableView() {
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        optionsTableView.separatorStyle = .none
        optionsTableView.isScrollEnabled = false
        optionsTableView.backgroundColor = .clear
        optionsTableView.allowsSelection = true
        optionsTableView.allowsMultipleSelection = false
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        submitAnswer()
    }
    
    @objc private func handleSwipeRight() {
        submitAnswer()
    }
    
    @objc private func handleSwipeLeft() {
        let alert = UIAlertController(
            title: "Skip Question?",
            message: "Do you want to skip this question and move to the next one?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Skip", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            if self.quizManager?.hasMoreQuestions() == true {
                self.currentQuestion = self.quizManager?.getNextQuestion()
                self.selectedAnswer = nil
                self.setupUI()
                self.optionsTableView.reloadData()
            } else {
                self.performSegue(withIdentifier: "ShowAnswer", sender: nil)
            }
        })
        present(alert, animated: true)
    }
    
    private func submitAnswer() {
        guard let selectedAnswer = selectedAnswer else { return }
        performSegue(withIdentifier: "ShowAnswer", sender: selectedAnswer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let answerVC = segue.destination as? AnswerViewController,
           let selectedAnswer = sender as? Int {
            answerVC.currentQuestion = currentQuestion
            answerVC.userAnswer = selectedAnswer
            answerVC.quizManager = quizManager
        }
    }
}

extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = currentQuestion?.options[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .center

        if indexPath.row == selectedAnswer {
            cell.backgroundColor = .systemPurple
            cell.textLabel?.textColor = .white
        } else {
            cell.backgroundColor = .systemGray6
            cell.textLabel?.textColor = .label
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswer = indexPath.row
        submitButton.isEnabled = true
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
} 
