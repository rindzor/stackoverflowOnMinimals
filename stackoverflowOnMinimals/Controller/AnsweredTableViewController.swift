//
//  AnsweredTableViewController.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/29/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

struct AnsweredData {
    let answer: String
    let asked_by_id: Int
    let asking_Name: String
    let expert_Name: String
    let expert_id: Int
    let id: Int
    let question: String
}

struct UnansweredData {
    let answer: String
    let asked_by_id: Int
    let asking_Name: String
    let expert_Name: String
    let expert_id: Int
    let id: Int
    let question: String
}

class AnsweredTableViewController: UITableViewController {

    var index = true
    var firstOpening = true
    var button: UIButton!
    var trashButton: UIButton!
    
    var questionManager = QuestionManager()
    var answeredData: [AnsweredData] = []
    var unansweredData: [UnansweredData] = []
    var segmentControl: UISegmentedControl {
        let sc = UISegmentedControl(items: ["Answered", "Unanswered"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(segmentChanged), for: .primaryActionTriggered)
        return sc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        loadAnsweredQuestions()
        loadUnansweredQuestions()
        setupFloatingButton()
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func setupFloatingButton() {
        button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width - 80, y: self.view.frame.height - 110), size: CGSize(width: 60, height: 60)))
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemGreen
        button.setImage(UIImage(systemName: "plus"), for: UIControl.State.normal)
        button.tintColor = .white
        
        self.view.addSubview(button)
        self.view.bringSubviewToFront(button)
        
         button.addTarget(self, action: #selector(floatingButtonPressed), for: UIControl.Event.touchUpInside)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        button.frame.origin.y = scrollView.contentOffset.y + self.view.frame.height - 110
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        print("Refresh")
        loadAnsweredQuestions()
        loadUnansweredQuestions()
        self.tableView.reloadData()        
        sender.endRefreshing()
        
    }
    
    
    
    func loadAnsweredQuestions(){
        var _ = questionManager.fetchAnsweredQuestion { (questionModel, error) in
            DispatchQueue.main.async {
                for question in questionModel! {
                    if !self.answeredData.contains{$0.id == question.id}{
                        self.answeredData.append(AnsweredData(answer: question.answer ?? "", asked_by_id: question.asked_by_id, asking_Name: question.asking_Name, expert_Name: question.expert_Name, expert_id: question.expert_id, id: question.id, question: question.question))
                        if self.unansweredData.contains(where: {$0.id == question.id}){
                            self.unansweredData = self.unansweredData.filter { $0.id !=  question.id}
                        }
                    }
                }
                if self.firstOpening {
                    self.tableView.reloadData()
                    self.firstOpening = false
                }
            }
        }
    }
    
    func loadUnansweredQuestions(){
        var _ = questionManager.fetchUnansweredQuestion { (questionModel, error) in
            DispatchQueue.main.async {
                for question in questionModel! {
                    if !self.unansweredData.contains{$0.id == question.id}{
                        self.unansweredData.append(UnansweredData(answer: question.answer ?? "", asked_by_id: question.asked_by_id, asking_Name: question.asking_Name, expert_Name: question.expert_Name, expert_id: question.expert_id, id: question.id, question: question.question))
                    }
                }
            }
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Questions"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = segmentControl

        let edit = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startEditing(sender:)) )
        
        navigationItem.rightBarButtonItem = edit
    }
    
    @objc func startEditing(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"

        if tableView.isEditing{
            self.button.backgroundColor = .systemGray
            self.button.setImage(UIImage(systemName: "trash"), for: UIControl.State.normal)
            self.button.tintColor = .white
            self.button.setTitle("", for: UIControl.State.normal)
        }  else {
            self.button.backgroundColor = .systemGreen
            self.button.setImage(nil, for: UIControl.State.normal)
            self.button.setImage(UIImage(systemName: "plus"), for: UIControl.State.normal)        }
    }
    
    func changeAppearenceToAdd(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        //sender.title = tableView.isEditing ? "Done" : "Edit"
        self.button.backgroundColor = .systemGreen
        self.button.setImage(nil, for: UIControl.State.normal)
        button.setImage(UIImage(systemName: "plus"), for: UIControl.State.normal)
        button.tintColor = .white
        navigationItem.rightBarButtonItem?.title = "Edit"
    }
    
    func setTrashButtonColor() {
        let selection = tableView.indexPathsForSelectedRows
        if selection?.count == 0 ||  selection?.count == nil{
            self.button.backgroundColor = .systemGray
        } else {
            self.button.backgroundColor = .systemRed
        }
    }
    
    @objc func segmentChanged() {
        index = !index
        self.tableView.reloadData()
    }
    
    @objc func floatingButtonPressed() {
        if tableView.isEditing {
            if let selection = tableView.indexPathsForSelectedRows {
                if selection.count > 0 {
                    
                    // нужен счетчик так как при удалении из массивов вопросов, там количество уменьшается, а indexPath.row смодет выйти за пределы массивов
                    var i = 0
                    
                    for indexPath in selection {
                        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
                        if self.index {
                            self.answeredData.remove(at: indexPath.row)
                            self.questionManager.deleteQuestion(id: cell.id)

                        }
                        else {
                            self.unansweredData.remove(at: indexPath.row - i)
                            self.questionManager.deleteQuestion(id: cell.id)

                        }
                        i += 1
                    }
                    
                    tableView.deleteRows(at: selection, with: .automatic)
                    //tableView.isEditing = false
                    changeAppearenceToAdd()
                }
            }
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AskViewController") as! AskViewController
            self.present(vc, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            setTrashButtonColor()
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            setTrashButtonColor()
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if index {
                let vc = storyboard.instantiateViewController(withIdentifier: "ATableViewController") as! ATableViewController
                vc.question = cell.questionLabel.text!
                vc.asker = cell.authorLabel.text!
                vc.answer = answeredData[indexPath.row].answer
                vc.answered = answeredData[indexPath.row].expert_Name
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = storyboard.instantiateViewController(withIdentifier: "UTableViewController") as! UTableViewController
                vc.question = cell.questionLabel.text!
                vc.asker = cell.authorLabel.text!
                vc.questionId = unansweredData[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        //self.tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if index {
            return answeredData.count
        }
        else {
             return unansweredData.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell

        if index {
            cell.questionLabel.text = answeredData[indexPath.row].question
            cell.authorLabel.text  = answeredData[indexPath.row].asking_Name
            cell.id = answeredData[indexPath.row].id
        }
        else {
             cell.questionLabel.text = unansweredData[indexPath.row].question
             cell.authorLabel.text  = unansweredData[indexPath.row].asking_Name
            cell.id = unansweredData[indexPath.row].id
        }
        cell.selectionStyle = .gray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            if self.index {
                self.answeredData.remove(at: indexPath.row)
                self.questionManager.deleteQuestion(id: cell.id)
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
            else {
                self.unansweredData.remove(at: indexPath.row)
                self.questionManager.deleteQuestion(id: cell.id)
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

