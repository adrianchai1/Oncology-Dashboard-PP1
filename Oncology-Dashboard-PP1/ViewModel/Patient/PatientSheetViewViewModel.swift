//
//  PatientSheetViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 17/5/2026.
//

import Foundation
import Observation

@Observable
class PatientSheetViewViewModel {
    var timelineEvents: [TimelineEvent] = []

    func fetchEvents(for patientId: Int) {
        guard let url = URL(string: "http://170.64.254.24:3001/api/patients/\(patientId)/events") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Event fetch error:", error)
                return
            }

            guard let data = data else {
                print("No event data")
                return
            }

            do {
                let decodedDTOs = try JSONDecoder().decode([TimelineEventDTO].self, from: data)

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"

                let mappedEvents = decodedDTOs.map { dto in
                    TimelineEvent(
                        id: dto.id,
                        eventId: EventID(rawValue: dto.event_id) ?? .other,
                        date: formatter.date(from: dto.event_date) ?? Date(),
                        notes: dto.notes,
                        doctorId: Int(dto.doctor_id) ?? 0,
                        title: dto.title
                    )
                }

                DispatchQueue.main.async {
                    self.timelineEvents = mappedEvents
                    print("Loaded events:", self.timelineEvents.count)
                }

            } catch {
                print("Event decoding error:", error)
            }
        }.resume()
    }
}

