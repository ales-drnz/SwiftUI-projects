//
//  Data.swift
//  Checked
//
//  Created by Alessandro Di Ronza on 23/09/23.
//

import Foundation
import SwiftUI

struct ListData: Identifiable {
    var id: Int
    var icon: String
    var color: Color
    var text: Text
    var view: AnyView
}

var data = [
    ListData(id: 0,
             icon: "list.bullet",
             color: .blue,
             text: Text("Lists"),
             view: AnyView(ListsView())),
    
    ListData(id: 1,
             icon: "paintbrush.fill",
             color: Color("Pureorange"),
             text: Text("Theme"),
             view: AnyView(ThemeView())),
    
    ListData(id: 2,
             icon: "bell.badge.fill",
             color: .red, text: Text("Notifications"),
             view: AnyView(NotificationView())),
    
    ListData(id: 3,
             icon: "globe",
             color: Color("Slime"),
             text: Text("Language"),
             view: AnyView(LanguageView())),
    
    ListData(id: 4,
             icon: "info",
             color: Color("Acquablue"),
             text: Text("Info"),
             view: AnyView(InfoView())),
    
    ListData(id: 5,
             icon: "heart.fill",
             color: Color("Heart"),
             text: Text("Support"),
             view: AnyView(SupportView()))
]
