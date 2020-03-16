//
//  FormController.swift
//  SelfEvaluation
//
//  Created by Victor Ruiz on 3/16/20.
//  Copyright © 2020 Victor Ruiz. All rights reserved.
//

import Foundation

class FormController {
    
    init() {
        createQuestions()
    }
    
    var questions: [FormQuestion] = []
    var questionStrings = ["Using best practices for MVVM", "Reactive development", "API Development", "Testing", "Database knowledge", "Debugging", "Problem solving skills", "Swift", "Navigation Coordinators", "Working on a team", "Self motivation", "Communications skills", "Your own energy level", "Intelligence / Aptitude"]
    
    func createQuestions() {
        for questionString in questionStrings {
            let questionString = FormQuestion(description: questionString, answer: 0)
            questions.append(questionString)
        }
    }
    
    func update(question: FormQuestion, answer: Int) {
        guard let index = questions.index(of: question) else {
            print("no index")
            return }
        var item = question
        item.answer = answer
        questions[index] = item
    }
    
    
}

