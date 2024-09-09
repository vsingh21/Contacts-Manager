//
//  SearchBarView.swift
//  Contacts Manager
//
//  Created by Viraj Singh on 6/18/21.
//
import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                TextField("Search", text: $searchText)
                    .padding(.leading, 24)
                    .font(.title2)
            }
            .padding(5)
            .background(Color(.systemGray5))
            .cornerRadius(6)
            .onTapGesture(perform: {
                isSearching = true
            })
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.headline)
                    Spacer()
                    
                    if isSearching {
                        Button(action: {
                            searchText = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.vertical)
                                .font(.headline)
                        })
                        
                        
                    }
                    
                }.padding(.horizontal, 3)
                .foregroundColor(.gray)
            ).transition(.move(edge: .trailing))
            .animation(.spring())
            
            
            if isSearching {
                Button(action: {
                    isSearching = false
                    searchText = ""
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }, label: {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(Color(UIColor(named: "blueBase")!))
                })
                .animation(.spring())
            }
            
        }
    }
}


