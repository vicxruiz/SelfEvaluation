//
//  FormTableVIewCell.swift
//  SelfEvaluation
//
//  Created by Victor Ruiz on 3/16/20.
//  Copyright © 2020 Victor Ruiz. All rights reserved.
//

import Foundation
import UIKit

protocol FormCellDelegate {
    func didComplete(_ cell: FormTableViewCell, atIndexPath indexPath: IndexPath)
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - Properties
    
    var question: FormQuestion? {
        didSet {
            updateViews()
        }
    }
    var delegate: FormCellDelegate?
    var indexPath: IndexPath!
    
    //MARK: - Outlets
    @IBOutlet weak var formFieldLabel: UILabel!
    @IBOutlet weak var formTextField: UITextField!
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formTextField.delegate = self
    }
    
    //MARK: - Helpers
    
    func updateViews() {
        guard let question = question else {
            print("No Question")
            return
        }
        formFieldLabel.text = question.description + ":"
        formTextField.text = "\(question.answer)"
    }
}

extension FormTableViewCell {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.didComplete(self, atIndexPath: indexPath)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
