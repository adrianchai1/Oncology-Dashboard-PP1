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
    
    private func getActivityGroupedData(patientId: Int) async throws -> [[ActivityDomain]] {
        let activityData = try await fetchActivityData(for: patientId)
        // Only use data in between the cycles
        let cycleActivityData = activityData.filter { $0.date >= self.cycleStartDate && $0.date <= self.cycleEndDate}
        // Group by the types
        
        let groupedActivityData = Dictionary(grouping: cycleActivityData) { $0.type }
            .sorted { $0.key < $1.key }
            .map { $0.value }
        
        
        return groupedActivityData
    }
    
    private func getPhysiologicalGroupedData(patientId: Int) async throws -> [[PhysiologicalDomain]] {
        let physiologicalData = try await fetchPhysiologicalData(for: patientId)
        // Only use data after the start date
        let cyclePhysiologicalData = physiologicalData.filter { $0.date >= self.cycleStartDate && $0.date <= self.cycleEndDate}
        // Group by the types
        
        let groupedPhysiologicalData = Dictionary(grouping: cyclePhysiologicalData) { $0.type }
            .sorted { $0.key < $1.key }
            .map { $0.value }
        
        
        return groupedPhysiologicalData
        
    }

    func fetchPatientCycleData(for patientId: Int) async {
        do {
            // Grab the data
            let physiologicalData = try await self.getPhysiologicalGroupedData(patientId: patientId)
            let activityData = try await self.getActivityGroupedData(patientId: patientId)
            //                            let sleepDeviance = []
            //                            let selfReportedDeviance = []
            
            
            self.patientDomainData = PatientDomainData(
                activity: activityData,
                physiological: physiologicalData
            )
            
        } catch {
            print(error)
        }
    }
    
    private func patientDomainDataToString() -> String {
        var string = ""
        
        if self.patientDomainData == nil { return "" }
        
        string.append("Physiological Domain: \n")
        for (index, section) in self.patientDomainData!.physiological.enumerated() {
            let physiologicalString = section.map(\.toString).joined(separator: "\n")
            string.append("\(index + 1). \(physiologicalString)\n\n")
        }
        string.append("Activity Domain: \n")
        for (index, section) in self.patientDomainData!.activity.enumerated() {
            let physiologicalString = section.map(\.toString).joined(separator: "\n")
            string.append("\(index + 1). \(physiologicalString)\n\n")
        }
        
        return string
    }
    
    func extractMostConcerningMetrics() async throws -> MostConcerningMetrics? {
        if self.patientDomainData == nil { return nil }
        
        let session = LanguageModelSession()
        let prompt = """
        Extract the top 3 metrics that have changed the most in a negative/positive way.

        Return mostConcern as a list of objects with:
        - title: the metric name
        - value: the numeric value
        - unit: the unit symbol the metric is recorded as ( for example: %, kg, steps )
        - domain: which domain this metric belongs to HAS TO BE Either: Physiological, Sleep, Activity, Self Reported
        - date: the date in "yyyy-MM-dd" format
        - good: false if the change is bad, true if good
        Metrics:
        \(patientDomainDataToString())
        """
        
        let response = try await session.respond(to: prompt, generating: MostConcerningMetrics.self)
        return response.content
    }
}
