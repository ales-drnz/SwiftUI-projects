//
//  Shimmer.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 01/08/23.
//

import SwiftUI

struct CardShimmerItem: View {
    @State var show = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View {
        let Light = colorScheme == .light
        
        ZStack {
            Color(Light ?.black.opacity(0.09) : .gray.opacity(0.2))
                .frame(width: 160, height: 120)
                .cornerRadius(15)
            
            Color.white
                .frame(width: 160, height: 120)
                .cornerRadius(15)
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: .init(colors: [.clear, Color.white.opacity(0.48), .clear]), startPoint: .top, endPoint: .bottom)
                        )
                        .rotationEffect(.init(degrees: 70))
                        .offset(x: self.show ? center : -center)
                )
        }
        .onAppear {
            withAnimation(Animation.default.speed(0.15).delay(0)
                .repeatForever(autoreverses: false)) {
                    self.show.toggle()
                }
        }
    }
}

struct CardShimmerLongItem: View {
    @State var show = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View {
        let Light = colorScheme == .light
        
        ZStack {
            Color(Light ?.black.opacity(0.09) : .gray.opacity(0.2))
                .frame(height: 70)
                .cornerRadius(15)
            
            Color.white
                .frame(height: 70)
                .cornerRadius(15)
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: .init(colors: [.clear, Color.white.opacity(0.48), .clear]), startPoint: .top, endPoint: .bottom)
                        )
                        .rotationEffect(.init(degrees: 70))
                        .offset(x: self.show ? center : -center)
                )
        }
        .onAppear {
            withAnimation(Animation.default.speed(0.15).delay(0)
                .repeatForever(autoreverses: false)) {
                    self.show.toggle()
                }
        }
    }
}


#Preview {
    CardShimmerItem()
}
