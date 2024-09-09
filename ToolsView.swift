//
//  ToolsView.swift
//  Contacts Manager
//
//  Created by Viraj Singh on 6/20/21.
//

import SwiftUI
import Contacts
import ContactsUI
import UniformTypeIdentifiers
import UIKit

struct ToolsView: View {
    @State private var fileContentForvCard = Data()
    @State private var fileContentForCSV = Data()
    @State private var showDocumentPickerForvCard = false
    @State private var showDocumentPickerForCSV = false
    @State private var showShareSheetForvCard = false
    @State private var showShareSheetForCSV = false
    @State var showingDuplicatesView4 = false
    @State var showingDuplicatesView = false
    @State var showingDuplicatesView2 = false
    @State var showingDuplicatesView3 = false
   
    @State private var showingAlert = false
    @State var contacts = fetchAllContacts().sorted(by: {
    
        if $0.givenName == "" && $0.familyName == ""{
            print($0.familyName)
            return false
        } else if $1.givenName == "" && $1.familyName == "" {
            return true
        }
        return $0.givenName+$0.familyName < $1.givenName+$1.familyName
        
    })
    
    init() {
        
    }
    
    var body: some View {
        
        NavigationView {
            
            List {
                Section(header: Text("Import/Export").foregroundColor(Color(UIColor(named: "blueBase")!))) {
                   
                    Button(action: {
                        showDocumentPickerForvCard = true
                    }, label: {
                        ToolsRowView(systemImageName: "square.and.arrow.down", rowName: "Import vCard")
                    })
                    .sheet(isPresented: self.$showDocumentPickerForvCard) {
                        DocumentPickerForvCard(fileContent: $fileContentForvCard)
                    }
                    .onChange(of: showDocumentPickerForvCard, perform: { value in
                        if !showDocumentPickerForvCard {
                            UsefulValues.myGlobal += 1
                            print("\(UsefulValues.myGlobal)!")
                            if UsefulValues.myGlobal % 3 == 0 {
                                print("Change")
                            }
                            
                        }
                        
                    })
                    Button(action: {
                        showDocumentPickerForCSV = true
                    }, label: {
                        ToolsRowView(systemImageName: "square.and.arrow.down", rowName: "Import CSV")
                    })
                    .sheet(isPresented: self.$showDocumentPickerForCSV) {
                        DocumentPickerForCSV(fileContent: $fileContentForCSV)
                    }
                    .onChange(of: showDocumentPickerForCSV, perform: { value in
                        if !showDocumentPickerForCSV {
                            UsefulValues.myGlobal += 1
                            print("\(UsefulValues.myGlobal)!")
                            if UsefulValues.myGlobal % 3 == 0 {
                                print("Change")
                            }
                        }
                    })
                    
                    Button(action: {
                        showShareSheetForvCard = true
                        let arrayContacts = fetchAllContactsForvCard()
                        shareContacts(contacts: arrayContacts)
                    }, label: {
                        ToolsRowView(systemImageName: "square.and.arrow.up", rowName: "Export as vCard")
                    })
                    Button(action: {
                        showShareSheetForCSV = true
                        let arrayContacts = fetchAllContactsForCSV()
                        generateCSVFile(contacts: arrayContacts)
                    }, label: {
                        ToolsRowView(systemImageName: "square.and.arrow.up", rowName: "Export as CSV")
                    })
                    
                        
                }
                
                
                Section(header: Text("Duplicates").foregroundColor(Color(UIColor(named: "blueBase")!))) {
                    let duplicateContactsExactArray = findDuplicates(contactsArray: contacts, parameter: "Exact Duplicates")
                    if duplicateContactsExactArray.count != 0 {
                        NavigationLink(
                            destination: ListForDuplicatesView4(duplicatesArray: duplicateContactsExactArray, duplicateParameter: "Exact Duplicates", showSelf: $showingDuplicatesView4), isActive: $showingDuplicatesView4) {
                            
                            ToolsRowView(systemImageName: "equal.square", rowName: "Exact Duplicates",numberOfListItems: duplicateContactsExactArray.count)
                                
                                
                                
                        }
                        
                    } else {
                        ToolsRowView(systemImageName: "equal.square", rowName: "Exact Duplicates",numberOfListItems: duplicateContactsExactArray.count)
                           
                    }
                    let duplicateContactsFirstNameArray = findDuplicates(contactsArray: contacts, parameter: "Same First Name")
                    if duplicateContactsFirstNameArray.count != 0 {
                        NavigationLink(
                            destination: ListForDuplicatesView(duplicatesArray: duplicateContactsFirstNameArray, duplicateParameter: "Same First Name", showSelf: $showingDuplicatesView), isActive: $showingDuplicatesView) {
                            
                            ToolsRowView(systemImageName: "equal.square", rowName: "Same First Name",numberOfListItems: duplicateContactsFirstNameArray.count)
                                
                                
                                
                        }
                        
                    } else {
                        ToolsRowView(systemImageName: "equal.square", rowName: "Same First Name",numberOfListItems: duplicateContactsFirstNameArray.count)
                          
                    }
                    let duplicateContactsFullNameArray = findDuplicates(contactsArray: contacts, parameter: "Same Full Name")
                    if duplicateContactsFullNameArray.count != 0 {
                        NavigationLink(
                            destination: ListForDuplicatesView2(duplicatesArray: duplicateContactsFullNameArray, duplicateParameter: "Same Full Name", showSelf: $showingDuplicatesView2), isActive: $showingDuplicatesView2) {
                            
                            ToolsRowView(systemImageName: "equal.square", rowName: "Same Full Name",numberOfListItems: duplicateContactsFullNameArray.count)
                                
                                
                                
                        }
                    } else {
                        ToolsRowView(systemImageName: "equal.square", rowName: "Same Full Name",numberOfListItems: duplicateContactsFullNameArray.count)
                           
                    }
                    let duplicateContactsPhoneArray = findDuplicates(contactsArray: contacts, parameter: "Same Phone Number")
                    if duplicateContactsPhoneArray.count != 0 {
                        NavigationLink(
                            destination: ListForDuplicatesView3(duplicatesArray: duplicateContactsPhoneArray, duplicateParameter: "Same Phone Number", showSelf: $showingDuplicatesView3), isActive: $showingDuplicatesView3) {
                            
                            ToolsRowView(systemImageName: "equal.square", rowName: "Same Phone Number",numberOfListItems: duplicateContactsPhoneArray.count)
                                
                                
                                
                        }
                        
                    } else {
                        ToolsRowView(systemImageName: "equal.square", rowName: "Same Phone Number",numberOfListItems: duplicateContactsPhoneArray.count)
                            
                    }
                }
                
                Section(header: Text("Incomplete Contacts").foregroundColor(Color(UIColor(named: "blueBase")!))) {
                    let incompleteContactsNameArray = findIncompleteContacts(contactsArray: contacts, parameter: "Missing Name")
                    if incompleteContactsNameArray.count != 0 {
                        NavigationLink(
                            destination: IncompleteContactsView(incompleteArray: incompleteContactsNameArray, incompleteParameter: "Missing Name")) {
                            
                            ToolsRowView(systemImageName: "person.crop.circle.badge.xmark", rowName: "Missing Name",numberOfListItems: incompleteContactsNameArray.count)
                                
                                
                        }
                        
                    } else {
                        ToolsRowView(systemImageName: "person.crop.circle.badge.xmark", rowName: "Missing Name",numberOfListItems: incompleteContactsNameArray.count)
                    }
                    let incompleteContactsPhoneArray = findIncompleteContacts(contactsArray: contacts, parameter: "Missing Phone Number")
                    if incompleteContactsPhoneArray.count != 0 {
                        NavigationLink(
                            destination: IncompleteContactsView(incompleteArray: incompleteContactsPhoneArray, incompleteParameter: "Missing Phone Number")) {
                            
                            ToolsRowView(systemImageName: "person.crop.circle.badge.xmark", rowName: "Missing Phone Number",numberOfListItems: incompleteContactsPhoneArray.count)
                        }
                    } else {
                        ToolsRowView(systemImageName: "person.crop.circle.badge.xmark", rowName: "Missing Phone Number",numberOfListItems: incompleteContactsPhoneArray.count)
                    }
                    let incompleteContactsEmailArray = findIncompleteContacts(contactsArray: contacts, parameter: "Missing Email Address")
                    if incompleteContactsEmailArray.count != 0 {
                        NavigationLink(
                            destination: IncompleteContactsView(incompleteArray: incompleteContactsEmailArray, incompleteParameter: "Missing Email Address")) {
                            
                            ToolsRowView(systemImageName: "person.crop.circle.badge.xmark", rowName: "Missing Email Address",numberOfListItems: incompleteContactsEmailArray.count)
                        }
                    } else {
                        ToolsRowView(systemImageName: "person.crop.circle.badge.xmark", rowName: "Missing Email Address",numberOfListItems: incompleteContactsEmailArray.count)
                    }
                    
                    
                        
                }
                
                
                
            }
            .navigationTitle("Tools")
            .onAppear(perform: {contacts = fetchAllContacts().sorted(by: {
                
                if $0.givenName == "" && $0.familyName == ""{
                    print($0.familyName)
                    return false
                } else if $1.givenName == "" && $1.familyName == "" {
                    return true
                }
                return $0.givenName+$0.familyName < $1.givenName+$1.familyName
                
                
            })})
            .onAppear() {
                print("appeared")
                if UsefulValues.myGlobal % 3 == 0 {
                  
                }
            }
        
                
            
            
            
            
            
        }
        
        
        
    }

    func generateCSVFile(contacts : [CNContact]) {
        let fileName = "MyContacts.csv"
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let fileURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName)
        let output = OutputStream.toMemory()
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        csvWriter?.writeField("IDENTIFIER")
        csvWriter?.writeField("PREFIX")
        csvWriter?.writeField("GIVEN_NAME")
        csvWriter?.writeField("PHONETIC_GIVEN_NAME")
        csvWriter?.writeField("MIDDLE_NAME")
        csvWriter?.writeField("PHONETIC_MIDDLE_NAME")
        csvWriter?.writeField("FAMILY_NAME")
        csvWriter?.writeField("PHONETIC_FAMILY_NAME")
        csvWriter?.writeField("SUFFIX")
        csvWriter?.writeField("NICKNAME")
        csvWriter?.writeField("JOB_TITLE")
        csvWriter?.writeField("DEPARTMENT_NAME")
        csvWriter?.writeField("ORGANIZATION_NAME")
        csvWriter?.writeField("PHONETIC_ORGANIZATION_NAME")
        csvWriter?.writeField("PHONE_NUMBERS")
        csvWriter?.writeField("EMAIL_ADDRESSES")
        csvWriter?.writeField("URL_ADDRESSES")
        csvWriter?.writeField("POSTAL_ADDRESSES")
        csvWriter?.writeField("BIRTHDAY")
        csvWriter?.writeField("DATES")
        
        
        csvWriter?.finishLine()
        
        var arrayOfContactsData = [[Any]]()
        for contact in contacts {
            var contactArray = [Any]()
            contactArray.append(contact.identifier)
            
            contactArray.append(contact.namePrefix)
            
            contactArray.append(contact.givenName)
            
            contactArray.append(contact.phoneticGivenName)
            
            contactArray.append(contact.middleName)
            
            contactArray.append(contact.phoneticMiddleName)
            
            contactArray.append(contact.familyName)
            
            contactArray.append(contact.phoneticFamilyName)
            
            contactArray.append(contact.nameSuffix)
            
            contactArray.append(contact.nickname)
            
            contactArray.append(contact.jobTitle)
            
            contactArray.append(contact.departmentName)
            
            contactArray.append(contact.organizationName)
            
            contactArray.append(contact.phoneticOrganizationName)
            
            var phoneNumberArray = [String]()
            for phoneNumber in contact.phoneNumbers {
                
                let stringPhoneNumber = phoneNumber.value.stringValue
                
                var phoneLabel = phoneNumber.label
                if phoneLabel != nil {
                    if phoneLabel!.count >= 8 {
                        phoneLabel?.removeFirst(4)
                        phoneLabel?.removeLast(4)
                    }
                }
                
                
                phoneNumberArray.append("\(phoneLabel ?? " "):\(stringPhoneNumber)")
                
            }
            contactArray.append(phoneNumberArray.joined(separator: "|"))
            
            var emailAddressesArray = [String]()
            for emailAddress in contact.emailAddresses {
                
                let stringEmailAddress = emailAddress.value as String
                var emailLabel = emailAddress.label
                if (emailLabel != nil && emailLabel!.count > 8) {
                    emailLabel?.removeFirst(4)
                    emailLabel?.removeLast(4)
                }
                emailAddressesArray.append("\(emailLabel ?? "email"):\(stringEmailAddress)")
            }
            contactArray.append(emailAddressesArray.joined(separator: "|"))
            
            var urlAddressesArray = [String]()
            for urlAddress in contact.urlAddresses {
                
                let stringUrlAddress = urlAddress.value as String
                var urlLabel = urlAddress.label
                urlLabel?.removeFirst(4)
                urlLabel?.removeLast(4)
                urlAddressesArray.append("\(urlLabel ?? " "):\(stringUrlAddress)")
            }
            contactArray.append(urlAddressesArray.joined(separator: "|"))
            
            var postalAddressesArray = [String]()
            for postalAddress in contact.postalAddresses {
                let attributedString = CNPostalAddressFormatter.attributedString(from: postalAddress.value,style: CNPostalAddressFormatterStyle.mailingAddress)
                var postalLabel = postalAddress.label
                postalLabel?.removeFirst(4)
                postalLabel?.removeLast(4)
                 
                postalAddressesArray.append("\(postalLabel ?? " "):\(attributedString)")
            }
            contactArray.append(postalAddressesArray.joined(separator: "|"))

            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            formatter.dateFormat = "MM/dd/yyyy"
            if contact.birthday?.date != nil {
                contactArray.append(formatter.string(from: contact.birthday?.date! ?? Date()))
            } else {
                contactArray.append("")
            }
            
            
            
            var datesArray = [String]()
            for date in contact.dates {
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                formatter.dateFormat = "MM/dd/yyyy"
                let stringDate = formatter.string(from: date.value.date ?? Date())
                var dateLabel = date.label
                dateLabel?.removeFirst(4)
                dateLabel?.removeLast(4)
                datesArray.append(dateLabel!+":"+stringDate)
                
            }
            contactArray.append(datesArray.joined(separator: "|"))
            
            arrayOfContactsData.append(contactArray)
        }
        for elements in arrayOfContactsData.enumerated() {
            for contactProperty in 0..<20 {
                csvWriter?.writeField(elements.element[contactProperty])
                
            }
            csvWriter?.finishLine()

            
        }
        csvWriter?.closeStream()
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        do {
            try buffer.write(to: fileURL)
            let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

            UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: {showShareSheetForCSV = false})
        } catch {}
        
    }
    func shareContacts(contacts : [CNContact]) {
        
        
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let fileURL = URL.init(fileURLWithPath: documentsPath.appending("/MyContacts.vcf"))
                
            let data : NSData?
            do {
                    
                try data = CNContactVCardSerialization.data(with: contacts) as NSData
                    
                do {
                    try data?.write(to: fileURL, options: .atomic)
                    print(fileURL.absoluteString)
                    let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

                    UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: {showShareSheetForvCard = false})
                }
                catch {
                        
                    print("Failed to write!")
                }
            }
            catch {
                    
                print("Failed!")
            }
                   
    }
    func fetchAllContactsForvCard() -> [CNContact] {
            
        var contacts : [CNContact] = []
        
        let contactStore = CNContactStore()
        let fetchReq = CNContactFetchRequest.init(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
            
        do {
            try contactStore.enumerateContacts(with: fetchReq) { (contact, end) in
                
            contacts.append(contact)
        }} catch  {
            
            print("Failed to fetch")
        }
        
        return contacts
    }
    func fetchAllContactsForCSV() -> [CNContact] {
            
        var contacts : [CNContact] = []
        
        let contactStore = CNContactStore()
        let keysToFetch = [CNContactViewController.descriptorForRequiredKeys()] as [CNKeyDescriptor]
        let fetchReq = CNContactFetchRequest.init(keysToFetch: keysToFetch)
            
        do {
            try contactStore.enumerateContacts(with: fetchReq) { (contact, end) in
                
            contacts.append(contact)
        }} catch  {
            
            print("Failed to fetch")
        }
        
        return contacts
    }
}
struct Contact {
    let contact: CNContact
    var firstName = String()
    var fullName = String()
    var phoneNumber = String()
    var contactArray = String()
}
func findDuplicates(contactsArray: [CNContact],parameter: String) -> [[CNContact]]{
    var duplicatesArray = [[CNContact]]()
    var parameterArray = [Contact]()
    for contact in contactsArray {
        if parameter == "Same First Name" {
            if "\(contact.givenName)" != "" && contact.givenName != " " {
                parameterArray.append(Contact(contact: contact,firstName: contact.givenName.lowercased()))
            }
            
        } else if parameter == "Same Full Name" {
            if (contact.givenName + contact.familyName).lowercased() != "" && (contact.givenName + contact.familyName).lowercased() != " " {
                parameterArray.append(Contact(contact: contact,fullName: (contact.givenName + contact.familyName).lowercased()))
            }
        } else if parameter == "Same Phone Number"  {
            if contact.phoneNumbers.first?.value.stringValue != nil {
                parameterArray.append(Contact(contact: contact,phoneNumber: (contact.phoneNumbers.first?.value.stringValue) ?? ""))
            }
            
        } else if parameter == "Exact Duplicates"  {
            if (contact.givenName + contact.familyName).lowercased() != "" && (contact.givenName + contact.familyName).lowercased() != " " {
                var phoneNumsString = ""
                for phoneNum in contact.phoneNumbers {
                    phoneNumsString += phoneNum.value.stringValue
                }
                var emailsString = ""
                for email in contact.emailAddresses {
                    emailsString += (email.value) as String
                }
                parameterArray.append(Contact(contact: contact,contactArray: "\(contact.givenName.lowercased())\(contact.familyName.lowercased())\(phoneNumsString)\(emailsString)"))
            }
            
        }
    }
    
    if parameter == "Same First Name" {
        let crossReference = Dictionary(grouping: parameterArray, by: \.firstName)
        
        let duplicates = crossReference
            .filter { $1.count > 1 }
            .sorted { $0.1.count > $1.1.count }
        
        for duplicate in duplicates {
            var singleArray = [CNContact]()
            for x in duplicate.value {
                singleArray.append(x.contact)
            }
            duplicatesArray.append(singleArray)
            
        }
        
    } else if parameter == "Same Full Name" {
        let crossReference = Dictionary(grouping: parameterArray, by: \.fullName)

        let duplicates = crossReference
            .filter { $1.count > 1 }
            .sorted { $0.1.count > $1.1.count }
        for duplicate in duplicates {
            var singleArray = [CNContact]()
            for x in duplicate.value {
                singleArray.append(x.contact)
            }
            duplicatesArray.append(singleArray)
            
        }
    } else if parameter == "Same Phone Number" {
        let crossReference = Dictionary(grouping: parameterArray, by: \.phoneNumber)

        let duplicates = crossReference
            .filter { $1.count > 1 }
            .sorted { $0.1.count > $1.1.count }
        for duplicate in duplicates {
            var singleArray = [CNContact]()
            for x in duplicate.value {
                singleArray.append(x.contact)
            }
            duplicatesArray.append(singleArray)
            
        }
    } else if parameter == "Exact Duplicates" {
        let crossReference = Dictionary(grouping: parameterArray, by: \.contactArray)

        let duplicates = crossReference
            .filter { $1.count > 1 }
            .sorted { $0.1.count > $1.1.count }
        for duplicate in duplicates {
            var singleArray = [CNContact]()
            for x in duplicate.value {
                singleArray.append(x.contact)
            }
            duplicatesArray.append(singleArray)
            
        }
    }
    return duplicatesArray
}
struct DocumentPickerForvCard: UIViewControllerRepresentable {
    @Binding var fileContent: Data
    func makeCoordinator() -> DocumentPickerCoordinatorForvCard {
        return DocumentPickerCoordinatorForvCard(fileContent: $fileContent)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPickerForvCard>) -> UIDocumentPickerViewController {
        let controller: UIDocumentPickerViewController
        
        if #available(iOS 14, *) {
            let supportedTypes: [UTType] = [UTType.vCard]
            controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        } else {
            controller = UIDocumentPickerViewController(documentTypes: ["vCard"], in: .import)
        }
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPickerForvCard>) {}
    
    
}

class DocumentPickerCoordinatorForvCard: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    @Binding var fileContent: Data
    
    init(fileContent: Binding<Data>) {
        _fileContent = fileContent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileURL = urls[0]
        do {
            fileContent = try Data(contentsOf: fileURL as URL)
        } catch let error {
            print(error.localizedDescription)
        }
        var contacts = [CNContact()]

        do {
            contacts = try CNContactVCardSerialization.contacts(with: fileContent)
        } catch let error {
            print(error.localizedDescription)
        }
        
        for contact in contacts {
            do {
                let saveReq = CNSaveRequest()
                let contactStore = CNContactStore()
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                saveReq.add(mutableContact, toContainerWithIdentifier: nil)
                try contactStore.execute(saveReq)
            } catch {
                
            }
            
              
            
        }
    }
}

struct DocumentPickerForCSV: UIViewControllerRepresentable {
    @Binding var fileContent: Data
    func makeCoordinator() -> DocumentPickerCoordinatorForCSV {
        return DocumentPickerCoordinatorForCSV(fileContent: $fileContent)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPickerForCSV>) -> UIDocumentPickerViewController {
        let controller: UIDocumentPickerViewController
        
        if #available(iOS 14, *) {
            let supportedTypes: [UTType] = [UTType.data]
            controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        } else {
            controller = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        }
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPickerForCSV>) {}
    
    
}

class DocumentPickerCoordinatorForCSV: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    @Binding var fileContent: Data
    
    init(fileContent: Binding<Data>) {
        _fileContent = fileContent
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileURL = urls[0]
        let rows = NSArray(contentsOfCSVURL: fileURL, options: CHCSVParserOptions.sanitizesFields)!
        let objCArray = NSMutableArray(array: rows)
        
        for row in objCArray {
            let rowString = "\(row)"
            var cleanRowString = rowString.components(separatedBy: ["\n","\""]).joined()
            cleanRowString = cleanRowString.replacingOccurrences(of: "    ", with: " ", options: NSString.CompareOptions.literal, range: nil)
            cleanRowString = cleanRowString.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
            cleanRowString = cleanRowString.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            print(cleanRowString)
            let rowArray = cleanRowString.split(separator: ",")
            print(rowArray)
            let newContact = CNMutableContact()
            if String(String(rowArray[1]).dropFirst()) != "PREFIX" {
                newContact.namePrefix = String(String(rowArray[1]).dropFirst())
                newContact.givenName = String(String(rowArray[2]).dropFirst())
                newContact.phoneticGivenName = String(String(rowArray[3]).dropFirst())
                newContact.middleName = String(String(rowArray[4]).dropFirst())
                newContact.phoneticMiddleName = String(String(rowArray[5]).dropFirst())
                newContact.familyName = String(String(rowArray[6]).dropFirst())
                newContact.phoneticFamilyName = String(String(rowArray[7]).dropFirst())
                newContact.nameSuffix = String(String(rowArray[8]).dropFirst())
                newContact.nickname = String(String(rowArray[9]).dropFirst())
                newContact.jobTitle = String(String(rowArray[10]).dropFirst())
                newContact.departmentName = String(String(rowArray[11]).dropFirst())
                newContact.organizationName = String(String(rowArray[12]).dropFirst())
                newContact.phoneticOrganizationName = String(String(rowArray[13]).dropFirst())
            }
            
            if String(String(rowArray[14]).dropFirst()) != "" && String(String(rowArray[14]).dropFirst()) != "PHONE_NUMBERS" {
                var phoneNumbersArray = [CNLabeledValue<CNPhoneNumber>]()
                
                let phoneNumbersDictsStrings = String(String(rowArray[14]).dropFirst()).split(separator: "|")
                for phoneNumberDictString in phoneNumbersDictsStrings {
                    let phoneNumberDict = phoneNumberDictString.split(separator: ":")
                    print(phoneNumberDict)
                    let phoneNum = CNPhoneNumber(stringValue: String(phoneNumberDict[1]))
                    let labeledValue = CNLabeledValue(label: String(phoneNumberDict[0]), value: phoneNum)
                    phoneNumbersArray.append(labeledValue)
                }
                newContact.phoneNumbers = phoneNumbersArray
            }
            if String(String(rowArray[15]).dropFirst()) != "" && String(String(rowArray[15]).dropFirst()) != "EMAIL_ADDRESSES" {
                var emailArray = [CNLabeledValue<NSString>]()
                
                let emailDictsStrings = String(String(rowArray[15]).dropFirst()).split(separator: "|")
                for emailDictString in emailDictsStrings {
                    let emailDict = emailDictString.split(separator: ":")
                    let labeledValue = CNLabeledValue(label: String(emailDict[0]), value: String(emailDict[1]) as NSString)
                    emailArray.append(labeledValue)
                }
                newContact.emailAddresses = emailArray
            }
            
            if String(String(rowArray[16]).dropFirst()) != "" && String(String(rowArray[16]).dropFirst()) != "URL_ADDRESSES" {
                var urlArray = [CNLabeledValue<NSString>]()
                
                let urlDictsStrings = String(String(rowArray[16]).dropFirst()).split(separator: "|")
                for urlDictString in urlDictsStrings {
                    let urlDict = urlDictString.split(separator: ":")
                    let labeledValue = CNLabeledValue(label: String(urlDict[0]), value: String(urlDict[1]) as NSString)
                    urlArray.append(labeledValue)
                }
                newContact.urlAddresses = urlArray
            }
            
            if String(String(rowArray[17]).dropFirst()) != "" && String(String(rowArray[17]).dropFirst()) != "POSTAL_ADDRESSES" {
                var postalArray = [CNLabeledValue<CNPostalAddress>]()
                
                let postalDictsStrings = String(String(rowArray[17]).dropFirst()).split(separator: "|")
                for postalDictString in postalDictsStrings {
                    let postalDict = postalDictString.split(separator: ":")
                    let postalString = String(postalDict[1])
                    var postalCompArray = postalString.components(separatedBy:"{\\n}")
                    for postalCompIndex in 0..<postalCompArray.count {
                        if let leftIdx = postalCompArray[postalCompIndex].firstIndex(of: "{"),
                           let rightIdx = postalCompArray[postalCompIndex].firstIndex(of: "}")
                        {
                            postalCompArray[postalCompIndex] = String(postalCompArray[postalCompIndex].prefix(upTo: leftIdx) + postalCompArray[postalCompIndex].suffix(from: postalCompArray[postalCompIndex].index(after: rightIdx)))
                            if postalCompArray[postalCompIndex].contains("\\n"){
                                postalCompArray[postalCompIndex] = postalCompArray[postalCompIndex].replacingOccurrences(of: "\\n", with: " ")
                            } else if postalCompArray[postalCompIndex].contains("\n"){
                                postalCompArray[postalCompIndex] = postalCompArray[postalCompIndex].replacingOccurrences(of: "\n", with: " ")
                            }
                            
                            
                        }
                    }
                    print(postalCompArray)
                    let mutableAddress = CNMutablePostalAddress()
                    mutableAddress.street = postalCompArray[0]
                    mutableAddress.city = postalCompArray[1]
                    mutableAddress.state = postalCompArray[2]
                    mutableAddress.postalCode = postalCompArray[3]
                    if postalCompArray.count == 5 {
                        mutableAddress.country = postalCompArray[4]
                    }
                    let labeledValue = CNLabeledValue(label: String(postalDict[0]), value: mutableAddress as CNPostalAddress)
                    postalArray.append(labeledValue)
                }
                newContact.postalAddresses = postalArray
            }
            
            
            if String(String(rowArray[18]).dropFirst()) != "" && String(String(rowArray[18]).dropFirst()) != "BIRTHDAY" {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                let birthdayDate = formatter.date(from: String(String(rowArray[18]).dropFirst()))!
                let comps = Calendar.current.dateComponents([.year, .month, .day], from: birthdayDate)
                newContact.birthday = comps
            }
            if String(String(rowArray[19]).dropFirst()) != "" && String(String(rowArray[19]).dropFirst()) != "DATES" {
                var datesArray = [CNLabeledValue<NSDateComponents>]()
                
                let datesDictsStrings = String(String(rowArray[19]).dropFirst()).split(separator: "|")
                for dateDictString in datesDictsStrings {
                    let dateDict = dateDictString.split(separator: ":")
                    var dateString = dateDict[1]
                    let formatter = DateFormatter()
                    var dateAsDate = Date()
                    var comps = DateComponents()
                    if dateString.contains("0001") {
                        formatter.dateFormat = "MM/dd"
                        dateString = dateString.dropLast(5)
                        dateAsDate = formatter.date(from: String(dateString))!
                        comps = Calendar.current.dateComponents([.month, .day], from: dateAsDate)
                    } else {
                        formatter.dateFormat = "MM/dd/yyyy"
                        dateAsDate = formatter.date(from: String(dateString))!
                        comps = Calendar.current.dateComponents([.year, .month, .day], from: dateAsDate)
                    }
                    
                    
                    let labeledValue = CNLabeledValue(label: String(dateDict[0]), value: comps as NSDateComponents)
                    datesArray.append(labeledValue)
                }
                newContact.dates = datesArray
            }
            if String(String(rowArray[1]).dropFirst()) != "PREFIX" {
                do {
                    let contactStore = CNContactStore()
                    let saveReq = CNSaveRequest()
                    print(newContact.givenName)
                    saveReq.add(newContact,toContainerWithIdentifier: nil)
                    try contactStore.execute(saveReq)
                } catch {
                    print("Contact not saved")
                }
            }
            
            
            
            
            
            
        }
        
        
    }
    
}


struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView()
    }
}
