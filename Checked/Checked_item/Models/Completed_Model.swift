//
//  CompletedViewViewModel.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 21/07/23.
//

import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore
import Foundation

class CompletedModel: ObservableObject {
    
    func complete(id: String) {
        // Get current user ID
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Read the existing document from todos
        db.collection("users")
            .document(uID)
            .collection("todos")
            .document(id)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    // Move to "completed"
                    db.collection("users")
                        .document(uID)
                        .collection("completed")
                        .document(id)
                        .setData(document.data()!, merge: true)
                    
                    // Delete model from todos
                    db.collection("users")
                        .document(uID)
                        .collection("todos")
                        .document(id)
                        .delete()
                }
            }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
