//
//  PreviewMenuView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 24/07/23.
//

import FirebaseFirestoreSwift
import SwiftUI

struct PreviewMenuItem: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @StateObject var themeManager = ThemeManager()
    
    let item: Checked
    
    var body: some View {
        let SysLight = colorScheme == .light
        let Light = themeManager.ThemeSelection == .light
        let Dark = themeManager.ThemeSelection == .dark
        
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.body)
                .foregroundColor(Dark ? .white : Light ? Color("Night") : SysLight ? Color("Night") : .white)
                .padding(.top, 15)
            
            Text(item.notes)
                .font(.footnote)
                .foregroundStyle(.gray)
            
            Divider()
                .foregroundColor(Dark ? .white : Light ? .black : SysLight ? .black : .white)
          
            Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .complete, time: .shortened))")
                .foregroundColor(.gray)
                .padding(.bottom, 15)
        }
        .padding(.horizontal, 15)
        .background(Dark ? Color("Night") : Light ? .white : SysLight ? .white : Color("Night"))
    }
}

struct PreviewMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        PreviewMenuItem(item: .init(
            id: "123",
            title: "Andare a fare la spesa.",
            notes: "Andarea a pranzo con la famiglia prima di natale con gli altri amici dei loro parenti e cugini",
            dueDate: Date().timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            isPinned: false
        ))
    }
}
