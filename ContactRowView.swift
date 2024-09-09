//
//  ContactRowView.swift
//  Contacts Manager
//
//  Created by Viraj Singh on 6/17/21.
//

import SwiftUI
import Contacts



struct ContactRowView: View {
    var contact: CNContact
    
    var body: some View {
        
        HStack{
            if contact.imageDataAvailable{
                Image(uiImage: UIImage(data: contact.imageData!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(50)
                    
                    
                    
                    
            } else {
                if (contact.givenName != "" && contact.familyName != "") || (contact.givenName != "" && contact.familyName == "") || (contact.givenName == "" && contact.familyName != "") {
                    let firstInitial = contact.givenName.prefix(1)
                    let lastInitial = contact.familyName.prefix(1)
                    Text(firstInitial+lastInitial)
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 25, design: .rounded))
                        .background(Circle()
                                        .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color("SampleContactImageTop"), Color("SampleContactImageBottom")]), startPoint: .top, endPoint: .bottom))
                                        .frame(width: 60, height: 60))
                        .frame(width: 60, height: 60)
                } else {
                    
            
                }
                
            }
            
            VStack(alignment: .leading) {
                if contact.givenName == "" && contact.familyName == "" {
                    if contact.phoneNumbers.count == 0 {
                        if contact.emailAddresses.count != 0 {
                            Text(contact.emailAddresses.first!.value as String)
                                .font(.title2)
                                .bold()
                        } else {
                            Text("")
                                .font(.title2)
                                .bold()
                        }
                        
                    } else {
                        Text(contact.phoneNumbers.first?.value.stringValue ?? "")
                            .font(.title2)
                            .bold()
                    }
                    
                } else {
                    Text(contact.givenName + " " + contact.familyName)
                        .font(.title2)
                        .bold()
                        
                    Text(contact.phoneNumbers.first?.value.stringValue ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                    
            }
            
        
        }
        
    }
}
/*
struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContactRowView()
    }
    
    
    
}*/
