//
//  ProfileView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack {
            ZStack {
                (Light ? Color("Cloud") : .black).ignoresSafeArea()
                
                if let user = viewModel.user {
                    ScrollView {
                        VStack {
                        // Immagine profilo
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.gray, Color("Cloudlight")]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 100)
                                
                                // Iniziali nome utente
                                var initials: String {
                                    let components = user.name.split(separator: " ")
                                    var initials = ""
                                    
                                    if let firstNameInitial = components.first?.first {
                                        initials.append(firstNameInitial)
                                    }
                                    
                                    if components.count > 1, let lastNameInitial = components[1].first {
                                        initials.append(lastNameInitial)
                                    }
                                    
                                    return initials
                                }
                                
                                Text(initials)
                                    .font(.system(size: 40)).bold()
                                    .foregroundStyle(.white)
                            }
                            
                        Text(String(format: NSLocalizedString("Hi %@", comment: ""), user.name.components(separatedBy: " " )[0]))
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                        Text("This is your profile with all the information you have registered.")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: 350, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                        
                        // Name
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Light ? .white : Color("Deepcloud"))
                                .frame(width: 350, height: 80)
                                
                            HStack {
                                Text("Name:")
                                    .font(.title3)
                                Text(user.name)
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Button {
                                    // edit email
                                } label: {
                                    Image(systemName: "person.text.rectangle")
                                        .foregroundStyle(Color("Darkblue"))
                                        .font(.title2)
                                }
                                   
                            }
                            .frame(width: 300)
                        }
                        
                        // Email
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Light ? .white : Color("Deepcloud"))
                                .frame(width: 350, height: 80)
                                
                            HStack {
                                Text("Email:")
                                    .font(.title3)
                                Text(user.email)
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Button {
                                    // edit email
                                } label: {
                                    Image(systemName: "paperclip")
                                        .foregroundStyle(Color("Darkblue"))
                                        .font(.title2)
                                }
                                   
                            }
                            .frame(width: 300)
                        }
                        
                        // Password
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Light ? .white : Color("Deepcloud"))
                                .frame(width: 350, height: 80)
                        
                            HStack {
                                Button {
                                    // edit password
                                } label: {
                                    Text("Reset password")
                                        .font(.title3)
                                        .foregroundStyle(Color("Redlight"))
                                    Spacer()
                                    Image(systemName: "key")
                                        .foregroundStyle(Color("Redlight"))
                                        .font(.title2)
                                }
                                   
                            }
                            .frame(width: 300)
                        }
                        
                        // Delete account
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Light ? .white : Color("Deepcloud"))
                                .frame(width: 350, height: 80)
                                
                            HStack {
                                Button {
                                    // edit password
                                } label: {
                                    Text("Delete account")
                                        .font(.title3)
                                        .foregroundStyle(Color("Redlight"))
                                    Spacer()
                                    Image(systemName: "person.badge.minus")
                                        .foregroundStyle(Color("Redlight"))
                                        .font(.title2)
                                }
                            }
                            .frame(width: 300)
                        }
                        
                        // Member since
                        HStack {
                            Text("Member since:")
                            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .omitted))")
                        }
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.top)
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
                } else {
                    VStack(spacing: 30) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(3)
                        Text("Loading Profile...")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Profile")
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
