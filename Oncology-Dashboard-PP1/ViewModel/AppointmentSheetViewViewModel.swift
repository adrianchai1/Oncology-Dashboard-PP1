//
//  AppointmentSheetViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 17/5/2026.
//

import FoundationModels

func extractApptDetails(from notes: String) async throws -> AppointmentSummary {
    let session = LanguageModelSession()
    let prompt = """
    Extract structured oncology appointment details from this clinical note.
    Return:
    - plan
    - followUp
    - keyFindings as a dynamic list of title/value pairs
    Include clinically relevant findings such as symptoms, side effects, treatment cycle, performance status, blood results, examination findings, medication changes, and treatment tolerance if present.
    Clinical note:
    \(notes)
    """
    
    let response = try await session.respond(to: prompt, generating: AppointmentSummary.self)
    return response.content
}
