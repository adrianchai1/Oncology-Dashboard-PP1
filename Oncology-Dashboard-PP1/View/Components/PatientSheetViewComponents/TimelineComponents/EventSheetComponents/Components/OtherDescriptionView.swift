//
//  ChemotherapyDescription.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 3/5/2026.
//

import SwiftUI

struct OtherDescriptionView: View {
    var title: String
    
    var body: some View {
            Text(title)
            List {
                HStack {
                    Text("Title")
                    Spacer()
                    Text(title)
                        .foregroundStyle(.secondary)
                }
            }.scrollContentBackground(.hidden)
    }
}

#Preview {
    OtherDescriptionView(title: "Sore Throat")
}
