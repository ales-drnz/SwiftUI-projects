//
//  SupportView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 07/08/23.
//

import SwiftUI

struct SupportView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack {
            ZStack {
                (Light ? Color("Cloud") : .black).ignoresSafeArea()
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Thank you!")
                            .font(.system(size: 50))
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.pink)
                            .font(.system(size: 50))
                    }
                    Text("Thanks for using my app, I hope you are enjoying it as much as I do, if you want to support my efforts and my work in developing it, please consider a small offer.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack (spacing: 0) {
                        HStack {
                            Text("Donate coffee")
                                .font(.system(size: 30))
                            Text("☕️")
                                .font(.system(size: 50))
                        }
                        Button {
                            //
                        } label: {
                            Text("1,49 €")
                                .foregroundStyle(.white).bold()
                                .font(.system(size: 30))
                            
                        }
                        .frame(width: 130, height: 50)
                        .background(Color.pink)
                        .cornerRadius(15)
                    }
                    .padding(.top, 30)
                   
                    Spacer()
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Support")
        }
    }
}

#Preview {
    SupportView()
}
