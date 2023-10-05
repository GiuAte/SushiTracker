//
//  KeyboardHandling.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 11/09/23.
//

import SwiftUI
import UIKit

class KeyboardHandling: ObservableObject {
    @Published var isKeyboardVisible = false
    @Published var keyboardHeight: CGFloat = 0
    @Published var viewOffset: CGFloat = 0

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            viewOffset = keyboardHeight * -1
        }
        isKeyboardVisible = true
    }

    @objc func keyboardWillHide(notification: Notification) {
        keyboardHeight = 0
        viewOffset = 0
        isKeyboardVisible = false
    }

    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
