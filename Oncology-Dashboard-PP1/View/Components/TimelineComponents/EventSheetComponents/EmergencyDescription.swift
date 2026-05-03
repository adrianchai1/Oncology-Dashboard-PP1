//
//  ChemotherapyDescription.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 3/5/2026.
//

import SwiftUI

struct EmergencyDescription: View {
    var body: some View {
            Text("Emergency Details")
            List {
                HStack {
                    Text("Location")
                    Spacer()
                    Text("Northern Hospital Epping")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Ward Admmitance")
                    Spacer()
                    Text("Ward 4")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Description of Emergency")
                    Spacer()
                    Text("Fall resulting in knee injury")
                        .foregroundStyle(.secondary)
                }
            }.scrollContentBackground(.hidden)
    }
}

#Preview {
    EmergencyDescription()
}
