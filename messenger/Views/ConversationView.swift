//
//  ConversationView.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import SwiftUI

struct ConversationView: View {
    let usernames = ["Joe","Jone","Jenny"]
    @State var otherUserName: String = ""
    @State var showChat: Bool = false
    @State var showSearch: Bool = false
    
    @EnvironmentObject var model: AppStateModel
    var body: some View {
       
        NavigationView{
            ScrollView(.vertical)
            {
                ForEach(model.conversations,id: \.self) {
                    name in
                    NavigationLink(destination: ChatView(otherUserName: name),
                    label: {
                        HStack{
                            Image(model.otherUserName == "Zwel" ? "photo1" : "photo2")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.red)
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                            Text(name)
                                .bold()
                                .foregroundColor(Color(.label))
                                .font(.system(size: 20))
                            Spacer()
                            
                        }.padding()
                    })
                }
                
                if !otherUserName.isEmpty {
                    NavigationLink("",
                                   destination:ChatView(otherUserName: otherUserName),
                                   isActive: $showChat)
                }
            }
            .navigationTitle("Conversation")
            .toolbar{
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading){
                    Button("Sign Out"){
                        self.signOut()
                    }
                }

                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing){
                    
                    NavigationLink(
                        destination: SearchView { name in
                            
                            self.showSearch = false
                            DispatchQueue.main.asyncAfter(deadline: .now()+1)
                            {
                                self.showChat = true
                                self.otherUserName = name
                            }
                            
                    },
                        isActive: $showSearch,
                                   
                    label: {
                                    Image(systemName: "magnifyingglass")
                                })
                    
                }
                
                            }
            .fullScreenCover(isPresented: $model.showingSignIn, content: {
                SignInView()
            })
            .onAppear{
                guard model.auth.currentUser != nil else {
                    return
                }
                
                model.getConversation()
            }
            
        }
        
    }
    
    func signOut(){
        model.signOut()
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}
