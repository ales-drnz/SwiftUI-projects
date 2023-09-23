//
//  LanguageView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 02/08/23.
//

import SwiftUI

enum Language: String, CaseIterable, Identifiable {
    case it, en
    
    var id: Self { self }
    
    var displayName: String {
        switch self {
        case .it:
            return NSLocalizedString("Italian", comment: "")
        case .en:
            return NSLocalizedString("English", comment: "")
        }
    }
}

struct LanguageView: View {
    @State private var showAlertLanguage = false
    @State private var LanguageSelection : Language
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let language = Locale.current.language.languageCode?.identifier
    
    init() {
        // Recupera la lingua preferita dall'utente dalle preferenze utente
        let selectedLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
        
        // Imposta il valore iniziale di LanguageSelection in base alla lingua preferita dall'utente
        _LanguageSelection = State(initialValue: Language(rawValue: selectedLanguage) ?? .en)
    }
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack {
            ZStack {
                (Light ? Color("Cloud") : .black).ignoresSafeArea()
                
                List {
                    Section {
                        Picker("Select language", selection: $LanguageSelection) {
                            Text("English").tag(Language.en)
                            Text("Italian").tag(Language.it)
                        }
                        .onChange(of: LanguageSelection) { oldValue, newValue in
                            let selectedLanguage = newValue.rawValue
                            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
                            UserDefaults.standard.synchronize()
                            showAlertLanguage = true
                        }
                        .alert(isPresented: $showAlertLanguage) {
                            Alert(
                                title: Text("Language"),
                                message: Text(String(format: NSLocalizedString("In order to change the language to %@ please restart the app.", comment: ""), LanguageSelection.displayName)),
                                dismissButton: .default(Text("Ok"), action: {
                                    showAlertLanguage = false
                                })
                            )
                        }
                    } header: {
                        Text("Language")
                    }
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Language")
        }
    }
}

#Preview {
    LanguageView()
}
