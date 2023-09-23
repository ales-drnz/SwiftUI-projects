//
//  DetailsView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 04/08/23.
//

import SwiftUI

struct DetailsView: View {
    @StateObject var viewModel = NewItemModel()
    @EnvironmentObject private var ToggleDetail: DetailsToggle
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var newItemPresent: Bool
    @State private var backgroundOpacity = false
    @State private var backgroundOpacity1 = false
    @State var showAlertDate = false
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
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        return dateFormatter
    }
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack {
            ZStack {
                (Light ? Color("Cloud") : Color("Deepcloud")).ignoresSafeArea()
                
                List {

    // Detail 1
                    Section {
                        Button {
                            if ToggleDetail.DateOn {
                                // Effetto opacità
                                withAnimation { backgroundOpacity = true }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                                    withAnimation { backgroundOpacity = false }
                                }
                            }
                            if ToggleDetail.Hour {
                                withAnimation { ToggleDetail.showClock = true }
                                withAnimation { ToggleDetail.showCalendar.toggle() }
                            } else {
                                // Tendina attiva/disattiva
                                withAnimation { ToggleDetail.showCalendar.toggle() }
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
                                }
                                .offset(x: -6)
                                .scaleEffect(0.9)
                                
                                if ToggleDetail.DateOn {
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
                                    if ToggleDetail.Hour {
                                        withAnimation { ToggleDetail.Hour.toggle() }
                                        withAnimation { ToggleDetail.DateOn.toggle() }
                                    } else {
                                        withAnimation { ToggleDetail.DateOn.toggle() }
                                        withAnimation { ToggleDetail.showCalendar = false }
                                    }
                                } label: {
                                    Toggle("", isOn: $ToggleDetail.DateOn)
                                        .labelsHidden()
                                        .onChange(of: ToggleDetail.DateOn) { off, on in
                                            if on {
                                                ToggleDetail.DetailsAdded = true
                                            } else {
                                                ToggleDetail.DetailsAdded = false
                                            }
                                        }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(backgroundOpacity ? Color.gray.opacity(0.85) : Light ? Color.white : Color("Darkcloud"))
                        }
                        .listRowInsets(EdgeInsets())
                        
                        if ToggleDetail.DateOn  {
                            if ToggleDetail.showCalendar {
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
                            if ToggleDetail.Hour {
                                // Effetto opacità
                                withAnimation { backgroundOpacity1 = true }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                                    withAnimation { backgroundOpacity1 = false }
                                }
                            }
                            if ToggleDetail.DateOn {
                                withAnimation { ToggleDetail.showCalendar = true }
                                withAnimation { ToggleDetail.showClock.toggle() }
                            } else {
                                withAnimation { ToggleDetail.showClock.toggle() }
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
                                
                                if ToggleDetail.Hour {
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
                                    if !ToggleDetail.DateOn {
                                        withAnimation { ToggleDetail.DateOn.toggle() }
                                        withAnimation { ToggleDetail.showCalendar = true }
                                        withAnimation { ToggleDetail.Hour.toggle() }
                                        withAnimation { ToggleDetail.showClock = false }
                                    } else {
                                        withAnimation { ToggleDetail.showCalendar = true }
                                        withAnimation { ToggleDetail.Hour.toggle() }
                                        withAnimation { ToggleDetail.showClock = false }
                                    }
                                } label: {
                                    Toggle("", isOn: $ToggleDetail.Hour)
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
                        
                        if ToggleDetail.Hour {
                            if ToggleDetail.showClock {
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

                            Picker("", selection: $ToggleDetail.repetition) {
                                Text("None")
                                Text("Every day")
                                Text("Once a week")
                            }
                            .labelsHidden()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
                .listSectionSpacing(.compact)
            }
            .padding(.top, -20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Details")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    if ToggleDetail.DetailsAdded && ToggleDetail.TitleAdded {
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
            .alert(isPresented: $showAlertDate) {
                Alert(
                    title: Text("Date"),
                    message: Text("Please enter a valide date that is today or newer.")
                )
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    @State static var newItemPresent = true
    @State static var DateOn = true
    @State static var Hour = true
    @State static var DetailsAdded = false
    @State static var TitleAdded = false
    
    static var previews: some View {
        DetailsView(newItemPresent: $newItemPresent)
            .environmentObject(DetailsToggle())
    }
}
