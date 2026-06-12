//
//  API.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 12/6/2026.
//

let API_URL = "http://170.64.254.24:3001/api"

enum APIEndpoints {
    case getAllPatients
    case getPatient(id: Int)
    case getPatientEvents(id: Int)
    case getPatientChemotherapyEvents(id: Int)
    case getPatientPercentages(id: Int)
    case getPatientSleepData(id: Int)
    case getPatientMoodData(id: Int)
    case getPatientActivityData(id: Int)
    case getPatientPhysiologicalData(id: Int)
}


func getApiUrl(endpoint: APIEndpoints) -> String {
    switch endpoint {
    case .getAllPatients:
        return "\(API_URL)/patients"
    case .getPatient(let id):
        return "\(API_URL)/patients/\(id)"
    case .getPatientEvents(let id):
        return "\(API_URL)/patients/\(id)/events"
    case .getPatientChemotherapyEvents(let id):
        return "\(API_URL)/patients/\(id)/events/chemotherapy"
    case .getPatientPercentages(let id):
        return "\(API_URL)/patients/\(id)/percentages"
    case .getPatientSleepData(let id):
        return "\(API_URL)/patients/\(id)/sleep"
    case .getPatientMoodData(let id):
        return "\(API_URL)/patients/\(id)/selfreported"
    case .getPatientActivityData(let id):
        return "\(API_URL)/patients/\(id)/activity"
    case .getPatientPhysiologicalData(let id):
        return "\(API_URL)/patients/\(id)/physiological"
    }
}
