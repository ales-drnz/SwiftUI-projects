//
//  SettingView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 17/07/23.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    // Environmental
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    // ViewModels
    @StateObject var viewModel = ProfileViewViewModel()
    
    // Others
    @State private var search : String = ""
    @State var setOn = false
    @State var route = true
    @State var showAlertLogOut = false
    
    var body: some View {
        NavigationStack {
            List {
                // Profilo
                Section {
                    ProfileItem(viewModel: viewModel)
                }
                // Lists and Theme
                Section {
                    ForEach(0..<2) { i in
                        ListItem(data: data[i])
                    }
                } header: {
                    Text("Manager")
                }
                
                // Notifications and Languages
                Section {
                    ForEach(2..<4) { i in
                        ListItem(data: data[i])
                    }
                } header: {
                    Text("General")
                }
                
                // Info and Support
                Section {
                    ForEach(4..<6) { i in
                        ListItem(data: data[i])
                    }
                } header: {
                    Text("Help")
                } footer: {
                    Text("Checked - Beta 0.2")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showAlertLogOut = true
                    } label: {
                        HStack (spacing: 5) {
                            Image(systemName: "rectangle.portrait.and.arrow.forward").font(.system(size: 15))
                            Text("Log out")
                        }
                        .foregroundStyle(Color("Redlight"))
                        .font(.system(size: 20, design: .rounded)).bold()
                    }
                }
            }
            .onAppear { viewModel.fetchUser() }
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
            .alert(isPresented: $showAlertLogOut) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to leave?"),
                        
                        primaryButton: .default(
                            Text("Cancel"),
                            action: {}
                        ),
                        secondaryButton: .destructive(
                            Text("Log out"),
                            action: { viewModel.logOut() }
                        )
                    )
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

