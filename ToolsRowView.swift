//
//  ToolsRowView.swift
//  Contacts Manager
//
//  Created by Viraj Singh on 6/20/21.
//

import SwiftUI

struct ToolsRowView: View {
    var systemImageName : String
    var rowName : String
    var numberOfListItems = 0
    var body: some View {
        HStack {
            
            Image(systemName: systemImageName)
                .font(.body)
            Text(rowName)
                .font(.body)
            Spacer()
            if rowName == "Missing Name" || rowName == "Missing Phone Number" || rowName == "Missing Email Address" || rowName == "Same First Name" || rowName == "Same Full Name" || rowName == "Same Phone Number" || rowName == "Same Email Address" || rowName == "Exact Duplicates"{
                Text("\(numberOfListItems)")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            
            
        }
    }
}

struct ToolsRowView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsRowView(systemImageName: "timer", rowName: "hi")
    }
}
