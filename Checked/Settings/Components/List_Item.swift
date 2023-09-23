//
//  ListElement.swift
//  Checked
//
//  Created by Alessandro Di Ronza on 23/09/23.
//

import Foundation
import SwiftUI

struct ListItem: View {
    var data: ListData
    
    var body: some View {
        NavigationLink  {
            data.view
        } label: {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 35, height: 35)
                        .font(.system(size: 40))
                        .foregroundColor(data.color)
                    Image(systemName: data.icon)
                        .foregroundStyle(.white)
                        .font(.title2)
                }
                .padding(.trailing, 5)
                .scaleEffect(0.9)
                
                data.text
                Spacer()
            }
        }
    }
}

