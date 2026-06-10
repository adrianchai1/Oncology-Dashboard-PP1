//
//  RadarGraphView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 31/5/2026.
//

import SwiftUI

struct RadarDataset {
    let name: String
    let values: [Double]
    let color: Color
}

struct RadarGraphView: View {
    let patient: Patient
    let colors: [Color] = [.nhGray, .nhBlue, .nhGreen]

    @State private var vm = RadarGraphViewViewModel()

    var radarDatasets: [RadarDataset] {
        let radarCycleData = vm.getLatestThreeCycleRadarData(latestCycle: patient.cycleCount, treatmentStartDate: patient.treatmentStartDate, cycleDurationDays: patient.cycleLengthInDays)

        return radarCycleData.enumerated().map { pair in
            let index = pair.offset
            let cycle = pair.element

            return RadarDataset(
                name: "Cycle \(cycle.cycleNumber)",
                values: [
                    cycle.sleep / 100,
                    cycle.physiological / 100,
                    cycle.activity / 100,
                    cycle.selfReported / 100
                ],
                color: colors[index]
            )
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                ForEach(radarDatasets, id: \.name) { dataset in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(dataset.color)
                            .frame(width: 9, height: 9)

                        Text(dataset.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Text("Higher is better").font(.caption).foregroundStyle(.secondary)
            }
            RadarChartView(datasets: radarDatasets, labels: ["Sleep", "Physiological", "Activity", "Reported"])
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(.white.opacity(0.25), lineWidth: 1)
        }
        .shadow(radius: 12)
        .padding()
        .task {
            await vm.loadSleepData(patientId: patient.id)
            await vm.loadPhysiologicalData(patientId: patient.id)
            await vm.loadActivityData(patientId: patient.id)
            await vm.loadMoodData(patientId: patient.id)
        }
    }
}

