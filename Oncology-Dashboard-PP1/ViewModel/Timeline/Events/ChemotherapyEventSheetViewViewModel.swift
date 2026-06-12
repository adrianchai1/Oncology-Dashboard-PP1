//
//  ChemotherapyEventSheetViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 17/5/2026.
//

import Foundation
import FoundationModels
import Observation

struct ChemotherapyEventDTO: Codable {
    let chemo_event_id: Int
    let timeline_event_id: Int
    let drug_type: String
    let dosage: String
    let route: String
    let duration_hours: Double
    let location: String
}

@Observable
class ChemotherapyEventsViewModel {
    var chemotherapyEvents: [ChemotherapyEvent] = []
    func fetchChemotherapyEvents(for patientId: Int) {
        guard let url = URL(string: getApiUrl(endpoint: .getPatientChemotherapyEvents(id: patientId))) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("Chemo fetch error:", error)
                return
            }

            guard let data else {
                print("No chemo event data")
                return
            }

            do {
                let decodedDTOs = try JSONDecoder().decode([ChemotherapyEventDTO].self, from: data)
                let mappedEvents = decodedDTOs.map { dto in
                    ChemotherapyEvent(
                        id: dto.chemo_event_id,
                        timelineEventId: dto.timeline_event_id,
                        drugType: dto.drug_type,
                        dosage: dto.dosage,
                        route: dto.route,
                        durationHours: dto.duration_hours,
                        location: dto.location
                    )
                }

                DispatchQueue.main.async {
                    self.chemotherapyEvents = mappedEvents
                    print("Loaded chemo events:", self.chemotherapyEvents.count)
                }
            } catch {
                print("Chemo decoding error:", error)
            }

        }.resume()

    }

}

func extractChemoDetails(from notes: String) async throws -> ChemoSummary {
    let session = LanguageModelSession()

    let prompt = """
    Extract structured chemotherapy details from this clinical note.
    Return:
    - Nausea level either: None, Mild, Severe or if severity not indicated but nausea mentioned, Present. If not mentioned then call it Not Present
    - Fatigue level either: None, Mild, Severe or if severity not indicated but fatigue mentioned, Present. If not mentioned then call it Not Present
    Clinical note:
    \(notes)
    """

    let response = try await session.respond(to: prompt,generating: ChemoSummary.self)
    return response.content
}
