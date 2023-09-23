//
//  NotificationsViewViewModel.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 25/07/23.
//

import UserNotifications
import SwiftUI

class NotificationDelegateClass: NSObject, UNUserNotificationCenterDelegate {
    @StateObject var viewModel = CompletedModel()

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 didReceive response: UNNotificationResponse,
                                 withCompletionHandler completionHandler: @escaping () -> Void) {
        
         // Controlla se l'azione premuta è quella con l'identificatore "action"
         if response.actionIdentifier == "action" {
             
             // Recupera il valore dell'id contenuto nella notifica
             let userInfo = response.notification.request.content.userInfo
             if let id = userInfo["id"] as? String {
                 // Chiamare la funzione complete() o qualsiasi altra azione desiderata
                 viewModel.complete(id: id)
             }
         }
         // Chiamare il completionHandler alla fine della gestione dell'azione
         completionHandler()
     }

}
