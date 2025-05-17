// ViewController.swift
import UIKit
import Foundation

struct QuizTopic {
  let title:    String
  let subtitle: String
  let iconName: String
}

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  // 3 topics in-memory
  let topics: [QuizTopic] = [
    .init(title:    "Mathematics",
          subtitle: "Test your skills with numbers and equations.",
          iconName: "math"),
    .init(title:    "Marvel Super Heroes",
          subtitle: "How well do you know your favorite heroes?",
          iconName: "hero"),
    .init(title:    "Science",
          subtitle: "Explore physics, chemistry, and biology!",
          iconName: "science")
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate   = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = view.bounds.height / CGFloat(topics.count)
  }

  @IBAction func alertPressed(_ sender: Any) {
    let alert = UIAlertController(
      title: "My Alert",
      message: "Settings go here.",
      preferredStyle: .alert
    )
    alert.addAction(.init(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
    return topics.count
  }

  func tableView(
    _ tv: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView
        .dequeueReusableCell(withIdentifier: "QuizTopicCell", for: indexPath)
        as! QuizTopicCell

    let topic = topics[indexPath.row]
    cell.titleLabel.text     = topic.title
    cell.subtitleLabel.text  = topic.subtitle
    cell.iconImageView.image = UIImage(named: topic.iconName)

    return cell
  }

  func tableView(
    _ tv: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 200
  }

  func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
    tv.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "StartQuiz", sender: topics[indexPath.row])
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let questionVC = segue.destination as? QuestionViewController,
       let topic = sender as? QuizTopic {
        // Create questions based on the selected topic
        let questions = createQuestions(for: topic)
        questionVC.quizManager = QuizManager(questions: questions)
        questionVC.currentQuestion = questionVC.quizManager?.getNextQuestion()
    }
  }
  
  private func createQuestions(for topic: QuizTopic) -> [Question] {
    switch topic.title {
    case "Mathematics":
        return [
            Question(text: "Who is credited with inventing calculus?", options: ["Isaac Newton", "Gottfried Leibniz", "Both independently", "Leonhard Euler"], correctAnswerIndex: 2),
            Question(text: "Which ancient civilization first used a place-value number system?", options: ["Egyptians", "Greeks", "Babylonians", "Romans"], correctAnswerIndex: 2),
            Question(text: "Who proved Fermat's Last Theorem in 1994?", options: ["Andrew Wiles", "Terence Tao", "Grigori Perelman", "John Nash"], correctAnswerIndex: 0),
            Question(text: "Which country developed the earliest known counting device, the abacus?", options: ["China", "Egypt", "Mesopotamia", "India"], correctAnswerIndex: 2),
            Question(text: "Who is known as the 'father of geometry'?", options: ["Pythagoras", "Euclid", "Archimedes", "Thales"], correctAnswerIndex: 1)
        ]
    case "Marvel Super Heroes":
        return [
            Question(text: "Who created the Marvel Universe with Stan Lee?", options: ["Jack Kirby", "Steve Ditko", "John Romita Sr.", "Jim Steranko"], correctAnswerIndex: 0),
            Question(text: "Which country was Black Panther's homeland of Wakanda first depicted in?", options: ["Fantastic Four #52", "Avengers #8", "Tales to Astonish #73", "Captain America #100"], correctAnswerIndex: 0),
            Question(text: "Who was the first Marvel character created by Stan Lee and Jack Kirby?", options: ["Spider-Man", "The Fantastic Four", "The Hulk", "The X-Men"], correctAnswerIndex: 1),
            Question(text: "Which Marvel villain was introduced first historically?", options: ["Magneto", "Doctor Doom", "Loki", "Green Goblin"], correctAnswerIndex: 2),
            Question(text: "In which year was the first Marvel comic published?", options: ["1939", "1941", "1956", "1961"], correctAnswerIndex: 0)
        ]
    case "Science":
        return [
            Question(text: "Who discovered penicillin?", options: ["Marie Curie", "Louis Pasteur", "Alexander Fleming", "Robert Koch"], correctAnswerIndex: 2),
            Question(text: "Which country built the first particle accelerator?", options: ["United States", "Germany", "United Kingdom", "Soviet Union"], correctAnswerIndex: 0),
            Question(text: "Who first proposed the heliocentric model of the solar system?", options: ["Galileo Galilei", "Nicolaus Copernicus", "Johannes Kepler", "Tycho Brahe"], correctAnswerIndex: 1),
            Question(text: "Which civilization created the earliest known astronomical observatory?", options: ["Maya", "Babylon", "Egypt", "China"], correctAnswerIndex: 1),
            Question(text: "Who is credited with the discovery of radioactivity?", options: ["Marie Curie", "Henri Becquerel", "Wilhelm Röntgen", "Ernest Rutherford"], correctAnswerIndex: 1)
        ]
    default:
        return []
    }
  }
}



