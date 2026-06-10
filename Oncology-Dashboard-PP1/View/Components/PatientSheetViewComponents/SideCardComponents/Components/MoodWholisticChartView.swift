//
//  MoodWholisticChartView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//

import SwiftUI
import Charts

struct MoodWholisticChartView: View {
    let patient: Int

    @State private var viewModel = MoodWholisticChartViewViewModel()

    var body: some View {
        ScrollView(.horizontal) {
            Chart(viewModel.moodPoints) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Mood", point.mood)
                )
                .foregroundStyle(.selfReported)

                PointMark(
                    x: .value("Date", point.date),
                    y: .value("Mood", point.mood)
                )
                .foregroundStyle(.selfReported)
            }
            .chartYScale(domain: 1...7)
            .chartYAxis {
                AxisMarks(values: [1, 2, 3, 4, 5, 6, 7])
            }
            .chartXScale(range: .plotDimension(padding: 24))
            .frame(
                width: max(CGFloat(viewModel.moodPoints.count) * 55, 380),
                height: 220
            )
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .task {
            await viewModel.loadMoodData(patientId: patient)
        }
    }
}

#Preview {
    MoodWholisticChartView(patient: 1)
}
