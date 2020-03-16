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
import MessageUI

class FormViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
        updateViews()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !MFMailComposeViewController.canSendMail() {
            Service.showAlert(on: self, style: .alert, title: "Mail Services Not Available", message: "Please use valid device.")
            return
        }
    }
    
    //MARK: - Helper
    
    private func initBinding() {
        _ = fullNameTextField.rx.text.map { $0 ?? "" }.bind(to: formViewModel.fullName)
        _ = emailTextField.rx.text.map { $0 ?? "" }.bind(to: formViewModel.email)
        _ = projectRepoTextField.rx.text.map { $0 ?? "" }.bind(to: formViewModel.projectRepo)
        _ = projectURLTextField.rx.text.map { $0 ?? "" }.bind(to: formViewModel.projectURL)
        _ = formViewModel.isValid.bind(to: submitButton.rx.isEnabled)
        _ = formViewModel.isValid.subscribe(onNext: { [unowned self] isValid in
            self.submitButton.alpha = isValid ? 1 : 0.5
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func displayFormInfo() -> String {
        var output = ""
        for question in formController.questions {
            output += "Full Name: \(formViewModel.fullName.value)\n"
            output += "Email: \(formViewModel.email.value)\n"
            output += "Project Repo: \(formViewModel.projectRepo.value)\n"
            output += "Project URL: \(formViewModel.projectURL.value)\n\n"
            output += "Results\n"
            output += "\(question.description): \(question.answer)\n"
        }
        return output
    }
    
    private func formIsValid() -> Bool {
        var answerResult = 0.0
        for question in formController.questions {
            answerResult += question.answer
        }
        if answerResult > Service.answerMax {
            Service.showAlert(on: self, style: .alert, title: "Error Submitting Form", message: "Maximum answer points allowed: \(Service.answerMax). Current answer points: \(answerResult)")
            return false
        }
        return true
    }
    
    private func updateViews() {
        fullNameTextField.attributedPlaceholder = NSAttributedString(string: "FULL NAME",
        attributes: [NSAttributedString.Key.foregroundColor: Service.darkGreenColor])
        projectRepoTextField.attributedPlaceholder = NSAttributedString(string: "PROJECT REPO",
        attributes: [NSAttributedString.Key.foregroundColor: Service.darkGreenColor])
        projectURLTextField.attributedPlaceholder = NSAttributedString(string: "PROJECT URL",
        attributes: [NSAttributedString.Key.foregroundColor: Service.darkGreenColor])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "EMAIL",
        attributes: [NSAttributedString.Key.foregroundColor: Service.darkGreenColor])
    }
    //MARK: - Actions
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self

        composeVC.setToRecipients(["ruizdvictor@gmail.com"])
        composeVC.setSubject("\(self.formViewModel.fullName.value) Self Evaluation")
        if formIsValid() {
            let output = displayFormInfo()
            composeVC.setMessageBody(output, isHTML: false)
        
        } else {
            return
        }

        self.present(composeVC, animated: true, completion: nil)
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
        cell.delegate = self
        cell.indexPath = indexPath
        cell.question = question
        
        return cell
    }
}


extension FormViewController: FormCellDelegate {
    func didComplete(_ cell: FormTableViewCell, atIndexPath indexPath: IndexPath) {
        let question = formController.questions[indexPath.row]
        guard let text = cell.formTextField.text, !text.isEmpty, let answer = Double(text) else {
            return
        }
        formController.update(question: question, answer: answer)
    }
}

