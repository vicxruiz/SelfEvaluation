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
    
    //MARK: - Outlets

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var projectRepoTextField: UITextField!
    @IBOutlet weak var projectURLTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    private var formViewModel = FormViewModel()
    private var disposeBag = DisposeBag()
    var formController = FormController()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBinding()
        setupTableView()
        formViewModel.formController = formController
    }
    
    //MARK: - Helper
    
    func initBinding() {
        _ = fullNameTextField.rx.text.map { $0 ?? "" }.bind(to: formViewModel.fullName)
        _ = emailTextField.rx.text.map { $0 ?? "" }.bind(to: formViewModel.email)
        _ = projectRepoTextField.rx.text.map { $0 ?? "" }.bind(to: formViewModel.projectRepo)
        _ = projectURLTextField.rx.text.map { $0 ?? "" }.bind(to: formViewModel.projectURL)
        _ = formViewModel.isValid.bind(to: submitButton.rx.isEnabled)
        _ = formViewModel.isValid.subscribe(onNext: { [unowned self] isValid in
            self.submitButton.alpha = isValid ? 1 : 0.5
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Actions
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
    }
}

//MARK: - TableView

extension FormViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formController.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath) as? FormTableViewCell else {
            return UITableViewCell()
        }
        
        let question = formController.questions[indexPath.row]
        cell.question = question
        
        return cell
    }
}

