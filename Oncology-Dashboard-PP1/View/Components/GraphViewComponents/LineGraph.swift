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
    
    @State private var domainData: [DomainData] = []
    var patientPercentages: [PatientPercentages]
    
    func convertPatientPercentages() {
        var physiologicalDataPoints: [LinePoint] = []
        var sleepDataPoints: [LinePoint] = []
        var activityDataPoints: [LinePoint] = []
        var selfReportedDataPoints: [LinePoint] = []
        for percentage in patientPercentages {
            if percentage.physiological != nil {
                physiologicalDataPoints.append(LinePoint(date: percentage.date, value: percentage.physiological!))
            }
            if percentage.sleep != nil {
                sleepDataPoints.append(LinePoint(date: percentage.date, value: percentage.sleep!))
            }
            if percentage.activity != nil {
                activityDataPoints.append(LinePoint(date: percentage.date, value: percentage.activity!))
            }
            if percentage.selfReported != nil {
                selfReportedDataPoints.append(LinePoint(date: percentage.date, value: percentage.selfReported!))
            }
        }
        
        domainData = []
        domainData.append(DomainData(title: "Physiological",
                                     dataPoints: physiologicalDataPoints,
                                     color: .physiological))
        domainData.append(DomainData(title: "Sleep",
                                     dataPoints: sleepDataPoints,
                                     color: .sleep))
        domainData.append(DomainData(title: "Activity",
                                     dataPoints: activityDataPoints,
                                     color: .activity))
        domainData.append(DomainData(title: "Self Reported",
                                     dataPoints: selfReportedDataPoints,
                                     color: .selfReported))
    }
    
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
        .onAppear() {
            convertPatientPercentages()
        }
        .onChange(of: patientPercentages) {
            convertPatientPercentages()
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

//private func createRandomDomainData(title: String, color: Color) -> DomainData {
//    let now = Date()
////    let newMetricData = calculateDayByDayDomainDeviation(data: testMetricData)
//    let linePoints = (0..<5).map { i in
//        
//        LinePoint(
//            date: Calendar.current.date(byAdding: .day, value: i, to: now)!,
//            value: Double.random(in: -50...50)
//        )
//    }
//    return DomainData(title: title, dataPoints: linePoints, color: color)
//}
//
//func getTestDomainData() -> [DomainData] {
//    
//    var domainData: [DomainData] = []
//    domainData.append(createRandomDomainData(
//        title: "Physiological",
//        color: Color.physiological
//    ))
//    domainData.append(createRandomDomainData(
//        title: "Sleep",
//        color: Color.sleep
//    ))
//    domainData.append(createRandomDomainData(
//        title: "Activity",
//        color: Color.activity
//    ))
//    domainData.append(createRandomDomainData(
//        title: "Self Reported",
//        color: Color.selfReported
//    ))
//    return domainData
//}

#Preview {
    var patientPercentages = [
        PatientPercentages(id: 1, date: Date(), patientId: 1, physiological: 20.0, activity: 15.0, sleep: nil, selfReported: 15.0),
        PatientPercentages(id: 2, date: Date().addingTimeInterval(10), patientId: 1, physiological: 18.0, activity: nil, sleep: 9.0, selfReported: 18.0),
        PatientPercentages(id: 3, date: Date().addingTimeInterval(20), patientId: 1, physiological: 19.0, activity: 13.0, sleep: 6.0, selfReported: 20.0),
    ]
    
    LineGraph(patientPercentages: patientPercentages)
        .padding(.horizontal, 400)
        .padding(.vertical, 300)
}
