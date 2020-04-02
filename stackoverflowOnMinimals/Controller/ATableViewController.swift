//
//  ATableViewController.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/30/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

class ATableViewController: UITableViewController {
    
    var question: String = ""
    var asker: String = ""
    var answer: String = ""
    var answered: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ATableViewCell", owner: self, options: nil)?.first as! ATableViewCell
        
        if indexPath.row == 0 {
            cell.qaAuthor.text = asker
            cell.qaText.text = question
            cell.literal.text = "Q"
            cell.view.backgroundColor = UIColor.orange
        }
        if indexPath.row == 1{
            cell.qaAuthor.text = answered
            cell.qaText.text = answer
            cell.literal.text = "A"
            cell.view.backgroundColor = UIColor.green
        }

        return cell
    }

    

}
