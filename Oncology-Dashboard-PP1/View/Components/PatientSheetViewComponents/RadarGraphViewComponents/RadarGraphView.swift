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
    let datasets = [
        RadarDataset(name: "Cycle 3", values: [0.32, 0.75, 0.68, 0.9], color: .nhGray),
        RadarDataset(name: "Cycle 4", values: [0.99, 0.66, 0.58, 0.78], color: .nhBlue),
        RadarDataset(name: "Cycle 5", values: [0.61, 0.89, 0.49, 0.7], color: .nhGreen)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                ForEach(datasets, id: \.name) { dataset in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(dataset.color)
                            .frame(width: 9, height: 9)

                        Text(dataset.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            RadarChartView(
                datasets: datasets,
                labels: ["Sleep", "Physiological", "Activity", "Reported"]
            )
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
    RadarGraphView()
}
