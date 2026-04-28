//
//  ContentView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 18/3/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: String? = "Patients"

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink("Patients", value: "Patients")
            }.listStyle(.sidebar)
        } detail: {
            if selection == "Patients" {
                PatientView()
            } else {
                Text("Select an option")
            }
        }.navigationSplitViewStyle(.prominentDetail)
    }
}

#Preview {
    ContentView()
}
