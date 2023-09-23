//
//  LogInViewViewModel.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import FirebaseAuth
import Foundation

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        
        // Try log in
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validate() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = String(format: NSLocalizedString("Please fill in all fields.", comment: ""))
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = String(format: NSLocalizedString("Please enter valid email.", comment: ""))
            return false
        }
        return true
    }
}
