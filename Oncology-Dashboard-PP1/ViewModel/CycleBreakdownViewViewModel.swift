//
//  CycleBreakdownViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 2/6/2026.
//

import Foundation
import FoundationModels


@Observable
class CycleBreakdownViewViewModel {
    
    
    var cycleStartDate: Date
    var cycleEndDate: Date
    
    var patientDomainData: PatientDomainData? = nil
    
    init(cycleStartDate: Date, cycleEndDate: Date) {
        self.cycleStartDate = cycleStartDate
        self.cycleEndDate = cycleEndDate
    }
    
    private func getActivityPercentageDeviance(patientId: Int) async throws -> [[MetricData]] {
        let activityData = try await fetchActivityData(for: patientId)
        // Only use data in between the cycles
        let cycleActivityData = activityData.filter { $0.date >= self.cycleStartDate && $0.date <= self.cycleEndDate}
        // Group by the types
        
        let groupedActivityData = Dictionary(grouping: cycleActivityData) { $0.type }
            .sorted { $0.key < $1.key }
            .map { $0.value }
        
        var percentageDeviances: [[MetricData]] = []
        // Calculate the percentage deviance for each entry from the last
        for activityTypes in groupedActivityData {
            let metricData = activityTypes.map { entry in
                MetricData(date: entry.date, value: entry.value)
            } .sorted { $0.date < $1.date }
            let newMetricData = calculateDayByDayDomainDeviation(data: metricData)
                
            // Print for debugging
//            for i in newMetricData {
//                print("\(i.date) : \(i.deviationPercentage)")
//            }
//            print("---------")
            percentageDeviances.append(newMetricData)
        }
        
        return percentageDeviances
    }
    
    private func getPhysiologicalPercentageDeviance(patientId: Int) async throws -> [[MetricData]] {
        let physiologicalData = try await fetchPhysiologicalData(for: patientId)
        // Only use data after the start date
        let cyclePhysiologicalData = physiologicalData.filter { $0.date >= self.cycleStartDate && $0.date <= self.cycleEndDate}
        // Group by the types
        
        let groupedPhysiologicalData = Dictionary(grouping: cyclePhysiologicalData) { $0.type }
            .sorted { $0.key < $1.key }
            .map { $0.value }
        
        var percentageDeviances: [[MetricData]] = []
        // Calculate the percentage deviance for each entry from the last
        for physiologicalTypes in groupedPhysiologicalData {
            let metricData = physiologicalTypes.map { entry in
                MetricData(date: entry.date, value: entry.value, type: entry.type)
            } .sorted { $0.date < $1.date }
            let newMetricData = calculateDayByDayDomainDeviation(data: metricData)
                
            // Print for debugging
//            for i in newMetricData {
//                print("\(i.date) : \(i.deviationPercentage)")
//            }
//            print("---------")
            percentageDeviances.append(newMetricData)
        }
        
        return percentageDeviances
        
    }

    func fetchPatientCycleData(for patientId: Int) async throws -> PatientDomainData {
            // Grab the data
        let physiologicalData = try await self.getPhysiologicalPercentageDeviance(patientId: patientId)
        let activityData = try await self.getPhysiologicalPercentageDeviance(patientId: patientId)
        //                            let sleepDeviance = []
        //                            let selfReportedDeviance = []
        
        
        return PatientDomainData(
            activity: activityData,
            physiological: physiologicalData
        )
    }
    
    private func calculateConcernScores(data: [[MetricData]]) -> [ConcernScore] {
        var scores: [ConcernScore] = []
        
        for metricDataByType in data {
            let type = metricDataByType.first?.type ?? ""
            let deviations = metricDataByType.map { $0.deviationPercentage }
            var score: Double = 0.0
            var reasons: [String] = []
            
            // Spike Detection
            let maxAbsDev = deviations.map { abs($0) }.max() ?? 0
            if maxAbsDev > 100 {
                score += 40
                reasons.append("Extreme spike: \(String(format: "%.1f", maxAbsDev))% deviation")
            } else if maxAbsDev > 15 {
                score += 20
                reasons.append("Notable spike: \(String(format: "%.1f", maxAbsDev))% deviation")
            }
            
            // Trend detection
            if deviations.count >= 3 {
                var increases = 0
                var decreases = 0
                for i in 1..<deviations.count {
                    if deviations[i] > deviations[i - 1] { increases += 1 }
                    else if deviations[i] < deviations[i - 1] { decreases += 1 }
                }
                let total = deviations.count - 1
                let trendStrength = Double(max(increases, decreases)) / Double(total)
                if trendStrength >= 0.75 {
                    score += 25
                    let dir = increases > decreases ? "upward" : "downward"
                    reasons.append("Strong \(dir) trend (\(Int(trendStrength * 100))% consistent)")
                }
            }
            
            // Volatility ??
            
            
            // Sustained neg / pos deviation ??
            
            
            scores.append(ConcernScore(type: type, score: score, reasons: reasons))
        }
        
        return scores
            .sorted { $0.score > $1.score }
    }
    
    
    func extractMostConcerningMetrics(for patientId: Int, topN: Int = 3) async throws -> [MostConcerningMetrics] {
        self.patientDomainData = try await self.fetchPatientCycleData(for: patientId)
        
//        if self.patientDomainData != nil {
//            print("Activity:")
//            for i in self.patientDomainData!.activity {
//                for j in i {
//                    print(j)
//                }
//                print("-----")
//            }
//            print(self.patientDomainData!.physiological)
//        }
        
        var scores: [ConcernScore] = []
        
        if self.patientDomainData == nil {
            return []
        }
        scores.append(contentsOf: calculateConcernScores(data: self.patientDomainData!.activity))
        scores.append(contentsOf: calculateConcernScores(data: self.patientDomainData!.physiological))
        
        var seen = Set<String>() // To remove duplicates
        scores = scores
            .filter { seen.insert($0.type).inserted }
            .sorted { $0.score > $1.score }
            .prefix(topN)
            .map { $0 }
        
        if scores.isEmpty {
            return []
        }
        print("Scores: \(scores)")
        
        var mostConcerningMetrics: [MostConcerningMetrics] = []
        for score in scores {
            for data in self.patientDomainData!.physiological {
                if data.first?.type == score.type {
                    mostConcerningMetrics.append(MostConcerningMetrics(domain: "Physiological", type: score.type, data: data))
                    break
                }
            }
            for data in self.patientDomainData!.activity {
                if data.first?.type == score.type {
                    mostConcerningMetrics.append(MostConcerningMetrics(domain: "Activity", type: score.type, data: data))
                    break
                }
            }
        }
        
        return mostConcerningMetrics
    }
}
