//
//  NotificationView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 02/08/23.
//

import SwiftUI

struct NotificationView: View {
    @State private var showingAlert = false
    @State private var sound = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var setOn: Bool = UserDefaults.standard.bool(forKey: "ToggleNotificationOn")
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack {
            ZStack {
                (Light ? Color("Cloud") : .black).ignoresSafeArea()
                
                List {
                    Section {
                        HStack {
                            
                            if !setOn {
                                Circle()
                                    .frame(width: 10)
                                    .foregroundStyle(.red)
                            }
                            
                            Toggle("Enable notifications", isOn: $setOn)
                                .onChange(of: setOn) { oldValue, newValue in
                                    UserDefaults.standard.set(newValue, forKey: "ToggleNotificationOn")
                                    UserDefaults.standard.synchronize()
                                    if newValue {
                                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                            if success {} else {showingAlert = true}
                                        }
                                    }
                                }
                                .onReceive(timer) { _ in
                                                UNUserNotificationCenter.current().getNotificationSettings { settings in
                                                    if settings.authorizationStatus == .denied {
                                                        setOn = false
                                                    }
                                                }
                                }
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text("Error"), message: Text("Please enable notifications in system settings."))
                                }
                        }
                        Picker("Sound", selection: $sound) {
                            Text("Default")
                            Text("Nota")
                            Text("Cinguettio")
                        }
                    } header: {
                        Text("Notifications")
                    }
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Notifications")
        }
    }
}

#Preview {
    NotificationView()
}
