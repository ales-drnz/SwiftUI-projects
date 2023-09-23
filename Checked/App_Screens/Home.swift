//
//  AllView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 31/07/23.
//

import FirebaseFirestoreSwift
import SwiftUI

struct HomeView: View {
    // Environmental
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @FirestoreQuery var items: [Checked]
    @FirestoreQuery var items1: [Checked]
    
    // ViewModels
    @StateObject var viewModel = MainViewModel()
    @StateObject var viewModel1: CheckedModel
    @StateObject var viewModel2 = CompletedModel()
    @StateObject var viewModel3 = ToggleStatusModel()
    @StateObject var viewModel4 = DeletedModel()
    
    // Others
    @State private var isSheetPresented: Bool = false
    @State private var route1: Bool = false
    @State private var route2: Bool = false
    @State private var route3: Bool = false
    @State private var route4: Bool = false
    @State private var route5: Bool = false
    @State private var route6: Bool = false
    @State private var routeSettings: Bool = false
    @State var isViewHidden = true
    @State var newItem = false
    @State private var showWelcomeText = true
    
    // Initialization
    init(userID: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userID)/todos"
        )
        self._items1 = FirestoreQuery(
            collectionPath: "users/\(userID)/completed"
        )
        self._viewModel1 = StateObject(
            wrappedValue: CheckedModel(userID: userID)
        )
    }

    var body: some View {
        
        // Small Date formatters
        let Light = colorScheme == .light
        let today = Date()
   
        let TodayItems = items.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate)
            return Calendar.current.isDate(itemDate, inSameDayAs: today)
        }.sorted { $0.dueDate < $1.dueDate }
        
        let PinnedItems = items.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate)
            let today = Date()
            let calendar = Calendar.current
            let itemDay = calendar.component(.day, from: itemDate)
            let todayDay = calendar.component(.day, from: today)
            let isItemValid = itemDate >= today && itemDay != todayDay && item.isPinned
            return isItemValid
        }.sorted { $0.dueDate < $1.dueDate }

        let ComingItems = items.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate)
            let today = Date()
            let calendar = Calendar.current
            let itemDay = calendar.component(.day, from: itemDate)
            let todayDay = calendar.component(.day, from: today)
            return itemDate >= today && itemDay != todayDay
        }.sorted { $0.dueDate < $1.dueDate }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        
// iPad
            NavigationSplitView {
                NavigationStack {
                    ZStack {
                        (Light ? Color("Cloud") : .black).ignoresSafeArea()
                        List {
                            Section {
                                VStack (spacing: 15) {
                                    HStack (spacing: 15){
// Today iPad
                                        if viewModel1.isLoading {
                                            CardShimmerItem()
                                        } else {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(route1 ? Color("Redlight") : Light ? .white : Color("Darkcloud"))
                                                    .frame(width: 160, height: 120)
                                                
                                                VStack (spacing: 10) {
                                                    HStack (spacing: 2){
                                                        Image(systemName: "flag.fill")
                                                            .foregroundStyle(route1 ? .white : Color("Redlight"))
                                                        Text("Today")
                                                            .font(.system(size: 20, design: .rounded)).bold()
                                                            .foregroundStyle(route1 ? .white : Light ? .black : .white)
                                                    }
                                                    .font(.title3)
                                                    .frame(maxWidth: 140, alignment: .leading)
                                                    VStack (spacing: 3){
                                                        ForEach(TodayItems.prefix(2)) { item in
                                                            AllItem(item: item)
                                                        }
                                                    }
                                                    
                                                }
                                                .frame(maxHeight: 100, alignment: .top)
                   
                                                
                                                if TodayItems.count > 2 {
                                                    Text("+\(TodayItems.count - 2)")
                                                        .font(.system(size: 20, design: .rounded)).bold()
                                                        .foregroundStyle(.gray)
                                                        .offset(x: 55, y: -38)
                                                }
                                            }
                                            .onTapGesture {
                                                withAnimation {route1 = true}
                                                withAnimation {route2 = false}
                                                withAnimation {route3 = false}
                                                withAnimation {route4 = false}
                                                route5 = false
                                                route6 = false
                                                setNavbarTitleColor(color: Color("Redlight"))
                                            }
                                        }
                                        
// Pinned iPad
                                        if viewModel1.isLoading {
                                            CardShimmerItem()
                                        } else {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(route2 ? Color("Pureorange") : Light ? .white : Color("Darkcloud"))
                                                    .frame(width: 160, height: 120)
                                                    
                                                VStack (spacing: 10) {
                                                    HStack (spacing: 2){
                                                        Image(systemName: "pin.fill")
                                                            .foregroundStyle(route2 ? .white : Color("Pureorange"))
                                                        Text("Pinned")
                                                            .font(.system(size: 20, design: .rounded)).bold()
                                                            .foregroundStyle(route2 ? .white : Light ? .black : .white)
                                                    }
                                                    .font(.title3)
                                                    .frame(maxWidth: 140, alignment: .leading)
                                                    VStack (spacing: 3){
                                                        ForEach(PinnedItems.prefix(2)) { item in
                                                            PinnedItem(item: item)
                                                        }
                                                    }
                                                }
                                                .frame(maxHeight: 100, alignment: .top)
                                                
                                                if PinnedItems.count > 2 {
                                                    Text("+\(PinnedItems.count - 2)")
                                                        .font(.system(size: 20, design: .rounded)).bold()
                                                        .foregroundStyle(.gray)
                                                        .offset(x: 55, y: -38)
                                                }
                                            }
                                            .onTapGesture {
                                                withAnimation {route1 = false}
                                                withAnimation {route2 = true}
                                                withAnimation {route3 = false}
                                                withAnimation {route4 = false}
                                                route5 = false
                                                route6 = false
                                                setNavbarTitleColor(color: Color("Pureorange"))
                                            }
                                        }
                                    }
               
                                    HStack (spacing: 15){
// All iPad
                                        if viewModel1.isLoading {
                                            CardShimmerItem()
                                        } else {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(route3 ? Light ? .black : .white : Light ? .white : Color("Darkcloud"))
                                                    .frame(width: 160, height: 120)
                                                    
                                                VStack (spacing: 5) {
                                                    HStack (spacing: 2){
                                                        Image(systemName: "tray.fill")
                                                        Text("All")
                                                            .font(.system(size: 20, design: .rounded)).bold()
                                                    }
                                                    .foregroundStyle(route3 ? Light ? .white : .black : Light ? .black : .white)
                                                    .font(.title3)
                                                    .frame(maxWidth: 140, alignment: .leading)
                                                    Text(String(items.count))
                                                        .foregroundStyle(route3 ? Light ? .white : .black : Light ? .black : .white)
                                                        .font(.system(size: 60, design: .rounded))
                                                        .bold()
                                                        .frame(maxWidth: 130, alignment: .leading)
                                                }
                                                .frame(maxHeight: 100, alignment: .top)
                                            }
                                            .onTapGesture {
                                                withAnimation {route1 = false}
                                                withAnimation {route2 = false}
                                                withAnimation {route3 = true}
                                                withAnimation {route4 = false}
                                                route5 = false
                                                route6 = false
                                                setNavbarTitleColor(color: Color.primary)
                                            }
                                        }
                                        
// Completed iPad
                                        if viewModel1.isLoading {
                                            CardShimmerItem()
                                        } else {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(route4 ? Color("Slime") : Light ? .white : Color("Darkcloud"))
                                                    .frame(width: 160, height: 120)
                                                    
                                                VStack (spacing: 5) {
                                                    HStack (spacing: 2){
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundStyle(route4 ? .white : Color("Slime"))
                                                        Text("Completed")
                                                            .font(.system(size: 20, design: .rounded)).bold()
                                                            .foregroundStyle(route4 ? .white : Light ? .black : .white)
                                                    }
                                                    .font(.title3)
                                                    .frame(maxWidth: 140, alignment: .leading)
                                                    Text(String(items1.count))
                                                        .foregroundStyle(route4 ? .white : Light ? .black : .white)
                                                        .font(.system(size: 60, design: .rounded))
                                                        .bold()
                                                        .frame(maxWidth: 130, alignment: .leading)
                                                    
                                                }
                                                .frame(maxHeight: 100, alignment: .top)
                                            }
                                            .onTapGesture {
                                                withAnimation {route1 = false}
                                                withAnimation {route2 = false}
                                                withAnimation {route3 = false}
                                                withAnimation {route4 = true}
                                                route5 = false
                                                route6 = false
                                                setNavbarTitleColor(color: Color("Slime"))
                                            }
                                        }
                                    }


                                    HStack (spacing: 15){
// Shared iPad
                                        if viewModel1.isLoading {
                                            EmptyView()
                                        } else {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(.clear)
                                                    .frame(width: 160, height: 50, alignment: .top)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .stroke(route5 ? .white : .clear, lineWidth: 4)
                                                            .transaction { transaction in
                                                                transaction.animation = nil
                                                            }
                                                    )
                                                    
                                                VStack (spacing: 10) {
                                                    HStack (spacing: 2){
                                                        Image(systemName: "person.2.fill")
                                                            .foregroundStyle(Color("Darkblue"))
                                                        Text("Shared")
                                                            .font(.system(size: 20, design: .rounded)).bold()
                                                            .foregroundStyle(Light ? .black : .white)
                                                    }
                                                    .font(.title3)
                                                    .frame(maxWidth: 140, alignment: .center)
                                                }
                                            }
                                            .onTapGesture {
                                                withAnimation {route1 = false}
                                                withAnimation {route2 = false}
                                                withAnimation {route3 = false}
                                                withAnimation {route4 = false}
                                                route5 = true
                                                route6 = false
                                                setNavbarTitleColor(color: Color("Darkblue"))
                                            }
                                        }
                                        
// Deleted iPad
                                        if viewModel1.isLoading {
                                            EmptyView()
                                        } else {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(.clear)
                                                    .frame(width: 160, height: 50)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .stroke(route6 ? .white : .clear, lineWidth: 4)
                                                            .transaction { transaction in
                                                                transaction.animation = nil
                                                            }
                                                    )
                                                    
                                                VStack (spacing: 10) {
                                                    HStack (spacing: 2){
                                                        Image(systemName: "trash.fill")
                                                            .foregroundStyle(Color("Darkblue"))
                                                        Text("Deleted")
                                                            .font(.system(size: 20, design: .rounded)).bold()
                                                            .foregroundStyle(Light ? .black : .white)
                                                    }
                                                    .font(.title3)
                                                    .frame(maxWidth: 140, alignment: .center)
                                                }
                                            }
                                            .onTapGesture {
                                                withAnimation {route1 = false}
                                                withAnimation {route2 = false}
                                                withAnimation {route3 = false}
                                                withAnimation {route4 = false}
                                                route5 = false
                                                route6 = true
                                                setNavbarTitleColor(color: Color("Darkblue"))
                                            }
                                        }
                                    }
                                   
                                }
                                .scaleEffect(0.85)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .frame(maxWidth: .infinity, alignment: .center)
                            
// Coming iPad
                            
                            if viewModel1.isLoading {
                                Section {
                                    HStack (spacing: 15) {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .scaleEffect(1.5)
                                        Text("Loading Lists...")
                                            .font(.system(size: 25, design: .rounded))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 5)
                                        
                               } header: {
                                   Text("Coming")
                                       .textCase(nil)
                                       .font(.system(size: 40, design: .rounded)).bold()
                                       .foregroundStyle(Light ? .black : .white)
                                       .frame(maxWidth: .infinity, alignment: .leading)
                               }
                               .scrollDisabled(true)
                            } else {
                                Section {
                                    ForEach(ComingItems.prefix(5)) { item in
                                        ComingItem(item : item)
                                            .swipeActions {
                                                Button (role: .destructive) {
                                                    viewModel4.delete(id: item.id)
                                                } label: {
                                                    Image(systemName: "trash")
                                                }
                                                .tint(.red)
                                            }
                                            .swipeActions(edge: .leading) {
                                                Button {
                                                    viewModel3.toggleIsPinned(item: item)
                                                } label: {
                                                    if !item.isPinned {
                                                        Image(systemName: "pin")
                                                    } else {
                                                        Image(systemName: "pin.slash")
                                                    }
                                                }
                                                .tint(.orange)
                                            }
                                    }
                               } header: {
                                   Text("Coming")
                                       .textCase(nil)
                                       .font(.system(size: 40, design: .rounded)).bold()
                                       .foregroundStyle(Light ? .black : .white)
                                       .frame(maxWidth: .infinity, alignment: .leading)
                               }
                               .scrollDisabled(true)
                            }
                        }.scrollContentBackground(.hidden)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack (spacing: 2) {
                                Image("checkmarkapp").resizable().scaledToFit().scaleEffect(0.8)
                                Text("Checked").font(.system(size: 30, design: .rounded)).bold()
                            }
                            .transaction { transaction in
                                transaction.animation = nil
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                route1 = false
                                route2 = false
                                route3 = false
                                route4 = false
                                route5 = false
                                route6 = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { routeSettings = true }
                                setNavbarTitleColor(color: Color.primary)
                                showWelcomeText = false
                            } label: {
                                Image(systemName: "gearshape")
                                    .foregroundStyle(Color("Darkblue"))
                            }
                            .navigationDestination(isPresented: $routeSettings, destination: {
                                SettingsView()
                                    .onDisappear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { withAnimation {route1 = true} }
                                        routeSettings = false
                                        setNavbarTitleColor(color: Color("Redlight"))
                                    }
                            })
                        }
                    }
                }
                .navigationDestination(isPresented: $route1) { TodayView(userID: viewModel.currentUserID, newItem: $newItem) }
                .navigationDestination(isPresented: $route2) { PinnedView(userID: viewModel.currentUserID, newItem: $newItem) }
                .navigationDestination(isPresented: $route3) { AllView(userID: viewModel.currentUserID, newItem: $newItem) }
                .navigationDestination(isPresented: $route4) { CompletedView(userID: viewModel.currentUserID) }
                .navigationDestination(isPresented: $route5) { SharedView(userID: viewModel.currentUserID) }
                .navigationDestination(isPresented: $route6) { DeletedView(userID: viewModel.currentUserID) }
            } detail: {
                ZStack {
                    (routeSettings ? Light ? Color("Cloud") : Color("Deepcloud") : Light ? .white : Color("Deepcloud")).ignoresSafeArea()
                    
                    if showWelcomeText {
                        Text("Welcome")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 35, design: .rounded))
                            .padding(.horizontal, 70)
                            .font(.system(size: 50))
                            .foregroundColor(Color(.secondaryLabel))
                    } else {
                        if routeSettings {
                            Text("Settings")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 35, design: .rounded))
                                .padding(.horizontal, 70)
                                .font(.system(size: 50))
                                .foregroundColor(Color(.secondaryLabel))
                        }
                    }
                }
            }
        } else {
            
// iPhone
            NavigationStack {
                List {
                    Section {
                        VStack (spacing: 15) {
                            
                            HStack (spacing: 15){
// Today iPhone
                                if viewModel1.isLoading {
                                    CardShimmerItem()
                                } else {
                                    Button {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                            route1 = true
                                            route2 = false
                                            route3 = false
                                            route4 = false
                                            route5 = false
                                            route6 = false
                                        }
                                        setNavbarTitleColor(color: Color("Redlight"))
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Light ? .white : Color("Deepcloud"))
                                                .frame(width: 160, height: 120)
                                                
                                            VStack (spacing: 10) {
                                                HStack (spacing: 2){
                                                    Image(systemName: "flag.fill")
                                                        .foregroundStyle(Color("Redlight"))
                                                    Text("Today")
                                                        .font(.system(size: 20, design: .rounded)).bold()
                                                        .foregroundStyle(Light ? .black : .white)
                                                }
                                                .font(.title3)
                                                .frame(maxWidth: 140, alignment: .leading)
                                                VStack (spacing: 3){
                                                    ForEach(TodayItems.prefix(2)) { item in
                                                        AllItem(item: item)
                                                    }
                                                }
                                            }
                                            .frame(maxHeight: 100, alignment: .top)
                                            .navigationDestination(isPresented: $route1, destination: {
                                                TodayView(userID: viewModel.currentUserID, newItem: $newItem)
                                            })
                                            
                                            if TodayItems.count > 2 {
                                                Text("+\(TodayItems.count - 2)")
                                                    .font(.system(size: 20, design: .rounded)).bold()
                                                    .foregroundStyle(.gray)
                                                    .offset(x: 55, y: -38)
                                            }
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
// Pinned iPhone
                                if viewModel1.isLoading {
                                    CardShimmerItem()
                                } else {
                                    Button {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                            route1 = false
                                            route2 = true
                                            route3 = false
                                            route4 = false
                                            route5 = false
                                            route6 = false
                                        }
                                        setNavbarTitleColor(color: Color("Pureorange"))
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Light ? .white : Color("Deepcloud"))
                                                .frame(width: 160, height: 120)
                                                
                                            VStack (spacing: 10) {
                                                HStack (spacing: 2){
                                                    Image(systemName: "pin.fill")
                                                        .foregroundStyle(Color("Pureorange"))
                                                    Text("Pinned")
                                                        .font(.system(size: 20, design: .rounded)).bold()
                                                        .foregroundStyle(Light ? .black : .white)
                                                }
                                                .font(.title3)
                                                .frame(maxWidth: 140, alignment: .leading)
                                                VStack (spacing: 3){
                                                    ForEach(PinnedItems.prefix(2)) { item in
                                                        PinnedItem(item: item)
                                                    }
                                                }
                                            }
                                            .frame(maxHeight: 100, alignment: .top)
                                            .navigationDestination(isPresented: $route2, destination: {
                                                PinnedView(userID: viewModel.currentUserID, newItem: $newItem)
                                            })
                                            
                                            if PinnedItems.count > 2 {
                                                Text("+\(PinnedItems.count - 2)")
                                                    .font(.system(size: 20, design: .rounded)).bold()
                                                    .foregroundStyle(.gray)
                                                    .offset(x: 55, y: -38)
                                            }
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
       
                            HStack (spacing: 15){
// All iPhone
                                if viewModel1.isLoading {
                                    CardShimmerItem()
                                } else {
                                    Button {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                            route1 = false
                                            route2 = false
                                            route3 = true
                                            route4 = false
                                            route5 = false
                                            route6 = false
                                        }
                                        setNavbarTitleColor(color: Color.primary)
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Light ? .white : Color("Deepcloud"))
                                                .frame(width: 160, height: 120)
                                                
                                            VStack (spacing: 5) {
                                                HStack (spacing: 2){
                                                    Image(systemName: "tray.fill")
                                                        .foregroundStyle(Light ? .black : .white)
                                                    Text("All")
                                                        .font(.system(size: 20, design: .rounded)).bold()
                                                        .foregroundStyle(Light ? .black : .white)
                                                }
                                                .font(.title3)
                                                .frame(maxWidth: 140, alignment: .leading)
                                                Text(String(items.count))
                                                    .foregroundStyle(Light ? .black : .white)
                                                    .font(.system(size: 60, design: .rounded))
                                                    .bold()
                                                    .frame(maxWidth: 130, alignment: .leading)
                                            }
                                            .frame(maxHeight: 100, alignment: .top)
                                            .navigationDestination(isPresented: $route3, destination: {
                                                AllView(userID: viewModel.currentUserID, newItem: $newItem)
                                            })
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
// Completed iPhone
                                if viewModel1.isLoading {
                                    CardShimmerItem()
                                } else {
                                    Button {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                            route1 = false
                                            route2 = false
                                            route3 = false
                                            route4 = true
                                            route5 = false
                                            route6 = false
                                        }
                                        setNavbarTitleColor(color: Color("Slime"))
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Light ? .white : Color("Deepcloud"))
                                                .frame(width: 160, height: 120)
                                                
                                            VStack (spacing: 5) {
                                                HStack (spacing: 2){
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundStyle(Color("Slime"))
                                                    Text("Completed")
                                                        .font(.system(size: 20, design: .rounded)).bold()
                                                        .foregroundStyle(Light ? .black : .white)
                                                }
                                                .font(.title3)
                                                .frame(maxWidth: 140, alignment: .leading)
                                                Text(String(items1.count))
                                                    .foregroundStyle(Light ? .black : .white)
                                                    .font(.system(size: 60, design: .rounded))
                                                    .bold()
                                                    .frame(maxWidth: 130, alignment: .leading)
                                                
                                            }
                                            .frame(maxHeight: 100, alignment: .top)
                                            .navigationDestination(isPresented: $route4, destination: {
                                                CompletedView(userID: viewModel.currentUserID)
                                            })
                                        }
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            HStack (spacing: 15){
// Shared iPhone
                                if viewModel1.isLoading {
                                    EmptyView()
                                } else {
                                    Button {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                            route1 = false
                                            route2 = false
                                            route3 = false
                                            route4 = false
                                            route5 = true
                                            route6 = false
                                        }
                                        setNavbarTitleColor(color: Color("Darkblue"))
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(.clear)
                                                .frame(width: 160, height: 50, alignment: .top)
                                                
                                            VStack (spacing: 10) {
                                                HStack (spacing: 2){
                                                    Image(systemName: "person.2.fill")
                                                        .foregroundStyle(Color("Darkblue"))
                                                    Text("Shared")
                                                        .font(.system(size: 20, design: .rounded)).bold()
                                                        .foregroundStyle(Light ? .black : .white)
                                                }
                                                .font(.title3)
                                                .frame(maxWidth: 140, alignment: .center)
                                            }
                                         
                                            .navigationDestination(isPresented: $route5, destination: {
                                                SharedView(userID: viewModel.currentUserID)
                                            })
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
// Deleted iPhone
                                if viewModel1.isLoading {
                                    EmptyView()
                                } else {
                                    Button {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                            route1 = false
                                            route2 = false
                                            route3 = false
                                            route4 = false
                                            route5 = false
                                            route6 = true
                                        }
                                        setNavbarTitleColor(color: Color("Darkblue"))
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(.clear)
                                                .frame(width: 160, height: 50)
                                                
                                            VStack (spacing: 10) {
                                                HStack (spacing: 2){
                                                    Image(systemName: "trash.fill")
                                                        .foregroundStyle(Color("Darkblue"))
                                                    Text("Deleted")
                                                        .font(.system(size: 20, design: .rounded)).bold()
                                                        .foregroundStyle(Light ? .black : .white)
                                                }
                                                .font(.title3)
                                                .frame(maxWidth: 140, alignment: .center)
                                            }
                                            .navigationDestination(isPresented: $route6, destination: {
                                                DeletedView(userID: viewModel.currentUserID)
                                            })
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .listRowBackground(Light ? Color("Cloud") : .black)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                  
// Coming iPhone
                    if viewModel1.isLoading {
                        Section {
                            HStack (spacing: 15) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.5)
                                Text("Loading Lists...")
                                    .font(.system(size: 25, design: .rounded))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                           
                                
                       } header: {
                           Text("Coming")
                               .textCase(nil)
                               .font(.system(size: 40, design: .rounded)).bold()
                               .foregroundStyle(Light ? .black : .white)
                               .frame(maxWidth: .infinity, alignment: .leading)
                               .offset(x: -10)
                       }
                       .listRowBackground(Light ? Color("Cloud") : .black)
                       .scrollDisabled(true)
                       .padding(-5)
                    } else {
                         Section {
                             ForEach(ComingItems.prefix(5)) { item in
                                 ComingItem(item : item)
                                     .swipeActions {
                                         Button (role: .destructive) {
                                             viewModel4.delete(id: item.id)
                                         } label: {
                                             Image(systemName: "trash")
                                         }
                                         .tint(.red)
                                     }
                                     .swipeActions(edge: .leading) {
                                         Button {
                                             viewModel3.toggleIsPinned(item: item)
                                         } label: {
                                             if !item.isPinned {
                                                 Image(systemName: "pin")
                                             } else {
                                                 Image(systemName: "pin.slash")
                                             }
                                         }
                                         .tint(.orange)
                                     }
                             }
                        } header: {
                            Text("Coming")
                                .textCase(nil)
                                .font(.system(size: 40, design: .rounded)).bold()
                                .foregroundStyle(Light ? .black : .white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(x: -10)
                        }
                        .scrollDisabled(true)
                        .padding(-5)
                    }
                }
                .padding(.horizontal, 10)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack (spacing: 2) {
                            Image("checkmarkapp").resizable().scaledToFit().scaleEffect(0.8)
                            Text("Checked").font(.system(size: 35, design: .rounded)).bold()
                        }
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                        .padding(.leading)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { routeSettings = true }
                            setNavbarTitleColor(color: Color.primary)
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(Color("Darkblue"))
                        }
                        .navigationDestination(isPresented: $routeSettings, destination: {
                            SettingsView()
                        })
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            isSheetPresented = true
                        } label: {
                            HStack (spacing: 5) {
                                Image(systemName: "plus.app.fill")
                                Text("New event")
                            }
                        }
                        .foregroundStyle(Color("Darkblue"))
                        .font(.system(size: 20, design: .rounded)).bold()
                    }
                }
                .background(Light ? Color("Cloud") : .black)
                .sheet(isPresented: $isSheetPresented) {
                    NewItemView(newItemPresent: $isSheetPresented)
                        .presentationDetents([.large])
                        .tint(Color("Darkblue"))
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userID: "NXykqOWQI5Y6bXlWAivAPWATHJi2")
    }
}
