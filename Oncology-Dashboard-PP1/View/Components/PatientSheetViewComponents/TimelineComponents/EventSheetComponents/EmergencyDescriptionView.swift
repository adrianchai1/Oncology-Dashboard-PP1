//
//  ChemotherapyDescription.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 3/5/2026.
//

import SwiftUI

struct EmergencyDescriptionView: View {
    let clinicalNotes: String
    @State private var details: EmergencyEventDetails?
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
                Text("Emergency Details")
                HStack(spacing: 6) {
                    Image(systemName: "apple.intelligence").symbolRenderingMode(.multicolor)
                    Text("Summarised by Apple Intelligence").font(.caption).foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                List {
                    EventSheetListItem(title: "Location", descriptor: "Northern Hospital Epping")
                    EventSheetListItem(title: "Ward Admittance", descriptor: "Ward 4")
                    EventSheetListItem(title: "Reason for Admittance", descriptor: details?.reasonForVisit ?? "Not Available")
                    EventSheetListItem(
                        title: "Patient Temperature", descriptor: details?.temperature != nil ? "\(details!.temperature!)°C" : "Not Available"
                    )
                    EventSheetListItem(
                        title: "Patient Heart Rate", descriptor: details?.heartRate != nil ? "\(details!.heartRate!) bpm" : "Not Available"
                    )
                    EventSheetListItem(
                        title: "Patient O2 Saturation", descriptor: details?.spo2 != nil ? "\(details!.spo2!)%" : "Not Available"
                    )
                    EventSheetListItem(
                        title: "Patient Pain Score", descriptor: details?.painScore != nil ? "\(details!.painScore!)/10" : "Not Available"
                    )
                    EventSheetListItem(
                        title: "Interventions", descriptor: details?.interventions.joined(separator: ", ") ?? "Not Available"
                    )
                    EventSheetListItem(
                        title: "Treatments", descriptor: details?.treatments.joined(separator: ", ") ?? "Not Available"
                    )
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
                details = try await extractEmergencyDetails(from: clinicalNotes)
            } catch {
                print("Apple Intelligence extraction failed:", error)
            }
            isLoading = false
        }
    }
}

#Preview {
    EmergencyDescriptionView(clinicalNotes: "adrian chai 22y male admitted to ED for pain and swelling in lower leg. CNS - patient is alert and orientated, GCS 15. Complaining of severe pain in lower leg after a fall down stairs. Pain currently 7/10, paracetamol administered for baseline pain relief with oral oxycodone given for breakthrough pain as charted. Pain score to be reassessed 30–60 minutes post administration. Limb elevated and ice applied to assist with pain and swelling reduction. Consider escalation to IV analgesia if pain worsens or remains uncontrolled. Ongoing neurovascular and sedation observations to continue. CVS - HR 102 bpm, BP 128/76 mmHg. Peripheral perfusion intact. Mild tachycardia likely secondary to pain. Respirations even and unlaboured. RR 18 breaths/min, SpO2 99% on room air. No respiratory distress noted. MSK - Significant swelling and tenderness noted to lower right leg with reduced range of motion secondary to pain. Patient unable to fully weight bear. No obvious open fracture or deformity observed. Distal pulses present, capillary refill <2 seconds, sensation intact distally. Integumentary - Bruising and soft tissue swelling present over lower leg. Skin warm and intact. Care plan - X-ray ordered to exclude fracture. Ongoing neurovascular observations and pain assessment to continue.")
}
