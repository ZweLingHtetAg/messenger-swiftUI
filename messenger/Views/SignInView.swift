//
//  SignInView.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import SwiftUI

struct SignInView: View {
    @State var userName: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var model: AppStateModel
    
    var body: some View {
        
        NavigationView{
            VStack{
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                Text("Messenger")
                    .bold()
                    .font(.system(size: 34))
                
                VStack{
                    TextField("User Name", text: $userName)
                        .modifier(CustomField())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("Pssword", text: $password)
                        .modifier(CustomField())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Button(action: {
                        self.signIn()
                    }, label: {
                        Text("Sign In")
                            .foregroundColor(Color.white)
                            .frame(width: 220, height: 50)
                            .background(Color.blue)
                            .cornerRadius(5)
                        
                    })
                }
                .padding()
                
                Spacer()
                
                HStack{
                    Text("New to messenger ?")
                    NavigationLink("Create Account", destination: SignUpView())
                }.padding()
            }
        }
        
    }
    
    func signIn(){
        guard !userName.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
               password.count >= 6 else{
                return
        }
        
        model.signIn(userName: userName, password: password)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
