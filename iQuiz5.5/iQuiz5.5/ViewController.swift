// ViewController.swift
import UIKit
import Foundation

class ViewController: UIViewController {
    @IBAction func settingsPressed(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    
    var topics: [QuizTopic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate   = self
        loadTopics()
    }
    
    func loadTopics() {
        guard let urlString = SettingsManager.shared.dataSourceURL else { return }
        NetworkManager.shared.fetchTopics(urlString: urlString) { [weak self] topics in
            guard let self = self else { return }
            if let topics = topics {
                self.topics = topics
                self.tableView.reloadData()
            } else {
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTopicCell", for: indexPath) as! QuizTopicCell
        let topic = topics[indexPath.row]
        cell.titleLabel.text = topic.title
        cell.subtitleLabel.text = topic.desc
        cell.iconImageView.image = nil
        return cell
    }

    func tableView(_ tv: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        tv.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "StartQuiz", sender: topics[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let questionVC = segue.destination as? QuestionViewController,
           let topic = sender as? QuizTopic {
            let questions = topic.questions.map { q in
                Question(
                    text: q.text,
                    options: q.answers,
                    correctAnswerIndex: Int(q.answer) ?? 0
                )
            }
            questionVC.quizManager = QuizManager(questions: questions)
            questionVC.currentQuestion = questionVC.quizManager?.getNextQuestion()
        }
    }
}



