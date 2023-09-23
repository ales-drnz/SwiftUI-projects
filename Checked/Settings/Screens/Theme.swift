//
//  ThemeView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 02/08/23.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var ThemeSelection: Theme = {
        // Recupera il tema preferito dall'utente dalle preferenze utente
        let selectedTheme = UserDefaults.standard.string(forKey: "AppleThemes") ?? Theme.automatic.rawValue
        
        // Imposta il valore iniziale di ThemeSelection in base al tema preferito dall'utente
        return Theme(rawValue: selectedTheme) ?? .automatic
    }()
}

enum Theme: String, CaseIterable {
    case automatic = "Auto"
    case light = "Light"
    case dark = "Dark"
}

struct ThemeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var isLightOn = false
    @State private var isDarkOn = false
    @State private var isAutoOn = false
    
    init() {
        UserDefaults.standard.register(defaults: ["isAutoOn": true])
        isLightOn = UserDefaults.standard.bool(forKey: "isLightOn")
        isDarkOn = UserDefaults.standard.bool(forKey: "isDarkOn")
        isAutoOn = UserDefaults.standard.bool(forKey: "isAutoOn")
    }
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack {
            ZStack {
                (Light ? Color("Cloud") : .black).ignoresSafeArea()
                
                List {
                    Section {
                        HStack (spacing: 35) {
                            // Light
                            Button {
                                isLightOn = true
                                isDarkOn = false
                                isAutoOn = false
                                themeManager.ThemeSelection = .light
                            } label: {
                                VStack {
                                    Image("iPhoneLight").resizable()
                                        .frame(width: 80, height: 160)
                                    Text("Light")
                                        .padding(.top, 5)
                                        .foregroundStyle(Light ? .black : .white)
                                    Image(systemName: isLightOn ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .padding(.top, -2)
                                        .foregroundStyle(Color("Darkblue"))
                                }
                            }
                          
                            
                            // Dark
                            Button {
                                isLightOn = false
                                isDarkOn = true
                                isAutoOn = false
                                themeManager.ThemeSelection = .dark
                            } label: {
                                VStack {
                                    Image("iPhoneDark").resizable()
                                        .frame(width: 80, height: 160)
                                    Text("Dark")
                                        .padding(.top, 5)
                                        .foregroundStyle(Light ? .black : .white)
                                    Image(systemName: isDarkOn ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .padding(.top, -2)
                                        .foregroundStyle(Color("Darkblue"))
                                }
                            }
                            
                            
                            // Auto
                            Button {
                                isLightOn = false
                                isDarkOn = false
                                isAutoOn = true
                                themeManager.ThemeSelection = .automatic
                            } label: {
                                VStack {
                                    Image("iPhoneAuto").resizable()
                                        .frame(width: 80, height: 160)
                                    Text("Auto")
                                        .padding(.top, 5)
                                        .foregroundStyle(Light ? .black : .white)
                                    Image(systemName: isAutoOn ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .padding(.top, -2)
                                        .foregroundStyle(Color("Darkblue"))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .buttonStyle(BorderlessButtonStyle())
                        .onChange(of: themeManager.ThemeSelection) { oldValue, newValue in
                            let selectedTheme = newValue.rawValue
                            UserDefaults.standard.set(selectedTheme, forKey: "AppleThemes")
                            UserDefaults.standard.set(isLightOn, forKey: "isLightOn")
                            UserDefaults.standard.set(isDarkOn, forKey: "isDarkOn")
                            UserDefaults.standard.set(isAutoOn, forKey: "isAutoOn")
                            UserDefaults.standard.synchronize()
                        }
                        .onAppear {
                            isLightOn = UserDefaults.standard.bool(forKey: "isLightOn")
                            isDarkOn = UserDefaults.standard.bool(forKey: "isDarkOn")
                            isAutoOn = UserDefaults.standard.bool(forKey: "isAutoOn")
                                }
                    } header: {
                        Text("Appearance")
                    } footer: {
                        Text("Choose the app look by selecting one of these options.")
                    }
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Theme")
            .environmentObject(themeManager)
        }
    }
}

#Preview {
    ThemeView()
        .environmentObject(ThemeManager())
}
