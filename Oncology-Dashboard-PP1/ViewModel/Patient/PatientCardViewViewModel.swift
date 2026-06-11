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
    
    private var patientSleepData: [SleepDomain] = []
    private var patientActivityData: [ActivityDomain] = []
    private var patientMoodData: [MoodDomain] = []
    private var patientPhysiologicalData: [PhysiologicalDomain] = []
    
    func loadPercentages(patientId: Int) async {
        do {
            patientMoodData = try await fetchMoodData(for: patientId)
            patientSleepData = try await fetchSleepData(for: patientId)
            patientActivityData = try await fetchActivityData(for: patientId)
            patientPhysiologicalData = try await fetchPhysiologicalData(for: patientId)
            
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
