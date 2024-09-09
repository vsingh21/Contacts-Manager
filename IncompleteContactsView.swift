//
//  IncompleteContactsView.swift
//  Contacts Manager
//
//  Created by Viraj Singh on 6/21/21.
//

import SwiftUI
import Contacts

struct IncompleteContactsView: View {
    @State var searchText = ""
    @State var isSearching = false
    @State var incompleteArray : [CNContact]
    var incompleteParameter: String
    
        
    var body: some View {
    
        List {
            SearchBarView(searchText: $searchText, isSearching: $isSearching)
            ForEach((0..<incompleteArray.count).filter({ "\(incompleteArray[$0].givenName) \(incompleteArray[$0].familyName)".contains(searchText) || "\(incompleteArray[$0].phoneNumbers.first?.value.stringValue ?? "")".contains(searchText) || searchText.isEmpty }), id: \.self) { item in
                
                NavigationLink(
                    destination: ContactDetailView(contact: incompleteArray[item])) {
                    
                    ContactRowView(contact: incompleteArray[item])
                        .padding(.vertical, 4)
                }
                
                
            }
            .onDelete(perform: delete)

        }
        .foregroundColor(Color(UIColor(named: "blueBase")!))
        .toolbar {
            EditButton()
                
        }
        .navigationBarTitle(incompleteParameter)
            
        
    }
    func delete(at offsets: IndexSet) {
        let indexOfDeletedItem = Int(offsets.indices.startIndex.description.split(separator: "x")[1].split(separator: "i")[0].split(separator: " ")[0]) ?? 0
        let deletingContact = incompleteArray[indexOfDeletedItem]
        let store = CNContactStore()
        let req = CNSaveRequest()
        let mutableContact = deletingContact.mutableCopy() as! CNMutableContact
        req.delete(mutableContact)

        do{
          try store.execute(req)
          print("Success, You deleted the user")
        } catch let e{
          print("Error = \(e)")
        }
        let contacts = fetchAllContacts().sorted(by: {
        
            if $0.givenName == "" && $0.familyName == ""{
                print($0.familyName)
                return false
            } else if $1.givenName == "" && $1.familyName == "" {
                return true
            }
            return $0.givenName+$0.familyName < $1.givenName+$1.familyName
            
        })
        incompleteArray = findIncompleteContacts(contactsArray: contacts, parameter: incompleteParameter)
    }
    
}

func findIncompleteContacts(contactsArray: [CNContact],parameter: String) -> [CNContact] {
    var incompletesArray = [CNContact]()
    for contact in contactsArray {
        if parameter == "Missing Name" {
            if contact.givenName == "" && contact.familyName == "" {
                incompletesArray.append(contact)
            }
        } else if parameter == "Missing Phone Number" {
            if contact.phoneNumbers.count == 0 {
                incompletesArray.append(contact)
            }
        } else if parameter == "Missing Email Address" {
            if contact.emailAddresses.count == 0 {
                incompletesArray.append(contact)
            }
        }
    
        
    }
    return incompletesArray
}
/*
struct IncompleteContactsView_Previews: PreviewProvider {
    static var previews: some View {
        IncompleteContactsView(incompleteParameter: "phone", incompleteArray: <#[CNContact]#>)
    }
}*/
