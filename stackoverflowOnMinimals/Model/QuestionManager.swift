//
//  QuestionManager.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/29/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import Foundation

struct QuestionManager {
    let allAnsweredQuestionsUrl = "https://sinspython.herokuapp.com/allQuestion"
    let allUnansweredQuestionsUrl = "https://sinspython.herokuapp.com//allQuestionNoAnswer"
    let newQuestionUrl = "http://sinspython.herokuapp.com/newQuestion"
    let answerQuestionUrl = "https://sinspython.herokuapp.com/sendAnswer"
    let deleteQuestionUrl = "http://sinspython.herokuapp.com/question"
    
    func deleteQuestion(id: Int){
        let url = URL(string: deleteQuestionUrl)!
               var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
               request.httpMethod = "DELETE"
               let parameters: [String: Any] = [
                   "id": id
               ]
               request.httpBody = parameters.percentEncoded()
               
               let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                   guard let data = data, let urlResponse = urlResponse as? HTTPURLResponse, error == nil
                       else {
                           print("error", error ?? "Unknown error")
                           return
                       }
                
                   let responseString = String(data: data, encoding: .utf8)
                   print("responseString = \(responseString)")
               }
               task.resume()
    }
    
    func answerQuestion(text: String, id: Int){
        let url = URL(string: answerQuestionUrl)!
           var request = URLRequest(url: url)
    
           request.httpMethod = "POST"
           let parameters: [String: Any] = [
               "answer": text,
               "id": id
           ]
           request.httpBody = parameters.percentEncoded()
           
           let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
               guard let data = data, let urlResponse = urlResponse as? HTTPURLResponse, error == nil
                   else {
                       print("error", error ?? "Unknown error")
                       return
                   }
               
               let responseString = String(data: data, encoding: .utf8)
               print("responseString = \(responseString)")
           }
           task.resume()
    }
    
    func sendNewQuestion(text: String){
        let url = URL(string: newQuestionUrl)!
        var request = URLRequest(url: url)
 
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "question": text,
            "expert": 1
        ]
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            guard let data = data, let urlResponse = urlResponse as? HTTPURLResponse, error == nil
                else {
                    print("error", error ?? "Unknown error")
                    return
                }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    func fetchAnsweredQuestion(questionComplitionHandler: @escaping ([QuestionModel]?, Error?) -> Void) {
        let url = URL(string: allAnsweredQuestionsUrl)
        let task = URLSession.shared.dataTask(with: url!){ (data, urlResponse, error) in
            if error != nil{
                print("ERROR_1")
                questionComplitionHandler(nil, error)
            }
            if data != nil {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode([QuestionModel].self, from: data!)
                    questionComplitionHandler(decodedData, nil)
                } catch {
                    print("ERROR_2")
                    questionComplitionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func fetchUnansweredQuestion(questionComplitionHandler: @escaping ([QuestionModel]?, Error?) -> Void) {
        let url = URL(string: allUnansweredQuestionsUrl)
        let task = URLSession.shared.dataTask(with: url!){ (data, urlResponse, error) in
            if error != nil{
                print("ERROR_3")
                questionComplitionHandler(nil, error)
            }
            if data != nil {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode([QuestionModel].self, from: data!)
                    questionComplitionHandler(decodedData, nil)
                } catch {
                    print("ERROR_4")
                    questionComplitionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
    
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
