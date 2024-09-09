//
//  ListForDuplicatesView3.swift
//  Contacts Manager
//
//  Created by Viraj Singh on 7/12/21.
//

import SwiftUI
import Contacts

struct ListForDuplicatesView3: View {
    let duplicatesArray : [[CNContact]]
    let duplicateParameter : String
    @State private var selectedArray = [String:String]()
    @Binding var showSelf: Bool
    @State private var mergeArray = [Int:[CNContact]]()
    var body: some View {
        List {
            ForEach(0..<duplicatesArray.count,id: \.self) { sectIndex in
                Section(header: Text("\(duplicatesArray[sectIndex].first?.phoneNumbers.first?.value.stringValue ?? "")").foregroundColor(Color(UIColor(named: "blueBase")!)))
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
                                        .onTapGesture {
                                            
                                        }
                                } else {
                                    Circle()
                                        .stroke()
                                        .frame(width: 20, height: 20)
                                        .onTapGesture {
                                            
                                            
                                            
                                        }
                                }
                                
                                
                                Text("\(dupContact.phoneNumbers.first?.value.stringValue ?? "")")
                                    .bold()
                                    .font(.title2)
                            }
                        })
                        
                        if dupContact.givenName != "" {
                            Text("First Name: \(dupContact.givenName)")
                                .font(.headline)
                                .padding(.leading,30)
                        }
                        if dupContact.familyName != "" {
                            Text("Last Name: \(dupContact.familyName)")
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
//        .navigationBarTitle(duplicateParameter)
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
