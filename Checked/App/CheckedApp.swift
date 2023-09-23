//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import UserNotifications
import FirebaseCore
import SwiftUI

@main
struct CheckedApp: App {
    let notificationDelegate = NotificationDelegateClass()
    @StateObject var themeManager = ThemeManager()
    
    init() { FirebaseApp.configure() }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear { UNUserNotificationCenter.current().delegate = notificationDelegate }
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.ThemeSelection == .automatic ? nil : (themeManager.ThemeSelection == .dark ? .dark : .light))
        }
    }
}


