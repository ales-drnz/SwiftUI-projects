//
//  NewItemViewViewModel.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import UserNotifications
import SwiftUI

class NewItemModel: ObservableObject {
    @Published var title = ""
    @Published var notes = ""
    @Published var dueDate = Date()
    @Published var isPinned = false
    
    func save() {
        
        // Get current user ID
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create model
        let newID = UUID().uuidString
        let newItem = Checked(
            id: newID,
            title: title,
            notes: notes,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            isPinned: isPinned
        )
        
        // Save model
        let db = Firestore.firestore()
        db.collection("users")
            .document(uID)
            .collection("todos")
            .document(newID)
            .setData(newItem.asDictionary())
        
        // Genera notifica di sistema
            // Formatta dueDate con solo l'ora e i minuti
            let content = UNMutableNotificationContent()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let dueTime = dateFormatter.string(from: dueDate)
            content.title = "Checked"
            
            // dueTime passata nella creazione della notifica
            content.body = "\(dueTime) - \(title)"
            content.sound = UNNotificationSound.default
            
            // Aggiungi i valori di id, title e dueDate al campo userInfo del contenuto della notifica
            content.userInfo = [
                "id": newID,
            ]
            
            // Crea azione "Completato"
            let completedIcon = UNNotificationActionIcon(systemImageName: "checkmark.circle")
            let action = UNNotificationAction(
                identifier: "action",
                title: String(format: NSLocalizedString("Complete", comment: "")),
                options: [],
                icon: completedIcon
            )
           
            // Assegna la categoria di notifica al contenuto della notifica
            let category = UNNotificationCategory(identifier: newID, actions: [action], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
            content.categoryIdentifier = newID
            
            // Prepara la notifica desiderata
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: newID, content: content, trigger: trigger)
            
            
            // Invia la richiesta al sistema
            UNUserNotificationCenter.current().add(request)
    }
}
