//
//  LineGraph.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 20/5/2026.
//

import SwiftUI
import Charts

struct LinePoint {
    var id = UUID()
    var date: Date
    var value: Double
}

struct DomainData {
    let id = UUID()
    let title: String
    let dataPoints: [LinePoint]
    let color: Color
}

struct LineGraph: View {
    
    var domainData: [DomainData]
    
    var body: some View {
        
        Chart(Array(domainData.enumerated()), id: \.element.id) { domainIndex, domainData in
            ForEach(Array(domainData.dataPoints.enumerated()), id: \.element.id) { pointIndex, dataPoints in
                LineMark(
                    x: .value("Index", dataPoints.date),
                    y: .value("Amount", dataPoints.value),
                    series: .value("Domain", domainData.title)
                )
                .foregroundStyle(domainData.color)
                PointMark(
                    x: .value("Index", dataPoints.date),
                    y: .value("Amount", dataPoints.value)
                )
                .symbol(Circle())
                .foregroundStyle(domainData.color)
            }
            
//                .annotation(position: .top) {
//                    Text("$\(amount.value, specifier: "%.2f")")
//                        .font(.caption)
//                        .foregroundColor(getColorFromValue(value: amount.value))
//                }
        }
//        .frame(
//            width: max(CGFloat(dollarAmounts.count) * barWidth, UIScreen.main.bounds.width - 20),
//            height: 300
//        )
//        .chartXAxis {
//            AxisMarks(values: Array(dollarAmounts.indices)) { value in
//                if let idx = value.as(Int.self) {
//                    AxisValueLabel {
//                        Text(formatDateMedium(date: dollarAmounts[idx].date))
//                    }
//                }
//            }
//        }
    }
}

private func createRandomDomainData(title: String, color: Color) -> DomainData {
    let now = Date()
    let linePoints = (0..<5).map { i in
        
        LinePoint(
            date: Calendar.current.date(byAdding: .day, value: i, to: now)!,
            value: Double.random(in: -50...50)
        )
    }
    return DomainData(title: title, dataPoints: linePoints, color: color)
}

func getTestDomainData() -> [DomainData] {
    
    var domainData: [DomainData] = []
    domainData.append(createRandomDomainData(
        title: "Physiological",
        color: Color.physiological
    ))
    domainData.append(createRandomDomainData(
        title: "Sleep",
        color: Color.sleep
    ))
    domainData.append(createRandomDomainData(
        title: "Activity",
        color: Color.activity
    ))
    domainData.append(createRandomDomainData(
        title: "Self Reported",
        color: Color.selfReported
    ))
    return domainData
}

#Preview {
    var domainData: [DomainData] = getTestDomainData()
    
    LineGraph(domainData: domainData)
        .padding(.horizontal, 400)
        .padding(.vertical, 300)
}
