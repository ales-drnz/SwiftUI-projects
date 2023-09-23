//
//  LogInView.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import SwiftUI

struct LogInView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @StateObject var viewModel1 = RegisterViewViewModel()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @FocusState private var focusedField: FieldLogin?
    @FocusState private var focusedField1: FieldRegister?
    @State private var showPassword = false
    @State private var register = false
    
    enum FieldLogin {
        case email
        case password
    }
    
    enum FieldRegister {
        case name
        case email
        case password
    }
    
    var body: some View {
        let Light = colorScheme == .light
        
        NavigationStack {
            ZStack {
                Light ? Image("LoginLight") : Image("LoginDark")
                ScrollView {
                    if !register {
                        VStack(spacing: 200) {
                            VStack {
                                HStack (spacing: 0) {
                                    Image("checkmarkapp").resizable().frame(width: 55, height: 50)
                                    Text("Checked").font(.system(size: 50, design: .rounded)).bold()
                                }
                                Text("Get things done")
                                    .offset(y: -6)
                            }.offset(y: 150)
                            
                            VStack (spacing: 10){
                                // Email
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 295, height: 55)
                                        .blur(radius: 5)
                                        .foregroundStyle(.black.opacity(0.1))
                                        .offset(y: 7)
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(Light ? .white : Color("Darkcloud"))
                                        .frame(width: 300, height: 50)
                                    
                                    HStack {
                                        Image(systemName: "person.fill")
                                        TextField("Email", text: $viewModel.email)
                                            .autocapitalization(.none)
                                            .focused($focusedField, equals: .email)
                                            .submitLabel(.next)
                                            
                                        Spacer()
                                        
                                    }.padding(.leading, 25)
                                }
                                
                                // Password
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 295, height: 55)
                                        .blur(radius: 5)
                                        .foregroundStyle(.black.opacity(0.1))
                                        .offset(y: 7)
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(Light ? .white : Color("Darkcloud"))
                                        .frame(width: 300, height: 50)
                                    
                                    HStack {
                                        Image(systemName: "lock.fill")
                                        
                                        if !showPassword {
                                            SecureField("Password", text: $viewModel.password)
                                                .autocapitalization(.none)
                                                .focused($focusedField, equals: .password)
                                        } else {
                                            TextField("Password", text: $viewModel.password)
                                                .autocapitalization(.none)
                                                .focused($focusedField, equals: .password)
                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            showPassword.toggle()
                                        } label: {
                                            Image(systemName: showPassword ? "eye.fill" : "eye")
                                                .foregroundStyle(.gray)
                                        }
                                    }.padding(.horizontal, 25)
                                }
                                
                                Button {
                                    // Forgot password
                                } label: {
                                    Text("Forgot your password?")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(maxWidth: 280, alignment: .trailing)
                                .offset(y: 10)
                                
                                // Sign in
                                Button {
                                    viewModel.login()
                                } label: {
                                    HStack {
                                        Text("Sign in")
                                            .font(.system(size: 30, design: .rounded)).bold()
                                            .foregroundStyle(Light ? .black : .white)
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 50, height: 55)
                                                .blur(radius: 5)
                                                .foregroundStyle(.black.opacity(0.1))
                                                .offset(y: 5)
                                            
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 50, height: 40)
                                                .foregroundStyle(LinearGradient(colors: [Color("Darkblue"), Color("Violet")], startPoint: .bottom, endPoint: .top))
                                            
                                            Image(systemName: "arrow.forward")
                                                .font(.title)
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }.frame(maxWidth: 300, alignment: .trailing).offset(y: 50)
                            }
                            .frame(width: 330)
                            .onSubmit {
                                switch focusedField {
                                case .email:
                                    focusedField = .password
                                case .password:
                                    focusedField = .none
                                case .none:
                                    print("Didn't enter info")
                                }
                            }
                            
                            HStack{
                                Text("Don't have an account?")
                                Button {
                                    withAnimation {register = true}
                                } label: {
                                    Text("Create").underline().bold()
                                        .foregroundStyle(Light ? .black : .white)
                                }
                            }
                        }
                        .offset(y: 65)
                    } else {
                        VStack(spacing: 200) {
                            VStack {
                                Button {
                                    withAnimation {register = false}
                                } label: {
                                    Image(systemName: "arrow.backward")
                                        .font(.title).bold()
                                        .foregroundStyle(Light ? .black : .white)
                                }
                                .frame(maxWidth: 295, alignment: .leading)
                                .offset(y: -90)
                                
                                HStack (spacing: 0) {
                                    Text("Start organising").font(.system(size: 30, design: .rounded))
                                }
                            }.offset(y: 150)
                            
                            VStack (spacing: 10) {
                                // Name
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 295, height: 55)
                                        .blur(radius: 5)
                                        .foregroundStyle(.black.opacity(0.1))
                                        .offset(y: 7)
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(Light ? .white : Color("Darkcloud"))
                                        .frame(width: 300, height: 50)
                                    
                                    HStack {
                                        Image(systemName: "person.fill")
                                        TextField("Full name", text: $viewModel1.name)
                                            .autocapitalization(.none)
                                            .focused($focusedField1, equals: .name)
                                            .submitLabel(.next)
                                            
                                        Spacer()
                                        
                                    }.padding(.leading, 25)
                                }
                                
                                // Email
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 295, height: 55)
                                        .blur(radius: 5)
                                        .foregroundStyle(.black.opacity(0.1))
                                        .offset(y: 7)
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(Light ? .white : Color("Darkcloud"))
                                        .frame(width: 300, height: 50)
                                    
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                            .font(.system(size: 14))
                                        TextField("Email", text: $viewModel1.email)
                                            .autocapitalization(.none)
                                            .focused($focusedField1, equals: .email)
                                            .submitLabel(.next)
                                            
                                        Spacer()
                                        
                                    }.padding(.leading, 25)
                                }
                                
                                // Password
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 295, height: 55)
                                        .blur(radius: 5)
                                        .foregroundStyle(.black.opacity(0.1))
                                        .offset(y: 7)
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(Light ? .white : Color("Darkcloud"))
                                        .frame(width: 300, height: 50)
                                    
                                    HStack {
                                        Image(systemName: "lock.fill")
                                        
                                        if !showPassword {
                                            SecureField("Password", text: $viewModel1.password)
                                                .autocapitalization(.none)
                                                .focused($focusedField1, equals: .password)
                                        } else {
                                            TextField("Password", text: $viewModel1.password)
                                                .autocapitalization(.none)
                                                .focused($focusedField1, equals: .password)
                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            showPassword.toggle()
                                        } label: {
                                            Image(systemName: showPassword ? "eye.fill" : "eye")
                                                .foregroundStyle(.gray)
                                        }
                                    }.padding(.horizontal, 25)
                                }
                                
                                // Create
                                Button {
                                    viewModel1.register()
                                } label: {
                                    HStack {
                                        Text("Create")
                                            .font(.system(size: 30, design: .rounded)).bold()
                                            .foregroundStyle(Light ? .black : .white)
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 50, height: 55)
                                                .blur(radius: 5)
                                                .foregroundStyle(.black.opacity(0.1))
                                                .offset(y: 5)
                                            
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 50, height: 40)
                                                .foregroundStyle(LinearGradient(colors: [Color("Darkblue"), Color("Violet")], startPoint: .bottom, endPoint: .top))
                                            
                                            Image(systemName: "arrow.forward")
                                                .font(.title)
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }.frame(maxWidth: 300, alignment: .trailing).offset(y: 50)
                            }
                            .frame(width: 330)
                            .onSubmit {
                                switch focusedField1 {
                                case .name:
                                    focusedField1 = .email
                                case .email:
                                    focusedField1 = .password
                                case .password:
                                    focusedField1 = .none
                                case .none:
                                    print("Didn't enter info")
                                }
                            }
                            Spacer().frame(height: 0)
                        }
                        .offset(y: 65)
                    }
                }
                .ignoresSafeArea(.keyboard)
            } 
            .ignoresSafeArea()
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}



