//
//  ChemotherapyDescription.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 3/5/2026.
//

import SwiftUI

struct AppointmentDescriptionView: View {
    let clinicalNotes: String
    @State private var details: AppointmentSummary?
    @State private var isLoading = false
    var body: some View {
        VStack {
            if isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "apple.intelligence").symbolRenderingMode(.multicolor).font(.system(size: 50)).symbolEffect(.variableColor.iterative)
                    Text("Generating Summary").font(.headline).foregroundStyle(.secondary)
                    Spacer()
                }.frame(maxWidth: .infinity).padding(.vertical, 30)
            } else {
                List {
                    Section("Future Plans and Recommendations") {
                        HStack(spacing: 6) {
                            Image(systemName: "apple.intelligence").symbolRenderingMode(.multicolor).font(.system(size: 16)).frame(width: 22, height: 22)
                            Text("Summarised by Apple Intelligence").font(.caption).foregroundStyle(.secondary)
                        }.padding(.vertical, 4).listRowSeparator(.hidden)
                        EventSheetListItem(title: "Plan", descriptor: details?.plan ?? "Not Available")
                        EventSheetListItem(title: "Follow up", descriptor: details?.followUp ?? "Not Available")
                    }
                    Section("Summary") {
                        HStack(spacing: 6) {
                            Image(systemName: "apple.intelligence").symbolRenderingMode(.multicolor).font(.system(size: 16)).frame(width: 22, height: 22)
                            Text("Summarised by Apple Intelligence").font(.caption).foregroundStyle(.secondary)
                        }.padding(.vertical, 4).listRowSeparator(.hidden)
                        if let keyFindings = details?.keyFindings, !keyFindings.isEmpty {
                            ForEach(keyFindings, id: \.title) { item in
                                EventSheetListItem(title: item.title, descriptor: item.value)
                            }
                        } else {
                            Text("No summary generated").foregroundStyle(.secondary)
                        }
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
            }
        }.task {
            do {
                isLoading = true
                details = try await extractApptDetails(from: clinicalNotes)
            } catch {
                print("Apple Intelligence extraction failed:", error)
            }
            isLoading = false
        }
    }
}

#Preview {
    AppointmentDescriptionView(clinicalNotes: "Patient reviewed prior to Cycle 4 FOLFOX chemotherapy. Reports ongoing mild nausea and fatigue for 2–3 days post infusion, manageable with ondansetron. No vomiting. Oral intake adequate. Denies fevers, rigors, chest pain or shortness of breath. Bowels regular. Mild peripheral neuropathy affecting fingertips, unchanged from prior cycle. Examination unremarkable. ECOG 1. Bloods reviewed — neutrophils and platelets within acceptable range to proceed with treatment. Discussed ongoing neuropathy risk associated with oxaliplatin. Plan to continue current dosing this cycle with close monitoring. Proceed with Cycle 4 today. Follow-up prior to next cycle.")
}
