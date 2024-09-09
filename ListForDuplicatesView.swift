//
//  ListForDuplicatesView.swift
//  Contacts Manager
//
//  Created by Viraj Singh on 6/25/21.
//

import SwiftUI
import Contacts

struct ListForDuplicatesView: View {
    let duplicatesArray : [[CNContact]]
    let duplicateParameter : String
    @State private var selectedArray = [String:String]()
    @Binding var showSelf: Bool
    @State private var mergeArray = [Int:[CNContact]]()
    var body: some View {
        List {
            ForEach(0..<duplicatesArray.count,id: \.self) { sectIndex in
                Section(header: Text("\(duplicatesArray[sectIndex].first?.givenName ?? "")").foregroundColor(Color(UIColor(named: "blueBase")!)))
                {
                    ForEach(0..<duplicatesArray[sectIndex].count,id: \.self) { dupIndex in
                        let dupContact = duplicatesArray[sectIndex][dupIndex]
                        
                        
                        Button(action: {
                            if selectedArray["\(sectIndex):\(dupIndex)"] == "True" {
                                selectedArray.updateValue("False", forKey: "\(sectIndex):\(dupIndex)")
                                let newMergeArray = mergeArray[sectIndex]!.filter { $0 != dupContact }
                                mergeArray.updateValue(newMergeArray, forKey: sectIndex)
                            } else {
                                selectedArray.updateValue("True", forKey: "\(sectIndex):\(dupIndex)")
                                if mergeArray[sectIndex] != nil {
                                    var currMergeArray = (mergeArray[sectIndex]!) as Array
                                    currMergeArray.append(dupContact)
                                    mergeArray.updateValue(currMergeArray, forKey: sectIndex)
                                    
                                } else {
                                    mergeArray.updateValue([dupContact], forKey: sectIndex)
                                    
                                }
                            }
                            
                        }, label: {
                            HStack{
                                if selectedArray["\(sectIndex):\(dupIndex)"] == "True" {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 20, height: 20)
                                        
                                } else {
                                    Circle()
                                        .stroke()
                                        .frame(width: 20, height: 20)
                                }
                                
                                
                                Text("\(dupContact.givenName)")
                                    .bold()
                                    .font(.title2)
                            }
                        })
                            
                        
                        
                        
                        
                        if dupContact.familyName != "" {
                            Text("Last Name: \(dupContact.familyName)")
                                .font(.headline)
                                .padding(.leading,30)
                        }
                        
                        ForEach(0..<dupContact.phoneNumbers.count,id: \.self) { number in
                            let phoneNum = dupContact.phoneNumbers[number]
                            Text("Phone Number: \(phoneNum.value.stringValue)")
                                .font(.headline)
                                .padding(.leading,30)
                        }
                         ForEach(0..<dupContact.emailAddresses.count,id: \.self) { address in
                            let emailAdd = dupContact.emailAddresses[0]
                            Text("Email Address: \(emailAdd.value)")
                                 .font(.headline)
                                 .padding(.leading,30)

                         }
                        
 
 
 
 
 
 
                        
                    }
                    
                    
                }
                
                
                

            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    UsefulValues.myGlobal += 1
                    print("\(UsefulValues.myGlobal)!")
                    mergeDuplicates(mergeArray: mergeArray)
                    self.showSelf = false
                }, label: {
                    Text("Merge")
                })
                
            }
        }
        .navigationBarTitle(duplicateParameter)
//        .onAppear() {
//            UsefulValues.myGlobal += 1
//            print("\(UsefulValues.myGlobal)!")
//            if UsefulValues.myGlobal % 3 == 0 {
//                GADMobileAds.sharedInstance().start(completionHandler: nil)
//                self.interstitial.showAd()
//            }
//        }
    }
    
    struct ItemRow: View {
        let category: Bool
        let text: String

        init(_ text: String, isCategory: Bool = false) {
            self.category = isCategory
            self.text = text
        }

        var body: some View {
            HStack {
                Circle().stroke()
                    .frame(width: 20, height: 20)
                    
                if category {
                    Text(self.text)
                        .bold()
                        .font(.title2)
                } else {
                    Text(self.text)
                }
            }
        }
    }
    
}
func mergeDuplicates(mergeArray: [Int:[CNContact]]) {
    for (_,value) in mergeArray {
        var mergeGivenName = String()
        var mergeFamilyName = String()
        var mergePhoneNumbers = [CNLabeledValue<CNPhoneNumber>]()
        var mergeEmailAddresses = [CNLabeledValue<NSString>]()
        var mergePostalAddresses = [CNLabeledValue<CNPostalAddress>]()
        var mergeBirthday: DateComponents?
        for contact in value{
            if contact.givenName.count > mergeGivenName.count {
                mergeGivenName = contact.givenName
            }
            if contact.familyName.count > mergeFamilyName.count {
                mergeFamilyName = contact.familyName
            }
            for phoneNumber in contact.phoneNumbers {
                var stringPhoneArray = [String]()
                for value in mergePhoneNumbers {
                    stringPhoneArray.append(value.value.stringValue)
                }
                if !stringPhoneArray.contains(phoneNumber.value.stringValue) {
                    mergePhoneNumbers.append(phoneNumber)
                }
            }
            for emailAddress in contact.emailAddresses {
                var stringEmailArray = [String]()
                for value in mergeEmailAddresses {
                    stringEmailArray.append(value.value as String)
                }
                if !stringEmailArray.contains(emailAddress.value as String) {
                    mergeEmailAddresses.append(emailAddress)
                }
            }
            for postalAddress in contact.postalAddresses {
                if !mergePostalAddresses.contains(postalAddress) {
                    mergePostalAddresses.append(postalAddress)
                }
            }
            if mergeBirthday == nil && contact.birthday != nil{
                mergeBirthday = contact.birthday!
            }
            let deletingContact = contact
            let store = CNContactStore()
            let req = CNSaveRequest()
            let mutableContact = deletingContact.mutableCopy() as! CNMutableContact
            req.delete(mutableContact)

            do{
              try store.execute(req)
              print("Success, You deleted the user")
            } catch _{
                
              
            }
        }
        let newContact = CNMutableContact()
        newContact.givenName = mergeGivenName
        newContact.familyName = mergeFamilyName
        newContact.phoneNumbers = mergePhoneNumbers
        newContact.emailAddresses = mergeEmailAddresses
        newContact.postalAddresses = mergePostalAddresses
        newContact.birthday = mergeBirthday
        do {
            let contactStore = CNContactStore()
            let saveReq = CNSaveRequest()
            saveReq.add(newContact,toContainerWithIdentifier: nil)
            try contactStore.execute(saveReq)
        } catch {
            
        }
    }
}

/*
struct ListForDuplicatesView_Previews: PreviewProvider {
    static var previews: some View {
        ListForDuplicatesView()
    }
}
*/
