//
//  DeletedView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 10/08/23.
//

import FirebaseFirestoreSwift
import SwiftUI

struct DeletedView: View {
    // Selection mode
    @State private var selection = Set<String>()
    @State private var editMode = EditMode.inactive
    @StateObject private var editItem = EditItem()
    
    // Environmental
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @FirestoreQuery var items: [Checked]
    
    // Others
    @StateObject var viewModel = DeletedModel()
    @State var showAlert = false
    @State private var shouldShowView = false
    
    // Initialization
    init(userID: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userID)/deleted"
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
                                                HStack {
                                                    if editMode == .active {
                                                        Image(systemName: selection.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                                            .font(.title2)
                                                            .onTapGesture {
                                                                if selection.contains(item.id) {
                                                                    selection.remove(item.id)
                                                                } else {
                                                                    selection.insert(item.id)
                                                                }
                                                            }
                                                    }
                                                    DeletedItem(item: item)
                                                        .padding(.leading, editMode == .active ? 10 : 0)
                                                }
                                                .swipeActions {
                                                    Button (role: .destructive) {
                                                        viewModel.deleteItem(id: item.id)
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                    .tint(.red)
                                                }
                                                .swipeActions (edge: .leading) {
                                                    Button (role: .destructive) {
                                                        viewModel.recover(id: item.id)
                                                    } label: {
                                                        Label("Recover", systemImage: "tray.and.arrow.up.fill")
                                                    }
                                                    .tint(Color("Violet"))
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
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Deleted")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Menu {
                            Button {
                                withAnimation {
                                    editItem.setEdit = true
                                    editMode = .active
                                }
                            } label: {
                                Text("Multiple-selection")
                                Image(systemName: "eraser.line.dashed")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        .tint(Color("Darkblue"))
                        
                        if editMode == .active && !selection.isEmpty {
                                Button {
                                    for id in selection {
                                        viewModel.recover(id: id)
                                        }
                                        selection.removeAll()
                                } label: {
                                    HStack {
                                        Text("Recover")
                                    }.foregroundStyle(Color("Violet"))
                                }
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    if editMode == .active {
                        HStack {
                            Button {
                                withAnimation { editMode = .inactive }
                                selection.removeAll()
                                editItem.setEdit = false
                            } label: {
                                HStack (spacing: 5) {
                                    Image(systemName: "arrow.uturn.backward.square.fill")
                                    Text("Dismiss")
                                }
                            }
                            .foregroundStyle(Color("Violet"))
                            .font(.system(size: 20, design: .rounded)).bold()
                            
                            if UIDevice.current.userInterfaceIdiom == .pad { Spacer() }
                        }
                    } else {
                        HStack {
                            Button {
                                showAlert = true
                            } label: {
                                HStack (spacing: 5) {
                                    Image(systemName: "trash.fill").font(.system(size: 15))
                                    Text("Delete All")
                                }
                            }
                            .foregroundStyle(Color("Darkblue"))
                            .font(.system(size: 20, design: .rounded)).bold()
                            
                            if UIDevice.current.userInterfaceIdiom == .pad { Spacer() }
                        }
                    }
                }
            }
            .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { shouldShowView = true } }
            .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to delete everything?"),
                        
                        primaryButton: .default(
                            Text("Cancel"),
                            action: {}
                        ),
                        secondaryButton: .destructive(
                            Text("Yes"),
                            action: {
                                viewModel.deleteItemAll()
                            }
                        )
                    )
            }
        }
        .environment(\.editMode, $editMode)
        .environmentObject(editItem)
    }
}

struct DeletedView_Previews: PreviewProvider {
    static var previews: some View {
        DeletedView(userID: "NXykqOWQI5Y6bXlWAivAPWATHJi2")
    }
}
