//
//  SideCardView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 3/6/2026.
//

import SwiftUI

struct SideCardView: View {
    let patientId: Int
    @State private var selectedDomain = "Sleep"
    let domains = ["Sleep", "Self Reported"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Patient Quality of Life - Across All Cycles").font(.headline)

            Picker("Domain", selection: $selectedDomain) {
                ForEach(domains, id: \.self) { domain in
                    Text(domain)
                }
            }
            .pickerStyle(.segmented)
            
            if selectedDomain == "Sleep" {
                SleepWholisticChartView(patient: patientId)
                Spacer()
                Text("Sleep Scores Measured from 0 to 100").font(.caption).foregroundStyle(.secondary)
            } else {
                MoodWholisticChartView(patient: patientId)
                Spacer()
                Text("Mood scores from 1 to 7").font(.caption).foregroundStyle(.secondary)
            }
            
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.25), lineWidth: 1)
        }
        .shadow(radius: 12)
        .padding()
    }
}

#Preview {
    SideCardView(patientId: 1)
}
