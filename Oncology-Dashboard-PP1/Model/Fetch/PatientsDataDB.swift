//
//  PatientsDataDB.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 10/6/2026.
//

import Foundation

func fetchPatientsData() async throws -> [Patient] {
    guard let url = URL(string: getApiUrl(endpoint: .getAllPatients)) else {
        return []
    }
    print(getApiUrl(endpoint: .getAllPatients))

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
        throw URLError(.badServerResponse)
    }

    let decodedDTOs = try JSONDecoder().decode([PatientDTO].self, from: data)

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    return decodedDTOs.map { dto in
        Patient(
            id: dto.id,
            urn: dto.urn,
            cancerType: dto.cancer_type,
            patientName: dto.name,
            treatmentStartDate: formatter.date(from: dto.treatment_start_date) ?? Date(),
            cycleCount: dto.cycle_count,
            cycleLengthInDays: dto.cycle_duration_days,
            sleepPercentage: dto.sleep_percentage,
            physiologicalPercentage: dto.physiological_percentage,
            patientReportedPercentage: dto.patient_reported_percentage,
            activityPercentage: dto.activity_percentage
        )
    }
}

func fetchTimelineEventsData(for patientId: Int) async throws -> [TimelineEvent] {
    guard let url = URL(
        string: getApiUrl(endpoint: .getPatientEvents(id: patientId))
    ) else {
        throw URLError(.badURL)
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
        throw URLError(.badServerResponse)
    }

    let decodedDTOs = try JSONDecoder().decode(
        [TimelineEventDTO].self,
        from: data
    )

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    return decodedDTOs.map { dto in
        TimelineEvent(
            id: dto.id,
            eventId: EventID(rawValue: dto.event_id) ?? .other,
            date: formatter.date(from: dto.event_date) ?? Date(),
            notes: dto.notes,
            doctorId: Int(dto.doctor_id) ?? 0,
            title: dto.title
        )
    }
}
