//
//  ChatRow.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import SwiftUI

struct ChatRow: View {
    
    let text: String
    let type: messageType
    
    @EnvironmentObject var model : AppStateModel
    var isSender : Bool {
        return type == .sent
    }
    
    init(text: String ,type:messageType)
    {
        self.text = text
        self.type = type
    }
    var body: some View {
        
        HStack{
            if isSender {Spacer()}
            
            if !isSender
            {
                VStack{
                    Spacer()
                    Image(model.otherUserName == "Zwel" ? "photo1" : "photo2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .foregroundColor(Color.red)
                        .clipShape(Circle())
                }
            }
            HStack{
                Text(text)
                .foregroundColor(isSender ? Color.white : Color(.label))
                .padding()
            }
            .background(isSender ? Color.blue : Color(.systemGray4))
            .padding(isSender ? .leading : .trailing ,
                     isSender ? UIScreen.main.bounds.width/3 : UIScreen.main.bounds.width/5)
            .cornerRadius(6)
            if !isSender {Spacer()}
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatRow(text:"Hello",type : .sent)
            ChatRow(text:"Hello",type : .received)
        }
        
    }
}
