//
//  MoodWholisticChartViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//

import Foundation
import Observation

struct MoodPoint: Identifiable {
    let id = UUID()
    let date: Date
    let mood: Int
}

@Observable
class MoodWholisticChartViewViewModel {

    var patientMoodData: [MoodDomain] = []

    var moodPoints: [MoodPoint] {
        patientMoodData
            .map { entry in
                MoodPoint(
                    date: entry.date,
                    mood: entry.mood
                )
            }
            .sorted { $0.date < $1.date }
    }

    func loadMoodData(patientId: Int) async {
        do {
            patientMoodData = try await fetchMoodData(for: patientId)
        } catch {
            print("Failed to fetch mood data:", error)
        }
    }
}
