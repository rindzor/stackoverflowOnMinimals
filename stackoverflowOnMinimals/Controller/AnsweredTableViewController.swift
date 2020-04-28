//
//  AnsweredTableViewController.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/29/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

class AnsweredTableViewController: UITableViewController {

    var index = true
    var firstOpening = true
    var button: UIButton!
    var trashButton: UIButton!
    var showingSavedPage = false
    
    var questionManager = QuestionManager()
    var answeredData: [QuestionData] = []
    var unansweredData: [QuestionData] = []
    var savedData: [Question]?
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentChanged(_ sender: Any) {
//        if segmentControl.selectedSegmentIndex == 0 || segmentControl.selectedSegmentIndex == 1 {
//                 index = !index
//             } else if segmentControl.selectedSegmentIndex == 2 {
//                 showingSavedPage = true
//                 savedData = DBManager.share.questions
//                 print("questions SAVED: ", savedData)
//             }

             self.tableView.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.savedData = DBManager.share.questions
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
        // Расскомментировать, чтоб при обновлении страницы удалять все вопросы с БД
        //DBManager.share.deleteAllData(entity: "Question")

        self.tableView.reloadData()        
        sender.endRefreshing()
        
    }
    
    
    
    func loadAnsweredQuestions(){
        var _ = questionManager.fetchAnsweredQuestion { (questionModel, error) in
            DispatchQueue.main.async {
                if let questionModel = questionModel {
                    for question in questionModel {
                        if !self.answeredData.contains{$0.id == question.id} && self.savedData!.contains{$0.id == question.id}{
                            self.answeredData.append(QuestionData(answer: question.answer ?? "", asked_by_id: question.asked_by_id, asking_Name: question.asking_Name, expert_Name: question.expert_Name, expert_id: question.expert_id, id: question.id, question: question.question, isSaved: true, hasAnswer: true))
                            if self.unansweredData.contains(where: {$0.id == question.id}){
                                self.unansweredData = self.unansweredData.filter { $0.id !=  question.id}
                            }
                        }
                        if !self.answeredData.contains{$0.id == question.id}{
                            self.answeredData.append(QuestionData(answer: question.answer ?? "", asked_by_id: question.asked_by_id, asking_Name: question.asking_Name, expert_Name: question.expert_Name, expert_id: question.expert_id, id: question.id, question: question.question, isSaved: false, hasAnswer: true))
                            if self.unansweredData.contains(where: {$0.id == question.id}){
                                self.unansweredData = self.unansweredData.filter { $0.id !=  question.id}
                            }
                        }
                    }
                }
                if self.firstOpening {
                    self.tableView.reloadData()
                    self.firstOpening = false
                }
            }
        }
        for var question in self.answeredData {
            if self.savedData!.contains{$0.id == question.id}{
                question.isSaved = true
                print(question.isSaved)
            } else {
                question.isSaved = false
                print(question.question, question.isSaved)
            
            }
        }
    }
    
    func loadUnansweredQuestions(){
        var _ = questionManager.fetchUnansweredQuestion { (questionModel, error) in
            DispatchQueue.main.async {
                if let questionModel = questionModel {
                    for question in questionModel {
                        if !self.unansweredData.contains{$0.id == question.id} && self.savedData!.contains{$0.id == question.id}{
                            self.unansweredData.append(QuestionData(answer: question.answer ?? "", asked_by_id: question.asked_by_id, asking_Name: question.asking_Name, expert_Name: question.expert_Name, expert_id: question.expert_id, id: question.id, question: question.question, isSaved: true, hasAnswer: false))
                        }
                        if !self.unansweredData.contains{$0.id == question.id}{
                            self.unansweredData.append(QuestionData(answer: question.answer ?? "", asked_by_id: question.asked_by_id, asking_Name: question.asking_Name, expert_Name: question.expert_Name, expert_id: question.expert_id, id: question.id, question: question.question, isSaved: false, hasAnswer: false))
                        }
                    }
                }
            }
        }
        for var question in unansweredData {
            if self.savedData!.contains{$0.id == question.id}{
                question.isSaved = true
                print(question.isSaved)
            } else {
                question.isSaved = false
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
     
    }
    
    @objc func floatingButtonPressed() {
        if tableView.isEditing {
            if let selection = tableView.indexPathsForSelectedRows {
                let descendingSelection = (selection.sorted(by: { (i, j) -> Bool in
                    return i[1] > j[1]
                }))
                if selection.count > 0 {
                    
                    for indexPath in descendingSelection {
                        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
                        if self.segmentControl.selectedSegmentIndex == 0 {
                            self.answeredData.remove(at: indexPath.row)
                            self.questionManager.deleteQuestion(id: cell.id)
                        }
                        else if self.segmentControl.selectedSegmentIndex == 1{
                            self.unansweredData.remove(at: indexPath.row)
                            self.questionManager.deleteQuestion(id: cell.id)
                        } else {
                            var i = 0
                            for question in self.answeredData{
                                if Int32(question.id) == (self.savedData![indexPath.row].id){
                                    self.answeredData[i].isSaved = false
                                }
                                i += 1
                              }
                            i = 0
                            for question in self.unansweredData{
                              if Int32(question.id) == (self.savedData![indexPath.row].id){
                                    self.unansweredData[i].isSaved = false
                                }
                              i += 1
                            }
                            DBManager.share.delete(question: self.savedData![indexPath.row])
                        }
                    }
                    self.savedData = DBManager.share.questions
                    
                    tableView.deleteRows(at: selection, with: .automatic)
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
            //print(cell.isSaved)
                let vc = storyboard.instantiateViewController(withIdentifier: "UTableViewController") as! UTableViewController
                if let questionText = cell.questionLabel.text, let authorText = cell.authorLabel.text{
                    vc.question = questionText
                    vc.asker = authorText
                }
                if self.segmentControl.selectedSegmentIndex == 0 {
                    vc.hasAnswer = true
                    vc.answer = answeredData[indexPath.row].answer
                    vc.answered = answeredData[indexPath.row].expert_Name
                } else if self.segmentControl.selectedSegmentIndex == 1 {
                    vc.questionId = unansweredData[indexPath.row].id
                } else {
                    vc.hasAnswer = savedData![indexPath.row].hasAnswer
                    if vc.hasAnswer {
                        vc.answer = savedData![indexPath.row].answerText!
                        vc.answered = savedData![indexPath.row].answeredBy!
                    }
                }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
            


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.segmentControl.selectedSegmentIndex == 0 {
            return answeredData.count
        } else if self.segmentControl.selectedSegmentIndex == 1 {
            return unansweredData.count
        } else {
            return savedData?.count ?? 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        if segmentControl.selectedSegmentIndex == 0 {
            cell.questionLabel.text = answeredData[indexPath.row].question
            cell.authorLabel.text = answeredData[indexPath.row].asking_Name
            cell.id = answeredData[indexPath.row].id
            cell.isSaved = answeredData[indexPath.row].isSaved
            cell.hasAnswer = true
        } else if segmentControl.selectedSegmentIndex == 1 {
            cell.questionLabel.text =  unansweredData[indexPath.row].question
            cell.authorLabel.text =  unansweredData[indexPath.row].asking_Name
            cell.id = unansweredData[indexPath.row].id
            cell.isSaved = unansweredData[indexPath.row].isSaved
            cell.hasAnswer = false
        } else {
            cell.questionLabel.text = savedData?[indexPath.row].questionText
            cell.authorLabel.text = savedData?[indexPath.row].askedBy
            cell.hasAnswer = savedData?[indexPath.row].hasAnswer
        }
        
        cell.selectionStyle = .gray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            if self.segmentControl.selectedSegmentIndex == 0 {
                self.answeredData.remove(at: indexPath.row)
            } else if self.segmentControl.selectedSegmentIndex == 1  {
                self.unansweredData.remove(at: indexPath.row)
            }
            self.questionManager.deleteQuestion(id: cell.id)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        
        let save = UIContextualAction(style: .normal, title: "Save") { (action, view, complition) in
            if self.segmentControl.selectedSegmentIndex == 0 {
                if !cell.isSaved {
                    DBManager.share.saveQuestion(questionText: self.answeredData[indexPath.row].question, answerText: self.answeredData[indexPath.row].answer, answeredBy: self.answeredData[indexPath.row].expert_Name, askedBy: self.answeredData[indexPath.row].asking_Name, id: Int32(self.answeredData[indexPath.row].id))
                    self.savedData = DBManager.share.questions
                    cell.isSaved = !cell.isSaved
                    self.answeredData[indexPath.row].isSaved = !self.answeredData[indexPath.row].isSaved
                } else {
                    for question in self.savedData!{
                        if question.id == Int32(self.answeredData[indexPath.row].id){
                            DBManager.share.delete(question: question)
                            self.savedData = DBManager.share.questions
                            cell.isSaved = !cell.isSaved
                            self.answeredData[indexPath.row].isSaved = !self.answeredData[indexPath.row].isSaved
                        }
                    }
                }
                
            } else if self.segmentControl.selectedSegmentIndex == 1  {
                if !cell.isSaved {
                    DBManager.share.saveQuestion(questionText: self.unansweredData[indexPath.row].question, answerText: self.unansweredData[indexPath.row].answer, answeredBy: self.unansweredData[indexPath.row].expert_Name, askedBy: self.unansweredData[indexPath.row].asking_Name, id: Int32(self.unansweredData[indexPath.row].id))
                    self.savedData = DBManager.share.questions
                    cell.isSaved = !cell.isSaved
                    self.unansweredData[indexPath.row].isSaved = !self.unansweredData[indexPath.row].isSaved
                } else {
                    for question in self.savedData!{
                        if question.id == Int32(self.unansweredData[indexPath.row].id){
                            DBManager.share.delete(question: question)
                            self.savedData = DBManager.share.questions
                            cell.isSaved = !cell.isSaved
                            self.unansweredData[indexPath.row].isSaved = !self.unansweredData[indexPath.row].isSaved
                        }
                    }
                }
            }
            complition(true)
        }
        delete.image = UIImage(systemName: "trash")
        save.image = UIImage(systemName: "wand.and.rays.inverse")
        
        if cell.isSaved == true {
            save.backgroundColor = .systemPurple
        }
        
        let unsave = UIContextualAction(style: .destructive, title: "UnSave") { (action, view, nil) in
            var i = 0
            for question in self.answeredData{
                if Int32(question.id) == (self.savedData![indexPath.row].id){
                        self.answeredData[i].isSaved = false
                    }
                i += 1
              }
            i = 0
            for question in self.unansweredData{
              if Int32(question.id) == (self.savedData![indexPath.row].id){
                      self.unansweredData[i].isSaved = false
                  }
              i += 1
            }

                DBManager.share.delete(question: self.savedData![indexPath.row])
                self.savedData = DBManager.share.questions
                self.tableView.reloadData()
        }
        unsave.image = UIImage(systemName: "trash")

        
        if self.segmentControl.selectedSegmentIndex == 0 || self.segmentControl.selectedSegmentIndex == 1 {
            return UISwipeActionsConfiguration(actions: [delete, save])
        } else {
            return UISwipeActionsConfiguration(actions: [unsave])
        }
        
    }
}

