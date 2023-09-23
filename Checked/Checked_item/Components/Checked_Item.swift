//
//  ToDoListItmesView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import FirebaseFirestoreSwift
import SwiftUI

struct CheckedItem: View {
    @StateObject var viewModel = ToggleStatusModel()
    @StateObject var viewModel1 = CompletedModel()
    @State private var currentTime = Date()
    @State private var isButtonPressed = false
    @State private var timer: Timer?
    @State private var shapeWidth: CGFloat = 0
    @State private var maxWidth: CGFloat = 0
    
    let item: Checked
    @EnvironmentObject var SelectItem: EditItem
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func animateShape() {
        withAnimation(.linear(duration: 5)) {
            shapeWidth = 0
        }
    }
    
    // Cambia dinamicamente la dimensione del frame in base alla lunghezza del testo
    func getTextWidth(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16) // You can adjust the font size
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        return size.width + 25 // Additional padding for better aesthetics
    }
    
    var body: some View {
        let Expired = Date(timeIntervalSince1970: item.dueDate) <= currentTime
        let Done = item.isDone == true
        let notDone = item.isDone == false
        let Pinned = item.isPinned == true
        
        ZStack {
            HStack {
                if Expired {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(item.title)
                                .font(.body)
                                .bold()
                                .foregroundColor(.white)
                            if item.notes != "" {
                                Text(item.notes)
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                            Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .omitted, time: .shortened))")
                                .font(.footnote).bold()
                                .foregroundColor(.white)
                                .offset(y: 3)
                        }
                        .padding(.leading, 5)
                    }
                } else {
                    HStack (spacing: 10) {
                        Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .omitted, time: .shortened))")
                            .frame(width: getTextWidth(text: "\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .omitted, time: .shortened))"), height: 35)
                            .foregroundStyle(.black).bold()
                            .background(.white)
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(item.title)
                                .font(.body)
                                .bold()
                                .foregroundColor(.white)
                            if item.notes != "" {
                                Text(item.notes)
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    viewModel.toggleIsDone(item: item)
                    
                    if isButtonPressed {
                        shapeWidth = maxWidth
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            animateShape()
                        }
                    }
                    
                    if isButtonPressed {
                        // Se il bottone è stato premuto una seconda volta,
                        // annulla l'azione precedente e resetta il timer.
                        timer?.invalidate()
                        isButtonPressed = false
                    } else {
                        // Altrimenti, imposta il bottone come premuto e avvia il timer.
                        isButtonPressed = true
                        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                            viewModel1.complete(id: item.id)
                            isButtonPressed = false // Ripristina lo stato del bottone
                        }
                    }
                } label: {
                    Image(systemName: item.isDone ? "checkmark" : "circle")
                        .foregroundColor(
                            SelectItem.setEdit == true ? .clear : .white
                        )
                        .font(.title2)
                        .contentTransition(.symbolEffect(.replace))
                }
            }
        }
        .padding()
        .frame(height: 70)
        .overlay(
            Group {
                if Expired && notDone {
                    HStack (spacing: 2) {
                        Text("Expired")
                            .bold()
                            .foregroundColor(.red)
                            .offset(y: -7)
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .offset(y: -7)
                    }
                    .padding()
                    .frame(width: 125, height: 35)
                    .background(.white)
                    .cornerRadius(10)
                    .offset(y: 32)
                }
                
                if Done {
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.white)
                            .frame(width: shapeWidth, height: 10)
                            .offset(y: 67)
                            .onAppear {
                                shapeWidth = geometry.size.width
                                maxWidth = geometry.size.width
                            }
                    }
                }
            }
        )
        .background(Done ? Color("Slime") : Expired ? Color("Redlight") : Pinned ? .orange : Color("Darkblue"))
        .cornerRadius(15)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            currentTime = Date()
        }
        .onDisappear {
            if isButtonPressed {
                viewModel1.complete(id: item.id)
            }
        }
    }
    
}

struct CheckedItem_Previews: PreviewProvider {
    static var previews: some View {
        CheckedItem(item: .init(
            id: "123",
            title: "Andare a fare la spesa in famiglia al mercato",
            notes: "Gita con amici",
            dueDate: Date().timeIntervalSince1970 + 300,
            createdDate: Date().timeIntervalSince1970,
            isDone: true,
            isPinned: false
        ))
        .environmentObject(EditItem())
    }
}
