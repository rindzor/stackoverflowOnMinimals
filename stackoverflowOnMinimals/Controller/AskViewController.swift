//
//  AskViewController.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/29/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

class AskViewController: UIViewController {

    let questionManager = QuestionManager()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textfield: UITextField!
    
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
    @IBAction func returnKeyPressed(_ sender: Any) {
        if textfield.text != "" {
            print("YEAAAH")
            self.dismiss(animated: true, completion: nil)
            questionManager.sendNewQuestion(text: textfield.text!)
        }
        
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if textfield.text != "" {
            self.dismiss(animated: true, completion: nil)
            questionManager.sendNewQuestion(text: textfield.text!)
        }
        
    }
}
