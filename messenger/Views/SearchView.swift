//
//  SearchView.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import SwiftUI



struct SearchView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var model:  AppStateModel
    @State var text: String = ""
    @State var usernames: [String] = []
    let completion : ((String)->Void)
    
    init (completion: @escaping ((String)-> Void)) {
        self.completion = completion
    }
    
    var body: some View {
        
        VStack{
            TextField("User Name ...",text: $text)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            Button("Search"){
                guard !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                    return
                }
                
                model.searchUser(queryText: text){ usernames in
                    self.usernames = usernames
                }
            }
            
                List{
                    ForEach(usernames,id: \.self){ name in
                        
                        HStack{
                            Image(model.otherUserName == "Zwel" ? "photo1" : "photo2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .foregroundColor(Color.red)
                                .clipShape(Circle())
                            Text(name)
                                .bold()
                                .foregroundColor(Color(.label))
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                            completion(name)
                        }
                        
                            
                    }
                }
                
            Spacer()
            }.navigationTitle("Search")
            
        }
        
    }


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView() { _ in }
    }
}
