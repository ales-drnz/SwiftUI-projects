//
//  DeletedViewViewModel.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 10/08/23.
//

import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore
import Foundation

class DeletedModel: ObservableObject {
    
    // Move to Bin
    func delete(id: String) {
        // Get current user ID
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Read the existing document from todos or completed
        db.collection("users")
            .document(uID)
            .collection("todos")
            .document(id)
            .getDocument { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                }
                
                if let document = document, document.exists {
                    // Move to "deleted"
                    db.collection("users")
                        .document(uID)
                        .collection("deleted")
                        .document(id)
                        .setData(document.data()!, merge: true) { error in
                            if let error = error {
                                print("Error moving document to 'deleted': \(error)")
                                return
                            }
                            
                            // Delete model from todos
                            db.collection("users")
                                .document(uID)
                                .collection("todos")
                                .document(id)
                                .delete() { error in
                                    if let error = error {
                                        print("Error deleting document from 'todos': \(error)")
                                        return
                                    }
                                    // Perform any necessary UI updates here
                                }
                        }
                } else {
                    db.collection("users")
                        .document(uID)
                        .collection("completed")
                        .document(id)
                        .getDocument { (document, error) in
                            if let error = error {
                                print("Error fetching document: \(error)")
                                return
                            }
                            
                            if let document = document, document.exists {
                                // Move to "deleted"
                                db.collection("users")
                                    .document(uID)
                                    .collection("deleted")
                                    .document(id)
                                    .setData(document.data()!, merge: true) { error in
                                        if let error = error {
                                            print("Error moving document to 'deleted': \(error)")
                                            return
                                        }
                                        
                                        // Delete model from completed
                                        db.collection("users")
                                            .document(uID)
                                            .collection("completed")
                                            .document(id)
                                            .delete() { error in
                                                if let error = error {
                                                    print("Error deleting document from 'completed': \(error)")
                                                    return
                                                }
                                                // Perform any necessary UI updates here
                                            }
                                    }
                            }
                        }
                }
            }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    // Move everything to Bin (Completed section)
    func deleteAll() {
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Move all documents from "completed" to "deleted"
        db.collection("users")
            .document(uID)
            .collection("completed")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        db.collection("users")
                            .document(uID)
                            .collection("deleted")
                            .document(document.documentID)
                            .setData(document.data(), merge: true)
                        
                        db.collection("users")
                            .document(uID)
                            .collection("completed")
                            .document(document.documentID)
                            .delete()
                    }
                }
            }
    }

    // Delete single item forever
    func deleteItem(id: String) {
        let db = Firestore.firestore()
        
        // Get current user ID
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users")
            .document(uID)
            .collection("deleted")
            .document(id)
            .delete() { error in
                if let error = error {
                    print("Error deleting document from 'deleted': \(error)")
                } else {
                    print("Document deleted from 'deleted' successfully.")
                }
            }
        
        db.collection("users")
            .document(uID)
            .collection("completed")
            .document(id)
            .delete() { error in
                if let error = error {
                    print("Error deleting document from 'completed': \(error)")
                } else {
                    print("Document deleted from 'completed' successfully.")
                }
            }

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    // Delete multiple items forever
    func deleteItemAll() {
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(uID).collection("deleted")
        
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            for document in querySnapshot!.documents {
                collectionRef.document(document.documentID).delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        print("Document deleted successfully.")
                    }
                }
            }
        }
    }

    // Recover item
    func recover(id: String) {
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Read the existing document from "deleted"
        db.collection("users")
            .document(uID)
            .collection("deleted")
            .document(id)
            .getDocument { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                }
                
                if let document = document, document.exists {
                    let data = document.data()!
                    let isDone = data["isDone"] as? Bool ?? false
                    
                    if isDone {
                        // Move to "completed"
                        db.collection("users")
                            .document(uID)
                            .collection("completed")
                            .document(id)
                            .setData(data, merge: true) { error in
                                if let error = error {
                                    print("Error moving document to 'completed': \(error)")
                                    return
                                }
                                // Perform any necessary UI updates here
                            }
                    } else {
                        // Move to "todos"
                        db.collection("users")
                            .document(uID)
                            .collection("todos")
                            .document(id)
                            .setData(data, merge: true) { error in
                                if let error = error {
                                    print("Error moving document to 'todos': \(error)")
                                    return
                                }
                                // Perform any necessary UI updates here
                            }
                    }
                    
                    // Delete model from deleted
                    db.collection("users")
                        .document(uID)
                        .collection("deleted")
                        .document(id)
                        .delete() { error in
                            if let error = error {
                                print("Error deleting document from 'deleted': \(error)")
                            } else {
                                print("Document recovered and deleted from 'deleted' successfully.")
                            }
                        }
                }
            }
    }


}
