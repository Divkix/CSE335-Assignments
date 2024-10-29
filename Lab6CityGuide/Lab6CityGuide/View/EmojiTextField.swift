//
//  EmojiTextField.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//


import SwiftUI
import UIKit

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.textAlignment = .center
        textField.delegate = context.coordinator
        textField.keyboardType = .default
        textField.returnKeyType = .done

        // Show emoji keyboard by default
        textField.keyboardType = .default
        textField.textContentType = .none

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField

        init(_ parent: EmojiTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            // Limit input to one character
            if let text = textField.text, text.count > 1 {
                textField.text = String(text.last!)
            }
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}