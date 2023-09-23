//
//  CompletedView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 20/07/23.
//

import FirebaseFirestoreSwift
import SwiftUI

struct CompletedView: View {
    // Ambientali
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @FirestoreQuery var items: [Checked]
    
    // Altre variabili
    @StateObject var viewModel = DeletedModel()
    @State private var showAlert = false
    @State private var shouldShowView = false
    
    // Inizializzatore
    init(userID: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userID)/completed"
        )
    }
    
    // Date formatters
    var yearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("dMMMMHHmm")
        return formatter
    }
    var groupedItems: [(String, [(String, [Checked])])] {
        let groupedByYear = Dictionary(grouping: items, by: { item in
            let date = Date(timeIntervalSince1970: item.dueDate)
            return yearFormatter.string(from: date)
        })
        return groupedByYear.map { (year, items) in
            let groupedByDate = Dictionary(grouping: items, by: { item in
                let date = Date(timeIntervalSince1970: item.dueDate)
                return dateFormatter.string(from: date)
            })
            let sortedGroupedByDate = groupedByDate.map { (date, items) in
                (date, items.sorted(by: { $0.dueDate < $1.dueDate }))
            }.sorted(by: { dateFormatter.date(from: $0.0)! < dateFormatter.date(from: $1.0)! })
            return (year, sortedGroupedByDate)
        }.sorted(by: { $0.0 < $1.0 })
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
                    List {
                        ForEach(groupedItems, id: \.0) { year, dateItems in
                            Section {
                                ForEach(dateItems.reversed(), id: \.0) { date, items in
                                            ForEach(items) { item in
                                                CompletedItem(item: item)
                                                    .swipeActions {
                                                        Button (role: .destructive) {
                                                            viewModel.delete(id: item.id)
                                                        } label: {
                                                            Label("Delete", systemImage: "trash")
                                                        }
                                                        .tint(.red)
                                                    }
                                            }.listRowBackground(Color.clear)
                                    }
                            } header: {
                                Text(year).bold().font(.title)
                                    .foregroundColor(Color.primary)
                                    .listRowBackground(Color.clear)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
            }
            .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { shouldShowView = true } }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Completed")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button (role: .destructive) {
                            showAlert = true
                        } label: {
                            Text("Bin all")
                            Image(systemName: "trash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .tint(Color("Slime"))
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack (spacing: 5) {
                                Image(systemName: "plus.app.fill")
                                Text("New event")
                            }
                        }
                        .foregroundStyle(Color("Slime"))
                        .font(.system(size: 20, design: .rounded)).bold()
                        
                        if UIDevice.current.userInterfaceIdiom == .pad { Spacer() }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure you want to move everything in the bin?"),
                    
                    primaryButton: .default(
                        Text("Cancel"),
                        action: {}
                    ),
                    secondaryButton: .destructive(
                        Text("Move to bin"),
                        action: {
                            viewModel.deleteAll()
                        }
                    )
                )
        }
    }
}

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedView(userID: "NXykqOWQI5Y6bXlWAivAPWATHJi2")
    }
}

