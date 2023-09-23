//
//  InfoView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 07/08/23.
//

import SwiftUI
import SafariServices

struct InfoView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showSafari1 = false
    @State private var showSafari2 = false
    let url1 = URL(string: "http://todolistapp.infinityfreeapp.com/?i=1")!
    let url2 = URL(string: "https://linktr.ee/ales.drnz")!
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack{
            ZStack {
                (Light ? Color("Cloud") : .black).ignoresSafeArea()
                
                List {
                    Section {
                        VStack (alignment: .leading) {
                            Text("Beta 0.2").font((.title3)).bold()
                            Text("This version includes:")
                            Text("• Main view redesign")
                            Text("• Name, email, password manager")
                            Text("• Item edit")
                            Text("• Widgets")
                            Text("• Animated loadings")
                            Text("• Calendar view")
                            Text("• Improved Sheet")
                        }
                    } header: {
                      Text("Updates")
                    }

                    Section {
                        Button {
                            showSafari1 = true
                        } label: {
                            HStack {
                                Image("InfoIcon").resizable().frame(width: 25, height: 25)
                                Text("To Do List Website")
                            }
                        }
                        .padding(.leading, 3)
                        .fullScreenCover(isPresented: $showSafari1) {
                            SafariView(url: url1)
                                .ignoresSafeArea()
                        }
                        
                        Button {
                            showSafari2 = true
                        } label: {
                            HStack{
                                Image("linktree").resizable().frame(width: 30, height: 30)
                                Text("Creator's network")
                            }
                        }
                        .fullScreenCover(isPresented: $showSafari2) {
                            SafariView(url: url2)
                                .ignoresSafeArea()
                        }
                    } header: {
                        Text("Social")
                    }
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Info")
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }
}

#Preview {
    InfoView()
}
