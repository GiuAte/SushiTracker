//
//  CustomTextField.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 09/09/23.
//

import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {
    private let placeholder: String
    @Binding private var text: String
    private let returnKeyType: UIReturnKeyType
    private let tag: Int

    init(placeholder: String, text: Binding<String>, returnKeyType: UIReturnKeyType, tag: Int) {
        self.placeholder = placeholder
        self._text = text
        self.returnKeyType = returnKeyType
        self.tag = tag
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.text = text
        textField.returnKeyType = returnKeyType
        textField.delegate = context.coordinator
        textField.tag = tag
        textField.borderStyle = .roundedRect
        //textField.backgroundColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }
    
    

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ parent: CustomTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if parent.returnKeyType == .next {
                // Trova il prossimo campo di testo
                if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                    nextField.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
                return true
            } else if parent.returnKeyType == .done {
    
                textField.resignFirstResponder()
                return true
            }
            return false
        }
    }
}
