//
//  ChatView.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import SwiftUI

struct CustomField: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(5)
    }
}

struct ChatView: View {
    
    
    @State var message: String = ""
    @EnvironmentObject var model: AppStateModel
    
    let otherUserName: String
    init(otherUserName: String){
        self.otherUserName = otherUserName
    }
    var body: some View {
        
        VStack
        {
            ScrollView(.vertical){
                
                ForEach(model.messages, id: \.self){ message in
                    ChatRow(
                            text: message.text,
                            type :message.type
                    ).padding(3)
                }
                
            }
            
            // Field and Send Button
            
            HStack{
                TextField("Message ...",text: $message)
                    .modifier(CustomField())
                
                SendButton(text: $message)
            }
            .padding()
        }
        
        .navigationBarTitle(otherUserName, displayMode: .inline)
        .onAppear()
        {
            model.otherUserName = otherUserName
            model.observeChat()
        }
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(otherUserName : "Zwel")
//    }
//}
