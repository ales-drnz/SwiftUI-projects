//
//  ScheduledView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 01/08/23.
//

import FirebaseFirestoreSwift
import SwiftUI

struct PinnedView: View {
    // Modalità Select
    @State private var selection = Set<String>()
    @State private var editMode = EditMode.inactive
    @StateObject private var editItem = EditItem()
    
    // Ambientali
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @StateObject var themeManager = ThemeManager()
    @FirestoreQuery var items: [Checked]
    
    // Altre variabili
    @StateObject var viewModel1 = ToggleStatusModel()
    @StateObject var viewModel2 = DeletedModel()
    @StateObject var viewModel3 = NewItemModel()
    @State private var EditSheet = false
    @State private var InviteSheet = false
    @State private var shouldShowView = false
    @State private var isSheetPresented: Bool = false
    @State var TitleAdded = false
    @State var DateAdded = false
    
    @Binding var newItem: Bool
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case title
        case notes
    }
    
    // Inizializzatore
    init(userID: String, newItem: Binding<Bool>) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userID)/todos"
        )
        self._newItem = newItem
    }
    
    // Date formatters
    var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("dMMMM")
            return dateFormatter
    }
    var groupedItems: [(Date, [Checked])] {
        // Filtra gli elementi in base alla variabile isPinned
        let filteredItems = items.filter { $0.isPinned == true }
        
        // Raggruppa gli elementi utilizzando solo la data (ignorando l'ora)
        let groupedItems = Dictionary(grouping: filteredItems, by: { item in
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
                
                ScrollView {
                    if newItem {
                        Section {
                            Section {
                                VStack (alignment: .leading, spacing: 2) {
                                    HStack (spacing: 10) {
                                        HStack {
                                            if DateAdded {
                                                Text("\(viewModel3.dueDate.formatted(date: .omitted, time: .shortened))")
                                                    .font(.system(size: 20, design: .rounded)).bold()
                                                    .foregroundStyle(.black)
                                                    .frame(width: 70, height: 35)
                                                    .background(.white)
                                                    .cornerRadius(10)
                                            }
                                            
                                            VStack (alignment: .leading, spacing: 0) {
                                                TextField("Title", text: $viewModel3.title)
                                                    .focused($focusedField, equals: .title)
                                                    .submitLabel(.next)
                                                    .font(.body)
                                                    .bold()
                                                    .onChange(of: viewModel3.title) { oldValue, newValue in
                                                        if newValue.isEmpty {
                                                            TitleAdded = false
                                                        } else {
                                                            TitleAdded = true
                                                        }
                                                    }
                                                
                                                TextField("Add notes", text: $viewModel3.notes)
                                                    .focused($focusedField, equals: .notes)
                                                    .font(.footnote)
                                                    .foregroundColor(Color(.secondaryLabel))
                                            }
                                            .onSubmit {
                                                if !viewModel3.title.isEmpty {
                                                    focusedField = .notes
                                                } else {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { withAnimation { newItem = false } }
                                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                                        viewModel3.title = ""
                                                        viewModel3.notes = ""
                                                        DateAdded = false
                                                    }
                                                }
                                            }
                                            .onAppear(perform: {
                                                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                                    focusedField = .title
                                                }
                                            })
                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            isSheetPresented = true
                                        } label: {
                                            HStack (spacing: 3) {
                                                Text("Expand")
                                                Image(systemName: "note.text.badge.plus")
                                                    .font(.title2)
                                            }
                                        }.foregroundStyle(Color("Pureorange"))
                                    }
                                    .padding()
                                    .frame(height: 70)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(style: StrokeStyle(lineWidth: 3, dash: [5]))
                                            .foregroundStyle(Color("Pureorange"))
                                    )
                                    .cornerRadius(15)
                                }
                                .padding(.horizontal)
                                .sheet(isPresented: $isSheetPresented) {
                                    ExpandNewItemView(viewModel: viewModel3, newItemPresent: $isSheetPresented, TitleAdded: $TitleAdded, DateAdded: $DateAdded)
                                        .presentationDetents([.large])
                                        .tint(Color("Darkblue"))
                                }
                            } header: {
                                Text(DateAdded ? "\(viewModel3.dueDate, formatter: dateFormatter)" : "")
                                    .foregroundColor(Color(.secondaryLabel))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(x: 20, y: 8)
                            }
                        } header: {
                            Text(DateAdded ? "Scheduled" : "Not scheduled")
                                .font(.system(size: 25, design: .rounded)).bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 18)
                                .offset(y: 10)
                        }
                        
                    }
                    
                    // Lista Fissati
                    ForEach(groupedItems, id: \.0) { date, items in
                        Section(header: Text(dateFormatter.string(from: date)).offset(x: editMode == .active ? 65 : 20, y: 8).foregroundColor(Color(.secondaryLabel)).frame(maxWidth: .infinity, alignment: .leading)) {
                                ForEach(items) { item in
                                    HStack {
                                        if editMode == .active {
                                            Image(systemName: selection.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                                .font(.title2)
                                                .offset(x: 25)
                                                .onTapGesture {
                                                    withAnimation {
                                                        if selection.contains(item.id) {
                                                            selection.remove(item.id)
                                                        } else {
                                                            selection.insert(item.id)
                                                        }
                                                    }
                                                }
                                        }
                                        
                                        CheckedItem(item: item)
                                            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 15))
                                            .contextMenu {
                                                Button (role: .destructive) {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                                        viewModel2.delete(id: item.id)
                                                    }
                                                } label: {
                                                    Image(systemName: "trash")
                                                    Text("Move to bin")
                                                }
                                                
                                                Divider()
                                                
                                                Button {
                                                    viewModel1.toggleIsPinned(item: item)
                                                } label: {
                                                    Image(systemName: "pin.slash")
                                                    Text("Unpin")
                                                }
                                            }
                                            .padding(.horizontal)
                                            .scrollTransition { content, phase in
                                                content
                                                    .opacity(phase.isIdentity ? 1 : 0)
                                                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                                    .blur(radius: phase.isIdentity ? 0 : 10)
                                            }
                                            .padding(.leading, editMode == .active ? 20 : 0)
                                            
                                    }
                            }
                        }
                    }
                }
                
                if groupedItems.isEmpty && !newItem {
                    if shouldShowView {
                        VStack (spacing: 10) {
                            Text("Nothing to see here.")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 35, design: .rounded))
                                .padding(.horizontal, 70)
                            Image(systemName: "questionmark.folder")
                                .font(.system(size: 50))
                        }.foregroundColor(Color(.secondaryLabel))
                    }
                }
            }
            .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { shouldShowView = true } }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Pinned")
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
                        .tint(Color("Pureorange"))
                        
                        if editMode == .active && !selection.isEmpty {
                                Button {
                                    for id in selection {
                                        viewModel2.delete(id: id)
                                        }
                                        selection.removeAll()
                                } label: {
                                    Text("Bin")
                                }
                                .foregroundStyle(.red)
                        } else {
                            if newItem {
                                Button {
                                    if viewModel3.title.isEmpty {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { withAnimation { newItem = false } }
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                            viewModel3.title = ""
                                            viewModel3.notes = ""
                                            DateAdded = false
                                        }
                                    } else {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { withAnimation { newItem = false } }
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) { viewModel3.save() }
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                            viewModel3.title = ""
                                            viewModel3.notes = ""
                                            DateAdded = false
                                        }
                                    }
                                } label: {
                                    Text("Done")
                                        .foregroundStyle(Color("Darkblue"))
                                }
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
                                viewModel3.isPinned = true
                                withAnimation { newItem = true }
                            } label: {
                                HStack (spacing: 5) {
                                    Image(systemName: "plus.app.fill")
                                    Text("New event")
                                }
                            }
                            .foregroundStyle(Color("Pureorange"))
                            .font(.system(size: 20, design: .rounded)).bold()
                            
                            if UIDevice.current.userInterfaceIdiom == .pad { Spacer() }
                        }
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        .environmentObject(editItem)
        .onDisappear { newItem = false }
    }
}

struct PinnedView_Previews: PreviewProvider {
    @State static var newItem = false
    
    static var previews: some View {
      PinnedView(userID: "NXykqOWQI5Y6bXlWAivAPWATHJi2", newItem: $newItem)
    }
}
