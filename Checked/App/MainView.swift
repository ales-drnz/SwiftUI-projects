//
//  ContentView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        
        if viewModel.isSignedIn, !viewModel.currentUserID.isEmpty {
            HomeView(userID: viewModel.currentUserID)
                .tint(Color("Darkblue"))
        } else if !viewModel.isSignedIn, viewModel.currentUserID.isEmpty {
            LogInView()
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
