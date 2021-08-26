//
//  SignUpView.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import SwiftUI

struct SignUpView: View {
    @State var userName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var model: AppStateModel
    
    var body: some View {
        
            VStack{
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                
                VStack{
                    TextField("Email Address", text: $email)
                        .modifier(CustomField())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("User Name", text: $userName)
                        .modifier(CustomField())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("Pssword", text: $password)
                        .modifier(CustomField())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Button(action: {
                        self.signUp()
                    }, label: {
                        Text("Sign Up")
                            .foregroundColor(Color.white)
                            .frame(width: 220, height: 50)
                            .background(Color.green)
                            .cornerRadius(5)
                        
                    })
                }
                .padding()
                
                Spacer()
                
            }
            .navigationBarTitle("Create Account",displayMode: .inline)
        
    }
    
    func signUp(){
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !userName.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
               password.count >= 6 else{
                return
        }
        
        model.signUp(email: email, userName: userName, password: password)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
