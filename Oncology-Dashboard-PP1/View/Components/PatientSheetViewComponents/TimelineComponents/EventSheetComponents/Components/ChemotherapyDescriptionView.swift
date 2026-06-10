//
//  ChemotherapyDescription.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 3/5/2026.
//

import SwiftUI

struct ChemotherapyDescriptionView: View {
    let details: ChemotherapyEvent?
    let clinicalNotes: String
    @State private var chemoSummary: ChemoSummary?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            List {
                Section("Treatment Details") {
                    EventSheetListItem(title: "Regimen/Drug", descriptor: details?.drugType ?? "Unavailable")
                    EventSheetListItem(title: "Dosage", descriptor: details?.dosage ?? "Unavailable")
                    EventSheetListItem(title: "Route", descriptor: details?.route ?? "Unavailable")
                    EventSheetListItem(title: "Duration", descriptor: "\(details?.durationHours ?? 0) Hours")
                    EventSheetListItem(title: "Location", descriptor: details?.location ?? "Unavailable")
                }
                Section("Observations") {
                    HStack(spacing: 6) {
                        Image(systemName: "apple.intelligence").symbolRenderingMode(.multicolor).font(.system(size: 16)).frame(width: 22, height: 22)
                        Text("Summarised by Apple Intelligence").font(.caption).foregroundStyle(.secondary)
                    }.padding(.vertical, 4).listRowSeparator(.hidden)
                    EventSheetListItem(title: "Nausea", descriptor: chemoSummary?.Nausea ?? "Not Available")
                    EventSheetListItem(title: "Fatigue", descriptor: chemoSummary?.Fatigue ?? "Not Available")
                }
            }.scrollContentBackground(.hidden)
            VStack(alignment: .leading, spacing: 8) {
                Text("Clinical Notes")
                    .font(.headline)
                ScrollView {
                    Text(clinicalNotes)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 150)
            }
            .padding()
            .background(Color(.white))
            .cornerRadius(12)
            .padding(.horizontal)
        }.task {
            do {
                isLoading = true
                chemoSummary = try await extractChemoDetails(from: clinicalNotes)
            } catch {
                print("Apple Intelligence extraction failed:", error)
            }
            isLoading = false
        }
    }
}
