//
//  ToDoListViewViewModel.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//


import FirebaseFirestore
import Foundation
import UserNotifications

// ViewModel for list of items view

// Primary tab
class CheckedModel: ObservableObject {
    @Published var items: [Checked] = []
    @Published var isLoading: Bool = true
    private let userID: String
    
    // Caricamento dei dati dal Database
    init(userID: String) {
        self.userID = userID
        let db = Firestore.firestore()
        db.collection("users/\(userID)/todos").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self?.items = documents.compactMap { queryDocumentSnapshot -> Checked? in
                return try? queryDocumentSnapshot.data(as: Checked.self)
            }
            self?.isLoading = false
        }
    }
}
