//
//  DBManager.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 23.04.2020.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import Foundation
import CoreData

class DBManager {
    static var share = DBManager()
    
    var questions: [Question]? {
        get {
            return getData()
        }
    }
    
    let manageContext = appDelegate?.persistentContainer.viewContext
    
    func saveQuestion(questionText: String, answerText: String, answeredBy: String, askedBy: String, id: Int32) {
        guard let manageContext = manageContext
            else {
                print("OH NO")
                return
            }
        let question = Question(context: manageContext)
        question.questionText = questionText
        question.answeredBy = answeredBy
        question.askedBy = askedBy
        question.id = id
        if answerText != "" {
            question.answerText = answerText
            question.hasAnswer = true
        }
        
        
        print(question)
        saveContext()
    }
    
    func delete(question: Question) {
        manageContext?.delete(question)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try manageContext?.save()
            
        } catch {
            print("Error save manageContext")
        }
    }
    
    func deleteAllData(entity: String) {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try manageContext!.execute(DelAllReqVar) }
        catch { print(error) }
    }
    
    private func getData() -> [Question]? {
           
           let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
           do {
               return try manageContext?.fetch(req) as? [Question]
           } catch {
               print("Error getData")
               return nil
           }
       }
}
