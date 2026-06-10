//
//  EmergencyDescriptionViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 17/5/2026.
//

import FoundationModels

func extractEmergencyDetails(from notes: String) async throws -> EmergencyEventDetails {
    let session = LanguageModelSession()

    let prompt = """
    Extract structured emergency presentation details from this clinical note.
    Return:
    - reasonForVisit
    - heartRate
    - bloodPressure
    - spo2
    - painScore
    - interventions
    - treatments
    Clinical note:
    \(notes)
    """

    let response = try await session.respond(to: prompt,generating: EmergencyEventDetails.self)
    return response.content
}
