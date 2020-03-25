//
//  AccountCreation.swift
//  FirebaseChatApp
//
//  Created by Антон Ларченко on 24.02.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import SwiftUI

struct AccountCreation: View {
    
    @Binding var show: Bool
    @State var name = ""
    @State var about = ""
    @State var picker = false
    @State var loading = false
    @State var imageData: Data = .init(count: 0)
    @State var alert = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            Text("Create an account").font(.title)
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    
                    self.picker.toggle()
                    
                }) {
                    if self.imageData.count == 0 {
                        Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 90, height: 70).foregroundColor(.gray)
                    } else {
                        
                        Image(uiImage: UIImage(data: self.imageData)!).resizable().renderingMode(.original).frame(width: 90, height: 90).clipShape(Circle())
                    }
                    
                    
                }
                
                Spacer()
            }
            .padding(.vertical, 15)
            
            Text("Enter user name")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            TextField("Name", text: self.$name)
                .keyboardType(.numberPad)
                .padding()
                .background(Color("Color"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 15)
            
            Text("About You")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            TextField("About", text: self.$about)
                .keyboardType(.numberPad)
                .padding()
                .background(Color("Color"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 15)
            
            if self.loading {
                
                HStack {
                    Spacer()
                    Indicator()
                    Spacer()
                }
            } else {
                Button(action: {
                    
                    if self.name != "" && self.about != "" && self.imageData.count != 0 {
                        
                        self.loading.toggle()
                        createUser(name: self.name, about: self.about, imagedata: self.imageData) { (status) in
                            
                            if status {
                                
                                self.show.toggle()
                            }
                        }
                    } else {
                        self.alert.toggle()
                    }
                }) {
                    Text("Create").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    
                }.foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: self.$picker, content: {
            
            ImagePicker(picker: self.$picker, imagedata: self.$imageData)
        })
            .alert(isPresented: self.$alert) {
                
                Alert(title: Text("Message"), message: Text("Please Fill The Contents"), dismissButton: .default(Text("Ok")))
        }
    }
}
