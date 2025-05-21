// ViewController.swift
import UIKit
import Foundation

class ViewController: UIViewController {
    @IBAction func settingsPressed(_ sender: Any) {
        SettingsManager.shared.openSettings()
    }
    @IBOutlet weak var tableView: UITableView!
    
    var topics: [QuizTopic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTopics()
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        loadTopics()
    }
    
    func loadTopics() {
        if let savedTopics = StorageManager.shared.loadQuizzes() {
            self.topics = savedTopics
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
        
        guard let urlString = SettingsManager.shared.dataSourceURL,
              SettingsManager.shared.validateURL(urlString) else {
            showSettingsAlert()
            return
        }
        
        NetworkManager.shared.fetchTopics(urlString: urlString) { [weak self] topics in
            guard let self = self else { return }
            if let topics = topics {
                self.topics = topics
                StorageManager.shared.saveQuizzes(topics)
                self.tableView.reloadData()
            }
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "No Data Source",
            message: "Please enter a valid data source URL in Settings",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            SettingsManager.shared.openSettings()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
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
            QuizManager.shared.loadQuiz(for: topic)
            questionVC.quizManager = QuizManager.shared
            questionVC.currentQuestion = QuizManager.shared.getNextQuestion()
        }
    }
}



