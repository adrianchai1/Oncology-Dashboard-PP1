//
//  SleepWholisticChartView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 3/6/2026.
//

import SwiftUI
import Charts

struct SleepWholisticChartView: View {
    let patient: Int
    @State private var viewModel = SleepWholisticChartViewViewModel()

    var body: some View {
        ScrollView(.horizontal) {
            Chart(viewModel.sleepScorePoints) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Sleep Score", point.score)
                ).foregroundStyle(.sleep)

                PointMark(
                    x: .value("Date", point.date),
                    y: .value("Sleep Score", point.score)
                ).foregroundStyle(.sleep)
            }
            .chartYScale(domain: 0...105)
            .chartXScale(range: .plotDimension(padding: 24))
            .frame(
                width: max(CGFloat(viewModel.sleepScorePoints.count) * 55, 380),
                height: 220
            )
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .task {
            await viewModel.loadSleepData(patientId: patient)
        }
    }
}

#Preview {
    SleepWholisticChartView(patient: 1)
}
