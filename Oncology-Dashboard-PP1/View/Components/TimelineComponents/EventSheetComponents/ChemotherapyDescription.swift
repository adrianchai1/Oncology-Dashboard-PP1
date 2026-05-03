//
//  ChemotherapyDescription.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 3/5/2026.
//

import SwiftUI

struct ChemotherapyDescription: View {
    var body: some View {
            Text("Treatment Details")
            List {
                HStack {
                    Text("Regimen/Drug")
                    Spacer()
                    Text("IV Chemotherapy Drug")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Dose")
                    Spacer()
                    Text("175mg")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Route")
                    Spacer()
                    Text("IV")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Duration")
                    Spacer()
                    Text("3 hrs")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Location")
                    Spacer()
                    Text("Oncology Ward Floor 3")
                        .foregroundStyle(.secondary)
                }
            }.scrollContentBackground(.hidden)
    }
}

#Preview {
    ChemotherapyDescription()
}
