//
//  TextFieldValidatable.swift
//  Expense Tracker
//
//  Created by Krunal on 6/9/22.
//

import UIKit
import Combine

public protocol ValidationBaseProtocol: AnyObject { }

protocol FieldValidatableProtocol {
    var validationRules: [RuleProtocol] { get }
    var validationErrorText: String { get set }
}


class TextControl: UITextField, FieldValidatableProtocol {
    private var rules: [RuleProtocol] = []
    var validationRules: [RuleProtocol] {
        get { return rules }
        set { rules = newValue }
    }
    
    @Published var validationErrorText: String = " "

    func setRules(_ rules: [RuleProtocol]) {
        validationRules.removeAll()
        validationRules.append(contentsOf: rules)
    }

}

extension TextControl: UITextFieldDelegate {
    override func awakeFromNib() { super.awakeFromNib()
        delegate = self
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        validationErrorText = " "
        if let isNotValidEntry = self.rules.first(where: { $0.performValidation(string) == false }) {
            validationErrorText = isNotValidEntry.errorMessage()
            return false
        }
        return true
    }
}

final class NumericEntryAllowed: RuleProtocol {
    private var message: String
    static let allowedCharacters = CharacterSet.decimalDigits
    
    init(_ message: String = "Please enter proper amount") {
        self.message = message
    }
    func performValidation(_ value: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: value)
        return NumericEntryAllowed.allowedCharacters.isSuperset(of: characterSet)
    }
    func errorMessage() -> String {
        return message
    }
}
