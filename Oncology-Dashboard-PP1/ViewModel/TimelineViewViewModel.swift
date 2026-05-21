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
    var patientTreatmentStartDate: Date
    var patientTreatmentEndDate: Date
    
    var patientPercentages: [PatientPercentages] = []
    
    init(patientTreatmentStartDate: Date, patientTreatmentEndDate: Date) {
        self.patientTreatmentStartDate = patientTreatmentStartDate
        self.patientTreatmentEndDate = patientTreatmentEndDate
    }
    
    private func getActivityPercentageDeviance(patientId: Int) async throws -> [MetricData] {
        let activityData = try await fetchActivityData(for: patientId)
        // Only use data after the start date
        let cycleActivityData = activityData.filter { $0.date >= self.patientTreatmentStartDate }
        // Group by the types
        
        let groupedActivityData = Dictionary(grouping: cycleActivityData) { $0.type }
            .sorted { $0.key < $1.key }
            .map { $0.value }
        
//                            print("Calculating day day variance for each type")
        var percentageDeviances: [[MetricData]] = []
        // Calculate the percentage deviance for each entry from the last
        for activityTypes in groupedActivityData {
//            print(activityTypes.first!.type)
            let metricData = activityTypes.map { entry in
                MetricData(date: entry.date, value: entry.value)
            } .sorted { $0.date < $1.date }
            let newMetricData = calculateDayByDayDomainDeviation(data: metricData)
            
//                                 Print for debugging
//            for i in newMetricData {
//                print("\(i.date) : \(i.deviationPercentage)")
//            }
//            print("---------")
            percentageDeviances.append(newMetricData)
        }
        
        let activityPercentageDeviance = calculateDomainPercentageDeviance(data: percentageDeviances, startDate: self.patientTreatmentStartDate, endDate: self.patientTreatmentEndDate)
        
        print("\nOVERALL PERCENTAGE DEVIANCE FROM BASELINE:")
        for i in activityPercentageDeviance {
            print("\(i.date) : \(i.deviationPercentage)")
        }
        
        return activityPercentageDeviance
    }
    
    private func getPhysiologicalPercentageDeviance(patientId: Int) async throws -> [MetricData] {
        let physiologicalData = try await fetchPhysiologicalData(for: patientId)
        // Only use data after the start date
        let cyclePhysiologicalData = physiologicalData.filter { $0.date >= self.patientTreatmentStartDate }
        // Group by the types
        
        let groupedPhysiologicalData = Dictionary(grouping: cyclePhysiologicalData) { $0.type }
            .sorted { $0.key < $1.key }
            .map { $0.value }
        
//                            print("Calculating day day variance for each type")
        var percentageDeviances: [[MetricData]] = []
        // Calculate the percentage deviance for each entry from the last
        for physiologicalTypes in groupedPhysiologicalData {
            print(physiologicalTypes.first!.type)
            let metricData = physiologicalTypes.map { entry in
                MetricData(date: entry.date, value: entry.value)
            } .sorted { $0.date < $1.date }
            let newMetricData = calculateDayByDayDomainDeviation(data: metricData)
                
            // Print for debugging
//            for i in newMetricData {
//                print("\(i.date) : \(i.deviationPercentage)")
//            }
//            print("---------")
            percentageDeviances.append(newMetricData)
        }
        
        let physiologicalPercentageDeviance = calculateDomainPercentageDeviance(data: percentageDeviances, startDate: self.patientTreatmentStartDate, endDate: self.patientTreatmentEndDate)
        
//        print("\nOVERALL PERCENTAGE DEVIANCE FROM BASELINE:")
//        for i in physiologicalPercentageDeviance {
//            print("\(i.date) : \(i.deviationPercentage)")
//        }
//        
        return physiologicalPercentageDeviance
        
    }

    func fetchPatientPercentages(for patientId: Int) {
        guard let url = URL(string: "http://170.64.254.24:3001/api/patients/\(patientId)/percentages") else {
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
                    print("Loaded percentages from db:", self.patientPercentages.count)
                    
                    Task {
                        do {
                            // Grab the data
                            let physiologicalDeviance = try await self.getPhysiologicalPercentageDeviance(patientId: patientId)
                            let activityDeviance = try await self.getActivityPercentageDeviance(patientId: patientId)
//                            let sleepDeviance = []
//                            let selfReportedDeviance = []
                            
                            let calendar = Calendar.current
                            var currentDate = self.patientTreatmentStartDate
                            
                            var patientPercentages: [PatientPercentages] = []
                            var idCount = 1
                            while currentDate <= self.patientTreatmentEndDate {
                                
                                let physiologicalPercentage = physiologicalDeviance.first {
                                    Calendar.current.isDate($0.date, inSameDayAs: currentDate)
                                }
                                let activityPercentage = activityDeviance.first {
                                    Calendar.current.isDate($0.date, inSameDayAs: currentDate)
                                }
//                                let sleepPercentage = sleepDeviance.filter { $0.date == currentDate }
//                                let selfReportedPercentage = selfReportedDeviance.filter { $0.date == currentDate }
                                
                                
                                patientPercentages.append(PatientPercentages(
                                    id: idCount,
                                    date: currentDate,
                                    patientId: patientId,
                                    physiological: physiologicalPercentage?.deviationPercentage,
                                    activity: activityPercentage?.deviationPercentage,
                                    sleep: nil,
                                    selfReported: nil
                                ))
                                
                                idCount += 1

                                guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                                    break
                                }

                                currentDate = nextDate
                            }
                            
                            // Update patient percentages
                            // TODO: UPDATE TO NOT OVERRIDE BBUT ADD NEW ENTRIES AND SAVE TO DB
                            // TODO: THIS IS TEMPORARY!
//                            let mappedPercentages = physiologicalDeviance.enumerated().map { index, physiologicalDeviance in
//                                PatientPercentages(
//                                    id: index,
//                                    date: physiologicalDeviance.date,
//                                    patientId: 1,
//                                    physiological: physiologicalDeviance.deviationPercentage,
//                                    activity: nil,
//                                    sleep: nil,
//                                    selfReported: nil
//                                )
//                            }
                            self.patientPercentages = patientPercentages
                            for i in self.patientPercentages {
                                print(i)
                            }
                            print("Calculated percentages from db:", self.patientPercentages.count)
                            
                        } catch {
                            print(error)
                        }
                    }
                }

            } catch {
                print("Event decoding error:", error)
            }
        }.resume()
    }
}

