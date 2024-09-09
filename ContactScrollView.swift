//
//  ContactScrollView.swift
//  Contacts Manager
//
//  Created by Viraj Singh on 6/17/21.
//

import SwiftUI
import Contacts
import ContactsUI
import UIKit

struct ContactScrollView: View {
    
    @State var searchText = ""
    @State var isSearching = false
    @State var showingContactDetailViewForNewContact = false
    @State var contacts = fetchAllContacts().sorted(by: {

        if $0.givenName == "" && $0.familyName == ""{
            print($0.familyName)
            return true
        }
        return $0.givenName+$0.familyName < $1.givenName+$1.familyName


    })
   
    
    
    var body: some View {
       NavigationView {
            
            
            List {
                
                SearchBarView(searchText: $searchText, isSearching: $isSearching)
                ForEach((0..<contacts.count).filter({ "\(contacts[$0].givenName) \(contacts[$0].familyName)".contains(searchText) || "\(contacts[$0].phoneNumbers.first?.value.stringValue ?? "")".contains(searchText) || searchText.isEmpty }), id: \.self) { item in
                    
                    NavigationLink(
                        destination: ContactDetailView(contact: contacts[item])) {
                        
                        ContactRowView(contact: contacts[item])
                            .padding(.vertical, 4)
                    }
                    
                    
                }
                .onDelete(perform: delete)
                
                
                    
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: ({showingContactDetailViewForNewContact.toggle()}), label: ({
                        Image(systemName: "plus")
                    }))
                    .sheet(isPresented: $showingContactDetailViewForNewContact, content: {
                        addContactViewController(contacts: $contacts)
                    })
                }
        
                
                    
                    
                    
                    
                
            }
            
            .navigationBarTitle("Contacts")
            .foregroundColor(Color(UIColor(named: "blueBase")!))
            .onAppear(perform: {contacts = fetchAllContacts().sorted(by: {

                if $0.givenName == "" && $0.familyName == ""{
                    print($0.familyName)
                    return false
                } else if $1.givenName == "" && $1.familyName == "" {
                    return true
                }
                return $0.givenName+$0.familyName < $1.givenName+$1.familyName


            })})
            
            
        }
        
        
        
        
    }
    
    func delete(at offsets: IndexSet) {
        let indexOfDeletedItem = Int(offsets.indices.startIndex.description.split(separator: "x")[1].split(separator: "i")[0].split(separator: " ")[0]) ?? 0
        let deletingContact = contacts[indexOfDeletedItem]
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
        contacts = fetchAllContacts().sorted(by: {
            if $0.givenName == "" && $0.familyName == ""{
                print($0.familyName)
                return false
            } else if $1.givenName == "" && $1.familyName == "" {
                return true
            }
            return $0.givenName+$0.familyName < $1.givenName+$1.familyName
        })
        
        
    }
    
    
    
}

struct addContactViewController: UIViewControllerRepresentable {
    @Binding var contacts: [CNContact]
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    func makeUIViewController(context: Context) -> UINavigationController {
        let contactController = CNContactViewController(forNewContact: CNContact())
        contactController.view.layoutIfNeeded()
        let navCon = UINavigationController()
        navCon.view.layoutIfNeeded()
        contactController.delegate = context.coordinator
        navCon.pushViewController(contactController, animated: true)
        return navCon
    }
    
    
    func updateUIViewController(_ contactViewController: UINavigationController, context: Context) {
        print("Update")
    }
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        contactsUpdate()
        
        
    }
    class Coordinator: NSObject, CNContactViewControllerDelegate, UINavigationControllerDelegate {
        
        func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
            viewController.dismiss(animated: true, completion: nil)
            print("disappear")
            
            
        }
    }
    
    func contactsUpdate() {
        contacts = fetchAllContacts().sorted(by: {
            
            if $0.givenName == "" && $0.familyName == ""{
                print($0.familyName)
                return false
            } else if $1.givenName == "" && $1.familyName == "" {
                return true
            }
            return $0.givenName+$0.familyName < $1.givenName+$1.familyName
            
            
        })
    }
}

func fetchAllContacts() -> [CNContact] {
    print("Trying to fetch contacts...")
    let store = CNContactStore()
    var contactsFetch : [CNContact] = []
    
    store.requestAccess(for: .contacts) { (granted, err) in
        if let err = err {
            print("Failed", err)
            return
        }
        
        if granted {
            print("access granted")
            let keys = [CNContactViewController.descriptorForRequiredKeys()] 
            let fetchReq = CNContactFetchRequest(keysToFetch: keys)
            do {
                try store.enumerateContacts(with: fetchReq, usingBlock: { (contact, end) in
                    contactsFetch.append(contact)
                })
            } catch {
                
            }
            
        }
        
    }
    return contactsFetch
}



struct ContactDetailView: UIViewControllerRepresentable {
    var contact: CNContact
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CNContactViewController {
        let contactController = CNContactViewController(for: contact)
        contactController.delegate = context.coordinator
        return contactController
    }
    
    func updateUIViewController(_ uiViewController: CNContactViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, CNContactViewControllerDelegate, UINavigationControllerDelegate {
        var parent: ContactDetailView
        
        init(_ parent: ContactDetailView) {
            self.parent = parent
        }
        
        func contactControllerDidCancel(_ picker: CNContactViewController) {
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
}



struct ContactScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ContactScrollView()
    }
}
