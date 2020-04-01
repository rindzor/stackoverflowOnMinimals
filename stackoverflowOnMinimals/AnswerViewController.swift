//
//  AnswerViewController.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/30/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

protocol AnswerViewControllerDelegate {
    func fetchAnswer(text: String)
}

class AnswerViewController: UIViewController {
    
    var questionId: Int!
    let questionManager = QuestionManager()
    var delegate: AnswerViewControllerDelegate?
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if textfield.text != "" {
            questionManager.answerQuestion(text: textfield.text!, id: questionId!)
            //self.dismiss(animated: true, completion: nil)
            delegate?.fetchAnswer(text: textfield.text!)
            
        }
    }
    @IBAction func returnKeyPressed(_ sender: Any) {
        if textfield.text != "" {
            questionManager.answerQuestion(text: textfield.text!, id: questionId!)
            //self.dismiss(animated: true, completion: nil)
            delegate?.fetchAnswer(text: textfield.text!)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.backgroundColor = .systemGreen
        sendButton.layer.cornerRadius = 25
        sendButton.setTitle("Send", for: UIControl.State.normal)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard)))
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
}
