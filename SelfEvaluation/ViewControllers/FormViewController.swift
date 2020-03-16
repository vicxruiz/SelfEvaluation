//
//  FormViewController.swift
//  SelfEvaluation
//
//  Created by Victor Ruiz on 3/16/20.
//  Copyright © 2020 Victor Ruiz. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FormViewController: UIViewController {
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var projectRepoTextField: UITextField!
    @IBOutlet weak var projectURL: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var formViewModel = FormViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
    }
}
