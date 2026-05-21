//
//  TimelineViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 21/5/2026.
//

import Foundation
import Observation

struct PatientPercentagesDTO: Codable {
    let percentage_id: Int
    var entry_date: String
    var patient_id: Int
    var physiological: Double?
    var activity: Double?
    var sleep: Double?
    var self_reported: Double?
}


@Observable
class TimelineViewViewModel {
    var patientPercentages: [PatientPercentages] = []

    func fetchPatientPercentages(for patientId: Int) {
        guard let url = URL(string: "http://170.64.254.24:3001/api/patients/\(patientId)/percentages") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            print("Getting patient percentages")
            if let error = error {
                print("Event fetch error:", error)
                return
            }

            guard let data = data else {
                print("No event data")
                return
            }

            do {
                let decodedDTOs = try JSONDecoder().decode([PatientPercentagesDTO].self, from: data)

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"

                let mappedPercentages = decodedDTOs.map { dto in
                    PatientPercentages(
                        id: dto.percentage_id,
                        date: formatter.date(from: dto.entry_date) ?? Date(),
                        patientId: dto.patient_id,
                        physiological: dto.physiological,
                        activity: dto.activity,
                        sleep: dto.sleep,
                        selfReported: dto.self_reported
                    )
                }

                DispatchQueue.main.async {
                    self.patientPercentages = mappedPercentages
                    print("Loaded percentages:", self.patientPercentages.count)
                }

            } catch {
                print("Event decoding error:", error)
            }
        }.resume()
    }
}

