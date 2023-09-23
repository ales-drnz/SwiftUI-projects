//
//  PinnedItemView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/08/23.
//

import SwiftUI

struct PinnedItem: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let item: Checked
    
    var daysLeft: Int {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date()) // Ignora l'ora
        let dueDateAsDate = Date(timeIntervalSince1970: item.dueDate)
        let dueDateStartOfDay = calendar.startOfDay(for: dueDateAsDate) // Ignora l'ora
        let components = calendar.dateComponents([.day], from: currentDate, to: dueDateStartOfDay)
        
        if let days = components.day {
            return max(days, 0) // Assicura che il valore sia almeno 0
        } else {
            return 0
        }
    }

    
    var body: some View {
        let Light = colorScheme == .light
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Light ? Color("Cloud") : .black)
                .frame(width: 150, height: 30)
            
            Text(item.title)
                .foregroundStyle(Light ? .black : .white)
                .frame(maxWidth: 110, maxHeight: 30, alignment: .leading)
                .padding(.trailing, 20)
                .font(.system(size: 13))
            
            HStack(spacing: 1) {
                Text(String(format: NSLocalizedString("-%dd", comment: ""), daysLeft))
                    .foregroundColor(Color(.secondaryLabel))
            }
            .padding(.leading)
            .font(.system(size: 10))
            .frame(maxWidth: 130, maxHeight: 30, alignment: .trailing)
            
        }
    }
}

#Preview {
    PinnedItem(item: .init(
        id: "123",
        title: "Andare al parco con quello",
        notes: "",
        dueDate: Date().timeIntervalSince1970,
        createdDate: Date().timeIntervalSince1970,
        isDone: true,
        isPinned: false
    ))
}
