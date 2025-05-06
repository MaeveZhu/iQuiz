////
//  ViewController.swift
//  lab5
//
//  Created by Olivia Sapp on 4/28/25.
//

import UIKit

class tableCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBAction func alertPressed(_ sender: Any) {
      let alert = UIAlertController(title: "My Alert", message: "Settings go here.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK",
                                    style: .default,
                                    handler: { _ in
        NSLog("\"OK\" pressed.")
      }))
      
      self.present(alert, animated: true, completion: {
        NSLog("The completion handler fired")
      })
    }

    @IBOutlet weak var tableView: UITableView!
    
    var cellName = ["first", "second", "third"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //sets up the table size wise, how many rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellName.count
    }
    
    //input the data into the table
    //this table only has a label for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPrototype", for: indexPath) as! tableCell
        cell.cellLabel?.text = cellName[indexPath.row]
        return cell
    }
    
    //sets the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)  -> CGFloat{
        return 100
    }
    
    //segue
    //directes the view controler to go to the View2Controler
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSecondVC", sender: cellName[indexPath.row])
    }
    
    //before the segue is completed it runs this prepare function
    //this function sends the data from this view controler to the next view controler
    //we want to send the name of the cell that we clicked on to the next page


}
