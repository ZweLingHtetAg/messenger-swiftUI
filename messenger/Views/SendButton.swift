//
//  SendButton.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import SwiftUI

struct SendButton: View {
    @Binding var text: String
    @EnvironmentObject var model : AppStateModel
    var body: some View {
        Button(
            action :{
                self.sendMessage()
            },
            label: {
                
                Image(systemName: "paperplane")
                    .resizable()
                    //.font(.system(size: 35))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.blue)
                    //.background(Color.blue)
                    //.clipShape(Circle())
            })
        }
    func sendMessage(){
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        model.sendMessage(text: text)
        text = ""
        
        
        
    }
}

//struct SendButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SendButton()
//    }
//}
