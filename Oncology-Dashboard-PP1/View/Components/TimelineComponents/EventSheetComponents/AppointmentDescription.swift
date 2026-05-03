//
//  ChemotherapyDescription.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 3/5/2026.
//

import SwiftUI

struct AppointmentDescription: View {
    var body: some View {
            Text("Appointment Details")
            List {
                HStack {
                    Text("Location")
                    Spacer()
                    Text("Northern Hospital Epping")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Type of Appointment")
                    Spacer()
                    Text("Medicinal")
                        .foregroundStyle(.secondary)
                }
            }.scrollContentBackground(.hidden)
    }
}

#Preview {
    AppointmentDescription()
}
