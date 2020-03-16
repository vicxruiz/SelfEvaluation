//
//  FormViewModel.swift
//  SelfEvaluation
//
//  Created by Victor Ruiz on 3/16/20.
//  Copyright © 2020 Victor Ruiz. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

struct FormViewModel {
    
    var formController: FormController?
    var fullName = BehaviorRelay<String>(value: "")
    var email = BehaviorRelay<String>(value: "")
    var projectRepo = BehaviorRelay<String>(value: "")
    var projectURL = BehaviorRelay<String>(value: "")

    var isValid: Observable<Bool> {
        return Observable.combineLatest(fullName.asObservable(), email.asObservable(), projectRepo.asObservable(), projectURL.asObservable()) {
            !$0.isEmpty && !$1.isEmpty && $1.isValidEmail() && !$2.isEmpty && !$3.isEmpty && $3.isValidURL()
        }
    }
}
