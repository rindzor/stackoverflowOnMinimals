//
//  QuestionModel.swift
//  stackoverflowOnMinimals
//
//  Created by  mac on 3/29/20.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import Foundation

struct QuestionModel: Codable {
    let answer: String?
    let asked_by_id: Int
    let asking_Name: String
    let expert_Name: String
    let expert_id: Int
    let id: Int
    let question: String
}

//struct QuestionData: Codable {
//
//}
