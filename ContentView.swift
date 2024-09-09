//
//  ContentView.swift
//  Contacts Manager
//
//  Created by Viraj Singh on 6/17/21.
//

import SwiftUI
import Contacts
import ContactsUI

struct ContentView: View {
    
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding = true
    public var numberOfAdsPossible = 0
    
    var body: some View {
        TabView {
            if shouldShowOnboarding == false {
                ContactScrollView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Contacts")
                    }
                    
             
                ToolsView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "wand.and.stars")
                        Text("Tools")
                    }
            }
                
         
            
         
            
        }
        
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
                
               
        })
       
        
    }
    
    
    
    
}


struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    @State var showStartedButton = false
    var body: some View {
        ZStack(alignment: .center) {
            Color(UIColor(named: "blueBase")!)
                .edgesIgnoringSafeArea(.all)
            VStack {
                TabView {
                    PageView(title: "The Ultimate Contacts Toolbox",
                             subtitle: "Everything you need in one place",
                             imageName: "ToolsExample",
                             showsDismissButton: false,
                             shouldShowOnboarding: $shouldShowOnboarding, showStartedButton: $showStartedButton,isContactView: false)
                        
                        
                    PageView(title: "Edit Contacts",
                             subtitle: "Change contacts however you like",
                             imageName: "EditExample",
                             showsDismissButton: false,
                             shouldShowOnboarding: $shouldShowOnboarding, showStartedButton: $showStartedButton,isContactView: false)
                        
                    PageView(title: "Merge Duplicates",
                             subtitle: "Remove or combine any unnecessary contacts",
                             imageName: "DuplicatesExample",
                             showsDismissButton: false,
                             shouldShowOnboarding: $shouldShowOnboarding, showStartedButton: $showStartedButton,isContactView: false)
                        
                    PageView(title: "Import and Export",
                             subtitle: "Easily transfer your contacts to any device via Email or SMS",
                             imageName: "ExportExample",
                             showsDismissButton: false,
                             shouldShowOnboarding: $shouldShowOnboarding, showStartedButton: $showStartedButton,isContactView: false)
                    PageView(title: "Access Contacts",
                             subtitle: "Manager needs your permission to manage your contacts",
                             imageName: "bell",
                             showsDismissButton: true,
                             shouldShowOnboarding: $shouldShowOnboarding, showStartedButton: $showStartedButton,isContactView: true)
                        
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                if showStartedButton != true {
                    Button(action: {
                    }, label: {
                        
                        Text("Get Started")
                            .bold()
                            .frame(width: 300, height: 50)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(6)
                    })
                } else {
                    Button(action: {
                        shouldShowOnboarding.toggle()
                    }, label: {
                        
                        Text("Get Started")
                            .bold()
                            .frame(width: 300, height: 50)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(6)
                    })
                }
            }
        }
        
        
    }
}

struct UsefulValues {
     static var myGlobal = 1
}
struct PageView: View {
    let title: String
    let subtitle: String
    let imageName: String
    let showsDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    @Binding var showStartedButton: Bool
    let isContactView: Bool
    var body: some View{
        
            VStack {
                
                if isContactView {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .padding()
                } else {
                    Image(uiImage: (UIImage(named: imageName) ?? UIImage(systemName: "bell"))!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        
                    
                        
                        
                }
                Text(title)
                    .font(.system(size: 28))
                    .multilineTextAlignment(.center)
                    .padding(10)
                    
                Text(subtitle)
                    .font(.system(size: 20))
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,40)
                    .padding(.horizontal,10)
                if isContactView {
                    Button(action: {
                        accessContacts()
                    }, label: {
                        Text("Access Contacts")
                            .bold()
                            .frame(width: 200, height: 50)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(6)
                        
                    })
                    
                }
                
            }
           
            
           
        
        
        
        
        
        
        
        
    }
    func accessContacts() {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed", err)
                showStartedButton = false
            }
            
            if granted {
                print("access granted")
                showStartedButton = true
                print("show2")
            }
            
        }
    }
}









struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
