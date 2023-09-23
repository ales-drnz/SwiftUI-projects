//
//  NewItemView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import SwiftUI

class DetailsToggle: ObservableObject {
    @Published var DateOn = false
    @Published var Hour = false
    @Published var showCalendar = false
    @Published var showClock = false
    @Published var repetition = false
    @Published var DetailsAdded = false
    @Published var TitleAdded = false
}

struct NewItemView: View {
    @StateObject var viewModel = NewItemModel()
    @StateObject var viewModel1 = DetailsToggle()
    @Binding var newItemPresent: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var isSheetPresented = false
    @FocusState var isFocused: Bool
    @State var cancelAlert = false
    let localizedText = NSLocalizedString("Save", comment: "")
    
    // Cambia dinamicamente la dimensione del frame in base alla lunghezza del testo
    func getTextWidth(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16) // You can adjust the font size
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        return size.width + 25 // Additional padding for better aesthetics
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter
    }
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack {
            ZStack {
                (Light ? Color("Cloud") : Color("Deepcloud")).ignoresSafeArea()
                
                List {
                    Section {
                        TextField("\(Image(systemName: "square.and.pencil")) \(Text(LocalizedStringKey("Title")))", text: $viewModel.title)
                            .focused($isFocused)
                            .onChange(of: viewModel.title) { oldValue, newValue in
                                if newValue.isEmpty {
                                    viewModel1.TitleAdded = false
                                } else {
                                    viewModel1.TitleAdded = true
                                }
                            }
                
                        TextField("\(Image(systemName: "note.text")) \(Text(LocalizedStringKey("Notes")))", text: $viewModel.notes)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.bottom, 50)
                    }
                    Section {
                        Button {
                            //
                        } label: {
                            HStack (spacing: 3) {
                                Image(systemName: "photo")
                                Text("Add image")
                            }
                        }
                    }
                    Section {
                        NavigationLink(destination: DetailsView(viewModel: viewModel, newItemPresent: $newItemPresent)) {
                            if viewModel1.DateOn {
                                if viewModel1.Hour {
                                    VStack (alignment: .leading, spacing: 1) {
                                        Text("Details")
                                        HStack (spacing: 3) {
                                            Text("\(viewModel.dueDate, formatter: dateFormatter) -")
                                            Text("\(viewModel.dueDate.formatted(date: .omitted, time: .shortened))")
                                        }
                                        .font(.footnote)
                                        .foregroundStyle(Color("Darkblue"))
                                    }
                                    
                                } else {
                                    VStack (alignment: .leading, spacing: 1) {
                                        Text("Details")
                                        HStack (spacing: 3) {
                                            Text("\(viewModel.dueDate, formatter: dateFormatter)")
                                        }
                                        .font(.footnote)
                                        .foregroundStyle(Color("Darkblue"))
                                    }
                                }
                            } else {
                                Text("Details")
                            }
                        }
                    }
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
                .listSectionSpacing(.compact)
            }
            .padding(.top, -20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New event")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if viewModel1.DetailsAdded || viewModel1.TitleAdded {
                            cancelAlert = true
                        } else {
                            dismiss.callAsFunction()
                        }
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color("Redlight"))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel1.DetailsAdded && viewModel1.TitleAdded {
                        Button {
                            viewModel.save()
                            newItemPresent = false
                        } label: {
                            Text(localizedText)
                                .foregroundStyle(.white).bold()
                                .frame(width: getTextWidth(text: localizedText), height: 35)
                                .background(Color("Darkblue"))
                                .cornerRadius(10)
                        }
                    } else {
                        Text(localizedText)
                            .foregroundStyle(.white).bold()
                            .frame(width: getTextWidth(text: localizedText), height: 35)
                            .background(Color.gray)
                            .cornerRadius(10)
                            .padding(.horizontal, 8)
                    }
                }
            }
        }
        .onAppear(perform: { DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { isFocused = true } })
        .alert(isPresented: $cancelAlert) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure you want to cancel?"),
                    
                    primaryButton: .default(
                        Text("No"),
                        action: {}
                    ),
                    secondaryButton: .destructive(
                        Text("Yes"),
                        action: {
                            dismiss.callAsFunction()
                        }
                    )
                )
        }
        .environmentObject(viewModel1)
    }
}

struct NewItemView_Previews: PreviewProvider {
    @State static var newItemPresent = true
    @State static var Trigger = false
    
    static var previews: some View {
        NewItemView(newItemPresent: $newItemPresent)
    }
}

