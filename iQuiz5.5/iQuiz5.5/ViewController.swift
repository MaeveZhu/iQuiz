// ViewController.swift
import UIKit

struct QuizTopic {
  let title:    String
  let subtitle: String
  let iconName: String   // ← must exactly match your asset names
}

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  let topics: [QuizTopic] = [
    .init(
      title:    "Mathematics",
      subtitle: "Test your skills with numbers and equations.",
      iconName: "math"         // ← asset named “math”
    ),
    .init(
      title:    "Marvel Super Heroes",
      subtitle: "How well do you know your favorite heroes?",
      iconName: "marvel"       // ← asset named “marvel”
    ),
    .init(
      title:    "Science",
      subtitle: "Explore physics, chemistry, and biology!",
      iconName: "science"      // ← asset named “science”
    )
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate   = self
  }

  @IBAction func alertPressed(_ sender: Any) {
    let alert = UIAlertController(
      title:        "My Alert",
      message:      "Settings go here.",
      preferredStyle: .alert
    )
    alert.addAction(.init(title: "OK", style: .default) { _ in
      NSLog("\"OK\" pressed.")
    })
    present(alert, animated: true) {
      NSLog("The completion handler fired")
    }
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
    let cell = tv.dequeueReusableCell(
      withIdentifier: "QuizTopicCell",
      for: indexPath
    ) as! QuizTopicCell

    let topic = topics[indexPath.row]
    cell.titleLabel.text       = topic.title
    cell.subtitleLabel.text    = topic.subtitle
    cell.iconImageView.image   = UIImage(named: topic.iconName)

    return cell
  }

  func tableView(_ tv: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
    tv.deselectRow(at: indexPath, animated: true)
    // … handle selection …
  }
}

