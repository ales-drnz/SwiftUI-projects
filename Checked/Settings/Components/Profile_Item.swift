//
//  ProfileElement.swift
//  Checked
//
//  Created by Alessandro Di Ronza on 23/09/23.
//

import SwiftUI

struct ProfileItem: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        NavigationLink  {
            ProfileView()
        } label: {
            if let user = viewModel.user {
                // Vista caricato
                HStack {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.gray, Color("Cloudlight")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 60)
                        
                        if let user = viewModel.user {
                            
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
                                .font(.title2).bold()
                                .foregroundStyle(.white)
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .tint(.white)
                        }
                    }
                    .padding(.trailing, 5)
                    
                    VStack (alignment: .leading, spacing: 0) {
                        Text(user.name)
                            .font(.system(size: 20, design: .rounded)).bold()
                        Text(user.email)
                            .font(.footnote)
                    }
                    Spacer()
                }
            } else {
                // Vista non caricato
                HStack {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.gray, Color("Cloudlight")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 60)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.white)
                    }
                    .padding(.trailing, 5)
                    
                    Text("Loading Profile...")
                        .font(.system(size: 20, design: .rounded)).bold()
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ProfileItem()
}
