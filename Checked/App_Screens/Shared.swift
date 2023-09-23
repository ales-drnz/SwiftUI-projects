//
//  SharedView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 10/08/23.
//

import FirebaseFirestoreSwift
import SwiftUI

struct SharedView: View {
    // Environmental
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @FirestoreQuery var items: [Checked]
    
    // Others
    @State private var shouldShowView = false
    
    // Initialization
    init(userID: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userID)/todos"
        )
    }
    
    // Date formatters
    var groupedItems: [(Date, [Checked])] {
        // Raggruppa gli elementi utilizzando solo la data (ignorando l'ora)
        let groupedItems = Dictionary(grouping: items, by: { item in
            let itemDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date(timeIntervalSince1970: item.dueDate))!
            return itemDate
        })

        // Ordina gli elementi all'interno di ciascun gruppo per data di scadenza
        let sortedGroupedItems = groupedItems.map { (key, value) in
            let sortedValue = value.sorted(by: { $0.dueDate < $1.dueDate })
            return (key, sortedValue)
        }

        // Ordina i gruppi in base alla data di scadenza
        return sortedGroupedItems.sorted(by: { $0.0 < $1.0 })
    }
    
    var body: some View {
        let Light = colorScheme == .light
        let iPad = UIDevice.current.userInterfaceIdiom == .pad
        
        NavigationStack {
            ZStack {
                (iPad ? Light ? .white : Color("Deepcloud") : Light ? Color("Cloud") : .black).ignoresSafeArea()
                
                if groupedItems.isEmpty {
                    if shouldShowView {
                        VStack (spacing: 10) {
                            Text("Nothing to see here.")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 35, design: .rounded))
                                .padding(.horizontal, 70)
                            Image(systemName: "questionmark.folder")
                                .font(.system(size: 50))
                        }
                    }
                } else {
                    Text("Shared")
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Shared")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack (spacing: 5) {
                                Image(systemName: "person.crop.circle.fill.badge.plus").font(.system(size: 15))
                                Text("Add people")
                            }
                        }
                        .foregroundStyle(Color("Darkblue"))
                        .font(.system(size: 20, design: .rounded)).bold()
                        
                        if UIDevice.current.userInterfaceIdiom == .pad { Spacer() }
                    }
                }
            }
            .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { shouldShowView = true } }
        }
    }
}

#Preview {
    SharedView(userID: "NXykqOWQI5Y6bXlWAivAPWATHJi2")
}
