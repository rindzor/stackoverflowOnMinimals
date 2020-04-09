//
//  QuestionManager.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/29/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import Foundation

struct QuestionManager {
    let masterUrl = "https://sinspython.herokuapp.com/"
    
    func deleteQuestion(id: Int){
        if let url = URL(string: masterUrl+"question"){
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
    }
    
    func answerQuestion(text: String, id: Int){
        if let url = URL(string: masterUrl+"sendAnswer"){
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
    }
    
    func sendNewQuestion(text: String){
        if let url = URL(string: masterUrl+"newQuestion"){
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
    }
    
    func fetchAnsweredQuestion(questionComplitionHandler: @escaping ([QuestionModel]?, Error?) -> Void) {
        if let url = URL(string: masterUrl+"allQuestion"){
            let task = URLSession.shared.dataTask(with: url){ (data, urlResponse, error) in
                if error != nil{
                    print("ERROR_1")
                    questionComplitionHandler(nil, error)
                }
                if let data = data{
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([QuestionModel].self, from: data)
                        questionComplitionHandler(decodedData, nil)
                    } catch {
                        print("ERROR_2")
                        questionComplitionHandler(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchUnansweredQuestion(questionComplitionHandler: @escaping ([QuestionModel]?, Error?) -> Void) {
        if let url = URL(string: masterUrl+"allQuestionNoAnswer"){
            let task = URLSession.shared.dataTask(with: url){ (data, urlResponse, error) in
                if error != nil{
                    print("ERROR_3")
                    questionComplitionHandler(nil, error)
                }
                if let data = data{
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([QuestionModel].self, from: data)
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
