//
//  LineGraph.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 20/5/2026.
//

import SwiftUI
import Charts



struct MostConcerningLineGraph: View {
    
    
    var mostConcerningMetrics: [MostConcerningMetrics]
    
    var body: some View {
        
        Chart {
            ForEach(Array(mostConcerningMetrics.enumerated()), id: \.element.type) { index, metric in
                ForEach(metric.data, id: \.date) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Amount", max(-100, min(dataPoint.deviationPercentage, 100))),
                        series: .value("Domain", index)
                    )
                    .foregroundStyle(by: .value("Type", metric.type))
                    PointMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Amount", max(-100, min(dataPoint.deviationPercentage, 100)))
                    )
                    .symbol(Circle())
                    .foregroundStyle(by: .value("Type", metric.type))
                }
            }
        }.chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel()
                    .font(.system(size: 16, weight: .bold))
            }
        }

    }
}


#Preview {
    MostConcerningLineGraph(mostConcerningMetrics: [
        MostConcerningMetrics(domain: "Physiological", type: "HKQuantityTypeIdentifierBasalEnergyBurned", data: [
            MetricData(date: Date(), value: 9.35, deviationPercentage: 0.0),
            MetricData(date: Date().addingTimeInterval(86400), value: 30.89, deviationPercentage: 230.3),
            MetricData(date: Date().addingTimeInterval(86400 * 2), value: 66.89, deviationPercentage: 615.4),
            MetricData(date: Date().addingTimeInterval(86400 * 3), value: 15.12, deviationPercentage: 61.7)
        ]),
        MostConcerningMetrics(domain: "Activity", type: "HKQuantityTypeIdentifierHeartRateVariabilitySDNN", data: [
            MetricData(date: Date(), value: 44.30, deviationPercentage: 0.0),
            MetricData(date: Date().addingTimeInterval(86400), value: 25.05, deviationPercentage: -43.4),
            MetricData(date: Date().addingTimeInterval(86400 * 2), value: 64.68, deviationPercentage: 46.0),
            MetricData(date: Date().addingTimeInterval(86400 * 3), value: 31.47, deviationPercentage: -28.9)
        ]),
        MostConcerningMetrics(domain: "Activity", type: "HKQuantityTypeIdentifierHeartRate", data: [
            MetricData(date: Date(), value: 106.59, deviationPercentage: 0.0),
            MetricData(date: Date().addingTimeInterval(86400), value: 87.82, deviationPercentage: -17.6),
            MetricData(date: Date().addingTimeInterval(86400 * 2), value: 86.74, deviationPercentage: -18.6),
            MetricData(date: Date().addingTimeInterval(86400 * 3), value: 108.30, deviationPercentage: 1.6)
        ])
    ])
    
}
