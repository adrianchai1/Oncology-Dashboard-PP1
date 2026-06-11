//
//  PatientSheetViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 17/5/2026.
//

import Foundation
import Observation

@MainActor
@Observable
class PatientSheetViewViewModel {
    var timelineEvents: [TimelineEvent] = []
    var errorMessage: String?

    func loadEvents(for patientId: Int) async {
        do {
            timelineEvents = try await fetchTimelineEventsData(for: patientId)
            errorMessage = nil

            print("Loaded events:", timelineEvents.count)
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to load events:", error)
        }
    }
}

