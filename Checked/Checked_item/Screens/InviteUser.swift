//
//  InviteUserView.swift
//  Checked
//
//  Created by Alessandro Di Ronza on 12/08/23.
//

import SwiftUI

struct InviteUserView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss
    @Binding var newItemPresent: Bool
    @State private var isSheetPresented = false
    @State var email: String = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack {
            ZStack {
                (Light ? Color("Cloud") : Color("Deepcloud")).ignoresSafeArea()
                
                List {
                    Image(systemName: "person.2.circle")
                        .foregroundStyle(Color("Darkblue"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 120))
                        .listRowBackground(Color.clear)
                        .padding(.vertical, -15)
                    
                    Section {
                        TextField("\(Image(systemName: "envelope")) \(Text(LocalizedStringKey("User email")))", text: $email)
                            .focused($isFocused)
                    } header: {
                        Text("Invitation")
                    }
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
                .listSectionSpacing(.compact)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Share")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color("Redlight"))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if email != "" {
                        Button {
                            
                      //      newItemPresent = false
                        } label: {
                            Text("Invite")
                                .foregroundStyle(.white).bold()
                                .frame(width: 60, height: 35)
                                .background(Color("Darkblue"))
                                .cornerRadius(10)
                        }
                    } else {
                        Text("Invite")
                            .foregroundStyle(.white).bold()
                            .frame(width: 60, height: 35)
                            .background(Color.gray)
                            .cornerRadius(10)
                            .padding(.horizontal, 8)
                    }
                }
            }
        }
        .onAppear { isFocused = true }
    }
}

struct InviteUserView_Previews: PreviewProvider {
    @State static var newItemPresent = true
    
    static var previews: some View {
        InviteUserView(newItemPresent: $newItemPresent)
    }
}
