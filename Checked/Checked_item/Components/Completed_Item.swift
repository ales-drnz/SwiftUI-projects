//
//  CompletedItemView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 21/07/23.
//

import SwiftUI

struct CompletedItem: View {
    let item: Checked
    
    var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HHmm")
        return formatter
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter
    }
    
    var body: some View {
        HStack {
            
            Image(systemName: "largecircle.fill.circle")
            
            VStack (alignment: .leading, spacing: 0) {
                
                Text(item.title)
                    .font(.body)
                
                if item.notes != "" {
                    Text(item.notes)
                        .font(.footnote)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            
            Spacer()
            
            VStack (alignment: .trailing) {
                Text("\(dateFormatter.string(from: Date(timeIntervalSince1970: item.dueDate)))")
                    .foregroundColor(Color(.secondaryLabel))
                Text("\(dateTimeFormatter.string(from: Date(timeIntervalSince1970: item.dueDate)))")
                    .foregroundColor(Color(.secondaryLabel))
            }
            .font(.footnote)
        }
    }
}
    
struct CompletedItem_Previews: PreviewProvider {
    static var previews: some View {
        CompletedItem(item: .init(
            id: "123",
            title: "Get milk",
            notes: "",
            dueDate: Date().timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: true,
            isPinned: false
        ))
    }
}

