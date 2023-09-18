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

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: Notification) {
        isKeyboardVisible = true
    }

    @objc func keyboardWillHide(notification: Notification) {
        isKeyboardVisible = false
    }

    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
