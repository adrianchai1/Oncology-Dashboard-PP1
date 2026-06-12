//
//  DomainData.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 21/5/2026.
//

import Foundation


//    do {
//        let physiologicalData = try await fetchPhysiologicalData(for: patientId)
//    } catch {
//        print(error)
//    }
func fetchPhysiologicalData(for patientId: Int) async throws -> [PhysiologicalDomain] {
    guard let url = URL(string: getApiUrl(endpoint: .getPatientPhysiologicalData(id: patientId))) else {
        return []
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decodedDTOs = try JSONDecoder().decode([PhysiologicalDomainDTO].self, from: data)

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    let mappedPhysiologicalDomain = decodedDTOs.map { dto in
        PhysiologicalDomain(
            id: dto.entryid,
            userId: dto.userid,
            date: formatter.date(from: dto.date) ?? Date(),
            type: dto.type,
            value: dto.value
        )
    }
    
    return mappedPhysiologicalDomain

}

func fetchActivityData(for patientId: Int) async throws -> [ActivityDomain] {
    guard let url = URL(string: getApiUrl(endpoint: .getPatientActivityData(id: patientId))) else {
        return []
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decodedDTOs = try JSONDecoder().decode([ActivityDomainDTO].self, from: data)

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    let mappedPhysiologicalDomain = decodedDTOs.map { dto in
        ActivityDomain(
            id: dto.entryid,
            userId: dto.userid,
            date: formatter.date(from: dto.date) ?? Date(),
            type: dto.type,
            value: dto.value
        )
    }
    
    return mappedPhysiologicalDomain

}

func fetchSleepData(for patientId: Int) async throws -> [SleepDomain] {
    guard let url = URL(string: getApiUrl(endpoint: .getPatientSleepData(id: patientId))) else {
        return []
    }

    let (data, _) = try await URLSession.shared.data(from: url)

    let decodedDTOs = try JSONDecoder().decode([SleepDomainDTO].self, from: data)

    let formatter = DateFormatter()
    formatter.dateFormat = "d/M/yyyy HH:mm"

    let mappedSleepDomain = decodedDTOs.map { dto in
        let startDate = formatter.date(from: "\(dto.start_date) \(dto.start_time)") ?? Date()
        let endDate = formatter.date(from: "\(dto.end_date) \(dto.end_time)") ?? Date()

        return SleepDomain(
            id: dto.entryid,
            userId: dto.userid,
            type: dto.type,
            state: dto.state,
            startDate: startDate,
            endDate: endDate
        )
    }
    return mappedSleepDomain
}



func fetchMoodData(for patientId: Int) async throws -> [MoodDomain] {
    print(getApiUrl(endpoint: .getPatientMoodData(id: patientId)))
    guard let url = URL(string: getApiUrl(endpoint: .getPatientMoodData(id: patientId))) else {
        return []
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    let decodedDTOs = try JSONDecoder().decode([MoodDomainDTO].self, from: data)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let mappedMoodDomain = decodedDTOs.map { dto in
        MoodDomain(
            id: dto.entryid,
            userId: dto.userid,
            date: formatter.date(from: dto.entry_date) ?? Date(),
            mood: dto.mood
        )
    }
    return mappedMoodDomain
}
