//
//  AllItemView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 01/08/23.
//

import SwiftUI

struct AllItem: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let item: Checked
    
    var body: some View {
        let Light = colorScheme == .light
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Light ? Color("Cloud") : .black)
                .frame(width: 150, height: 30)
            
            Text(item.title)
                .foregroundStyle(Light ? .black : .white)
                .frame(maxWidth: 90, maxHeight: 30, alignment: .leading)
                .padding(.trailing, 40)
                .font(.system(size: 13))
            
            HStack(spacing: 1) {
                Image(systemName: "clock.fill")
                    .foregroundStyle(Color("Pureyellow"))
                Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .omitted, time: .shortened))")
                    .foregroundColor(Color(.secondaryLabel))
            }
            .padding(.leading)
            .font(.system(size: 10))
            .frame(maxWidth: 130, maxHeight: 30, alignment: .trailing)
            
        }
    }
}

#Preview {
    AllItem(item: .init(
        id: "123",
        title: "Andare al parco con quello",
        notes: "",
        dueDate: Date().timeIntervalSince1970,
        createdDate: Date().timeIntervalSince1970,
        isDone: true,
        isPinned: false
    ))
}
