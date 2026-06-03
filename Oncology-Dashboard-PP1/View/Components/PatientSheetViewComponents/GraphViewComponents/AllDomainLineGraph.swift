//
//  LineGraph.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 20/5/2026.
//

import SwiftUI
import Charts


struct DomainLineGraphData {
    let id = UUID()
    let title: String
    let dataPoints: [LinePoint]
    let color: Color
}

struct AllDomainLineGraph: View {
    
    @State private var domainData: [DomainLineGraphData] = []
    var patientPercentages: [PatientPercentages]
    
    @Binding var displayPhysiological: Bool
    @Binding var displayActivity: Bool
    @Binding var displaySleep: Bool
    @Binding var displaySelfReported: Bool
    
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
        if displayPhysiological {
            domainData.append(DomainLineGraphData(title: "Physiological",
                                                  dataPoints: physiologicalDataPoints,
                                                  color: .physiological))
        }
        if displaySleep {
            domainData.append(DomainLineGraphData(title: "Sleep",
                                                  dataPoints: sleepDataPoints,
                                                  color: .sleep))
        }
        if displayActivity {
            domainData.append(DomainLineGraphData(title: "Activity",
                                                  dataPoints: activityDataPoints,
                                                  color: .activity))
        }
        if displaySelfReported {
            domainData.append(DomainLineGraphData(title: "Self Reported",
                                                  dataPoints: selfReportedDataPoints,
                                                  color: .selfReported))
        }
    }
    
    var body: some View {
        
        
        
        Chart(Array(domainData.enumerated()), id: \.element.id) { domainIndex, domainData in
            ForEach(Array(domainData.dataPoints.enumerated()), id: \.element.id) { pointIndex, dataPoints in
                LineMark(
                    x: .value("Index", dataPoints.date),
                    y: .value("Amount", max(-100, min(dataPoints.value, 100))),
                    series: .value("Domain", domainData.title)
                )
                .foregroundStyle(domainData.color)
                PointMark(
                    x: .value("Index", dataPoints.date),
                    y: .value("Amount", max(-100, min(dataPoints.value, 100)))
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
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel()
                    .font(.system(size: 16, weight: .bold))
            }
        }
        .onAppear() {
            convertPatientPercentages()
        }
        .onChange(of: patientPercentages) {
            convertPatientPercentages()
        }
        .onChange(of: displayPhysiological) {
            convertPatientPercentages()
        }
        .onChange(of: displaySleep) {
            convertPatientPercentages()
        }
        .onChange(of: displayActivity) {
            convertPatientPercentages()
        }
        .onChange(of: displaySelfReported) {
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

struct AllDomainLineGraphPreview: View {
    var patientPercentages = [
        PatientPercentages(id: 1, date: Date(), patientId: 1, physiological: 20.0, activity: 15.0, sleep: nil, selfReported: 15.0),
        PatientPercentages(id: 2, date: Date().addingTimeInterval(10), patientId: 1, physiological: 18.0, activity: nil, sleep: 14.0, selfReported: 18.0),
        PatientPercentages(id: 3, date: Date().addingTimeInterval(20), patientId: 1, physiological: 19.0, activity: 13.0, sleep: 6.0, selfReported: 20.0),
    ]
    @State var displayPhysiological: Bool = true
    @State var displayActivity: Bool = true
    @State var displaySleep: Bool = true
    @State var displaySelfReported: Bool = true
    var body: some View {
        AllDomainLineGraph(patientPercentages: patientPercentages, displayPhysiological: $displayPhysiological, displayActivity: $displayActivity, displaySleep: $displaySleep, displaySelfReported: $displaySelfReported)
            .padding(.horizontal, 400)
            .padding(.vertical, 300)
    }
}

#Preview {
    AllDomainLineGraphPreview()
    
}
