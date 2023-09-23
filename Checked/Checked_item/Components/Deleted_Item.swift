//
//  DeletedItemView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 10/08/23.
//

import SwiftUI

import SwiftUI

struct DeletedItem: View {
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
    
struct DeletedItem_Previews: PreviewProvider {
    static var previews: some View {
        DeletedItem(item: .init(
            id: "123",
            title: "Get milk",
            notes: "Fare la spesa",
            dueDate: Date().timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: true,
            isPinned: false
        ))
    }
}
