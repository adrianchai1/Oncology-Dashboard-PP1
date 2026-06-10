//
//  SleepWholisticChartViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 3/6/2026.
//

import Foundation

@Observable
class SleepWholisticChartViewViewModel {
    var patientSleepData: [SleepDomain] = []
    
    var sleepScorePoints: [SleepScorePoint] {
        calculateSleepScorePoints(from: patientSleepData)
    }

    func loadSleepData(patientId: Int) async {
        do {
            patientSleepData = try await fetchSleepData(for: patientId)
        } catch {
            print("Failed to fetch sleep data:", error)
        }
    }
}
