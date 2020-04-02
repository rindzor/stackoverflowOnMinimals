//
//  UTableViewController.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/30/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

class UTableViewController: UITableViewController {

    var question: String = ""
    var asker: String = ""
    var answer: String = ""
    var answered: String = ""
    var button: UIButton!
    var questionId: Int!
    var hasAnswer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width/2 - 175/2, y: self.view.frame.height - 110), size: CGSize(width: 175, height: 50)))
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        button.setTitle("Leave an answer", for: UIControl.State.normal)
        button.titleLabel?.textColor = .black
        
        
        button.addTarget(self, action: #selector(answerButtonPressed), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        button.frame.origin.y = scrollView.contentOffset.y + self.view.frame.height - 110
    }

    
    @objc func answerButtonPressed(){
        self.performSegue(withIdentifier: "leaveAnswer", sender: self)
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        print("Refresh")
        self.tableView.reloadData()
        sender.endRefreshing()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if hasAnswer == false{
            return 1
        }
        else {
            return 2
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "leaveAnswer" {
            if let destinationVC = segue.destination as? AnswerViewController {
                destinationVC.delegate = self
                destinationVC.questionId = self.questionId
            }
        }
    }
    
    func foo(){
        print(self.answer, self.answered, self.hasAnswer)
        button.removeFromSuperview()
        tableView.reloadData()
    }
    
    
}

extension UTableViewController: AnswerViewControllerDelegate {
    func fetchAnswer(text: String) {
        self.dismiss(animated: true)
        self.answer = text
        self.answered = "Tron"
        self.hasAnswer = true
        self.tableView.reloadData()
        self.foo()
    }
}
