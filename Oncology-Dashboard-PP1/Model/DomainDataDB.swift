//
//  DomainData.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 21/5/2026.
//

import Foundation

struct PhysiologicalDomainDTO: Codable {
    let entryid: Int
    let userid: Int
    let date: String
    let type: String
    let value: Double
}

struct ActivityDomainDTO: Codable {
    let entryid: Int
    let userid: Int
    let date: String
    let type: String
    let value: Double
}



//    do {
//        let physiologicalData = try await fetchPhysiologicalData(for: patientId)
//    } catch {
//        print(error)
//    }
func fetchPhysiologicalData(for patientId: Int) async throws -> [PhysiologicalDomain] {
    
    
    guard let url = URL(string: "http://170.64.254.24:3001/api/patients/\(patientId)/physiological") else {
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
    
    
    guard let url = URL(string: "http://170.64.254.24:3001/api/patients/\(patientId)/activity") else {
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
