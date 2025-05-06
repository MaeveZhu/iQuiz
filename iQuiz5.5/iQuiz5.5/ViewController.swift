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
    // later: navigate into the quiz itself
  }
}



