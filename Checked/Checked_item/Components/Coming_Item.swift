//
//  RecentItemView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 03/08/23.
//

import SwiftUI

struct ComingItem: View {
    @State private var currentTime = Date()
    let item: Checked
    
    var body: some View {
        HStack {
            
            var dateTimeFormatter: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM"
                return formatter
            }
            
            HStack(spacing: -4) {
                Text(item.title)
                    .font(.body)
                    .frame(maxWidth: 200, maxHeight: 30, alignment: .leading)
                Spacer()
                ZStack {
                    if item.isPinned {
                        Image(systemName: "pin.fill")
                            .foregroundStyle(Color("Pureorange"))
                            .offset(x: -45)
                    }
                    Image(systemName: "calendar")
                        .foregroundStyle(Color("Purered"))
                        .offset(x: -28)
                    Text("\(dateTimeFormatter.string(from: Date(timeIntervalSince1970: item.dueDate)))")
                        .foregroundColor(Color(.secondaryLabel))
                        .font(.footnote)
                }
                .font(.system(size: 12))
            }
        }
    }
}

#Preview {
    ComingItem(item: .init(
        id: "123",
        title: "andare al parco con gli amici e vincere la lotteria al cruscotto",
        notes: "",
        dueDate: Date().timeIntervalSince1970,
        createdDate: Date().timeIntervalSince1970,
        isDone: true,
        isPinned: false
    ))
}
