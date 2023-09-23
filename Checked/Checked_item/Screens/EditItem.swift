//
//  EditItemView.swift
//  Checked
//
//  Created by Alessandro Di Ronza on 15/08/23.
//

import SwiftUI

struct EditItemView: View {
    @StateObject var viewModel = EditItemModel()
    
    @Binding var newItemPresent: Bool
    @Binding var TitleAdded: Bool
    @Binding var DateAdded: Bool
    
    @Environment(\.dismiss) private var dismiss
    @State private var isSheetPresented = false
    let localizedText = NSLocalizedString("Update", comment: "")
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    // Altre variabili
    @State var DateOn = false
    @State var Hour = false
    @State var showCalendar = false
    @State var showClock = false
    @State var repetition = false
    @State var backgroundOpacity = false
    @State var backgroundOpacity1 = false
    @State var showAlertDate = false
    
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
                            .onChange(of: viewModel.title) { oldValue, newValue in
                                if newValue.isEmpty {
                                    TitleAdded = false
                                } else {
                                    TitleAdded = true
                                }
                            }
                
                        TextField("\(Image(systemName: "note.text")) \(Text(LocalizedStringKey("Notes")))", text: $viewModel.notes)
                            .foregroundColor(Color(.secondaryLabel))
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
                        Button {
                            if DateOn {
                                // Effetto opacità
                                withAnimation { backgroundOpacity = true }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                                    withAnimation { backgroundOpacity = false }
                                }
                            }
                            if Hour {
                                withAnimation { showClock = true }
                                withAnimation { showCalendar.toggle() }
                            } else {
                                // Tendina attiva/disattiva
                                withAnimation { showCalendar.toggle() }
                            }
                            
                        } label: {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 35, height: 35)
                                        .font(.system(size: 40))
                                        .foregroundColor(.red)
                                    Image(systemName: "calendar")
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                }.offset(x: -6)
                                .scaleEffect(0.9)
                                
                                if DateOn {
                                    VStack (alignment: .leading, spacing: 0) {
                                        Text("Date")
                                            .foregroundStyle(Light ? .black : .white)
                                           
                                        
                                        if Calendar.current.isDate(viewModel.dueDate, inSameDayAs: Date()) {
                                            Text("Today")
                                                .font(.footnote)
                                                
                                        } else {
                                            Text("\(viewModel.dueDate, formatter: dateFormatter)")
                                                .font(.footnote)
                                        }
                                    }
                                } else { Text("Date").foregroundStyle(Light ? .black : .white) }
                                
                                Spacer()
                                
                                Button {
                                    if Hour {
                                        withAnimation { Hour.toggle() }
                                        withAnimation { DateOn.toggle() }
                                    } else {
                                        withAnimation { DateOn.toggle() }
                                        withAnimation { showCalendar = false }
                                    }
                                } label: {
                                    Toggle("", isOn: $DateOn)
                                        .labelsHidden()
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(backgroundOpacity ? Color.gray.opacity(0.85) : Light ? Color.white : Color("Darkcloud"))
                        }
                        .listRowInsets(EdgeInsets())
                        
                        if DateOn  {
                            if showCalendar {
                            } else {
                                DatePicker("", selection: $viewModel.dueDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .onChange(of: viewModel.dueDate) { oldValue, newValue in
                                        if newValue <= Date().addingTimeInterval(-86400) {
                                            showAlertDate = true
                                            viewModel.dueDate = Date()
                                        }
                                    }
                            }
                        }

    // Detail 2
                        Button {
                            if Hour {
                                // Effetto opacità
                                withAnimation { backgroundOpacity1 = true }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                                    withAnimation { backgroundOpacity1 = false }
                                }
                            }
                            if DateOn {
                                withAnimation { showCalendar = true }
                                withAnimation { showClock.toggle() }
                            } else {
                                withAnimation { showClock.toggle() }
                            }
                            
                        } label: {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 35, height: 35)
                                        .font(.system(size: 40))
                                        .foregroundColor(.yellow)
                                    Image(systemName: "clock.fill")
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                }
                                .offset(x: -6)
                                .scaleEffect(0.9)
                                
                                if Hour {
                                    VStack (alignment: .leading, spacing: 0) {
                                        Text("Time")
                                            .foregroundStyle(Light ? .black : .white)
                                        
                                        Text("\(viewModel.dueDate.formatted(date: .omitted, time: .shortened))")
                                            .font(.footnote)
                                        
                                    }.transaction { transaction in
                                        transaction.animation = nil
                                    }
                                } else { Text("Time").foregroundStyle(Light ? .black : .white) }
                                
                                Spacer()
                                
                                Button {
                                    if !DateOn {
                                        withAnimation { DateOn.toggle() }
                                        withAnimation { showCalendar = true }
                                        withAnimation { Hour.toggle() }
                                        withAnimation { showClock = false }
                                    } else {
                                        withAnimation { showCalendar = true }
                                        withAnimation { Hour.toggle() }
                                        withAnimation { showClock = false }
                                    }
                                } label: {
                                    Toggle("", isOn: $Hour)
                                        .labelsHidden()
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(backgroundOpacity1 ? Color.gray.opacity(0.85) : Light ? Color.white : Color("Darkcloud"))
                        }
                        .listRowInsets(EdgeInsets())
                        
                        if Hour {
                            if showClock {
                            } else {
                                DatePicker("", selection: $viewModel.dueDate, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .onAppear {
                                        UIDatePicker.appearance().minuteInterval = 5
                                        UIDatePicker.appearance().roundsToMinuteInterval = false
                                    }
                            }
                        }
                    }
                    
                    Section {
    // Detail 3
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 35, height: 35)
                                    .font(.system(size: 40))
                                    .foregroundColor(.green)
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                            }
                            .offset(x: -6)
                            .scaleEffect(0.9)
                            
                            Text("Repetition")
                            
                            Spacer()

                            Picker("", selection: $repetition) {
                                Text("None")
                                Text("Every day")
                                Text("Once a week")
                            }
                            .labelsHidden()
                        }
                    }
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
                .listSectionSpacing(.compact)
            }
            .padding(.top, -20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color("Redlight"))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if DateOn && TitleAdded {
                        Button {
                            viewModel.update()
                            newItemPresent = false
                        } label: {
                            Text(localizedText)
                                .foregroundStyle(.white).bold()
                                .frame(width: getTextWidth(text: localizedText), height: 35)
                                .background(Color("Violet"))
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
        .alert(isPresented: $showAlertDate) {
            Alert(
                title: Text("Date"),
                message: Text("Please enter a valide date that is today or newer.")
            )
        }
        .onAppear {
            if DateAdded {
                DateOn = true
                Hour = true
                showCalendar = true
                showClock = true
            } else {
                DateOn = false
                Hour = false
                showCalendar = false
                showClock = false
            }
        }
        .onDisappear {
            DateAdded = false
        }
        .onChange(of: DateOn) { oldValue, newValue in
            if newValue {
                DateAdded = true
            } else {
                DateAdded = false
            }
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    @State static var newItemPresent = true
    @State static var TitleAdded = false
    @State static var DateAdded = false
    
    static var previews: some View {
        EditItemView(newItemPresent: $newItemPresent, TitleAdded: $TitleAdded, DateAdded: $DateAdded)
    }
}

