//
//  PatientCardViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 11/6/2026.
//

import Foundation
import Observation

@Observable
class PatientCardViewViewModel {
    var sleepPercentage: Double = 0.0
    var activityPercentage: Double = 0.0
    var moodPercentage: Double = 0.0
    var physiologicalPercentage: Double = 0.0
    
    var latestCycleStartDate: Date
    
    private var patientSleepData: [SleepDomain] = []
    private var patientActivityData: [ActivityDomain] = []
    private var patientMoodData: [MoodDomain] = []
    private var patientPhysiologicalData: [PhysiologicalDomain] = []
    
    init (latestCycleStartDate: Date) {
        self.latestCycleStartDate = latestCycleStartDate
    }
    
    func loadPercentages(patientId: Int) async {
        do {
            patientMoodData = try await fetchMoodData(for: patientId).filter({$0.date > self.latestCycleStartDate})
            patientSleepData = try await fetchSleepData(for: patientId).filter({$0.startDate > self.latestCycleStartDate})
            patientActivityData = try await fetchActivityData(for: patientId).filter({$0.date > self.latestCycleStartDate})
            patientPhysiologicalData = try await fetchPhysiologicalData(for: patientId).filter({$0.date > self.latestCycleStartDate})
            print(self.latestCycleStartDate)
            print(patientPhysiologicalData)
            
            physiologicalPercentage = calculatePhysiologicalPercentage(from: patientPhysiologicalData)
            activityPercentage = calculateActivityPercentage(from: patientActivityData)
            sleepPercentage = calculateSleepScore(from: patientSleepData)
            moodPercentage = calculateMoodPercentage(from: patientMoodData)
        }
        catch {
            print(error)
        }
    }
}
