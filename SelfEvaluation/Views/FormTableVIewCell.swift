//
//  FormTableVIewCell.swift
//  SelfEvaluation
//
//  Created by Victor Ruiz on 3/16/20.
//  Copyright © 2020 Victor Ruiz. All rights reserved.
//

import Foundation
import UIKit

protocol StepCellDelegate {
    func didComplete(_ cell: FormTableViewCell, atIndexPath indexPath: IndexPath)
}

class FormTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var question: FormQuestion? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var formFieldLabel: UILabel!
    @IBOutlet weak var formTextField: UITextField!
    
    //MARK: - Helpers
    
    func updateViews() {
        guard let question = question else {
            print("No Question")
            return
        }
        formFieldLabel.text = question.description + ":"
    }
}
