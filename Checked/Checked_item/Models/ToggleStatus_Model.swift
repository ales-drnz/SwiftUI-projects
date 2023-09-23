//
//  PinnedItemViewViewModel.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/08/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

// ViewModel for single to do list item view (each row in items list)
// Primary tab

class ToggleStatusModel: ObservableObject {
    init() {}
    
    func toggleIsDone(item: Checked) {
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uID)
            .collection("todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
    
    func toggleIsPinned(item: Checked) {
        var itemCopy = item
        itemCopy.setPinned(!item.isPinned)
        
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uID)
            .collection("todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
}
