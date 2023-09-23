//
//  ListsView.swift
//  Checked
//
//  Created by Alessandro Di Ronza on 17/08/23.
//

import SwiftUI

struct ListsView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack{
            ZStack {
                (Light ? Color("Cloud") : .black).ignoresSafeArea()
                
                List {
                    Text("Lists")
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Info")
        }
    }
}

#Preview {
    ListsView()
}
