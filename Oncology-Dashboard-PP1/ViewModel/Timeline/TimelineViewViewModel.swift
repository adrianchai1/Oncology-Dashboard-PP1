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
        
        
        var percentageDeviances: [[MetricData]] = []
        // Calculate the percentage deviance for each type in the domain
        for activityTypes in groupedActivityData {
            
            // Convert the Domain Data into Metric Data for the functions
            let metricData = activityTypes.map { entry in
                MetricData(date: entry.date, value: entry.value)
            } .sorted { $0.date < $1.date }
            
            // Get the day by day domain deviation
            let newMetricData = calculateDayByDayDomainDeviation(data: metricData)
            percentageDeviances.append(newMetricData)
        }
        
        let activityPercentageDeviance = calculateDomainPercentageDeviance(data: percentageDeviances, startDate: self.patientTreatmentStartDate, endDate: self.patientTreatmentEndDate)
        
        return activityPercentageDeviance
    }
    
    private func getSleepPercentageDeviance(patientId: Int) async throws -> [MetricData] {
        let sleepData = try await fetchSleepData(for: patientId)
        
        // Only use data after the start date
        let cycleActivityData = sleepData.filter { $0.startDate >= self.patientTreatmentStartDate }
        
        // Group by the types
        let groupedByState = Dictionary(grouping: cycleActivityData) { $0.state }
                .sorted { $0.key < $1.key }

        var percentageDeviances: [[MetricData]] = []

        for (_, entries) in groupedByState {
            // Group entries by day
            let groupedByDay = Dictionary(grouping: entries) { entry -> Date in
                Calendar.current.startOfDay(for: entry.startDate)
            }

            // Sum duration in minutes per day
            let metricData = groupedByDay.map { (day, dayEntries) -> MetricData in
                let totalMinutes = dayEntries.reduce(0.0) { sum, entry in
                    sum + entry.endDate.timeIntervalSince(entry.startDate) / 60.0
                }
                return MetricData(date: day, value: totalMinutes)
            }
            .sorted { $0.date < $1.date }

            let newMetricData = calculateDayByDayDomainDeviation(data: metricData)
            percentageDeviances.append(newMetricData)
        }

        let sleepPercentageDeviance = calculateDomainPercentageDeviance(
            data: percentageDeviances,
            startDate: self.patientTreatmentStartDate,
            endDate: self.patientTreatmentEndDate
        )

        return sleepPercentageDeviance
    }
    
    private func getPhysiologicalPercentageDeviance(patientId: Int) async throws -> [MetricData] {
        let physiologicalData = try await fetchPhysiologicalData(for: patientId)
        
        // Only use data after the start date
        let cyclePhysiologicalData = physiologicalData.filter { $0.date >= self.patientTreatmentStartDate }
        
        // Group by the types
        let groupedPhysiologicalData = Dictionary(grouping: cyclePhysiologicalData) { $0.type }
            .sorted { $0.key < $1.key }
            .map { $0.value }
        
        
        var percentageDeviances: [[MetricData]] = []
        
        // Calculate the percentage deviance for each type in the domain
        for physiologicalTypes in groupedPhysiologicalData {
            // Convert the Domain Data into Metric Data for the functions
            let metricData = physiologicalTypes.map { entry in
                MetricData(date: entry.date, value: entry.value)
            } .sorted { $0.date < $1.date }
            
            // Get the day by day domain deviation
            let newMetricData = calculateDayByDayDomainDeviation(data: metricData)
            
            // Append to the list
            percentageDeviances.append(newMetricData)
        }
        
        // use the function to calculate the domain percentage deviance each day
        // based on the deviance of all entries on the same day
        let physiologicalPercentageDeviance = calculateDomainPercentageDeviance(data: percentageDeviances, startDate: self.patientTreatmentStartDate, endDate: self.patientTreatmentEndDate)
        
        
        return physiologicalPercentageDeviance
    }
    
    private func getMoodPercentageDeviance(patientId: Int) async throws -> [MetricData] {
        let moodData = try await fetchMoodData(for: patientId)
        
        // Only use data after the start date
        let cycleMoodData = moodData.filter { $0.date >= self.patientTreatmentStartDate }
        
        let metricData = cycleMoodData.map { entry in
            MetricData(date: entry.date, value: Double(entry.mood))
        } .sorted { $0.date < $1.date }

        // Get the day by day domain deviation
        let moodDayByDayDeviance = calculateDayByDayDomainDeviation(data: metricData)
        return moodDayByDayDeviance
    }
    
    private func calculatePatientPercentages(patientId: Int) async throws -> [PatientPercentages] {
        let physiologicalDeviance = try await self.getPhysiologicalPercentageDeviance(patientId: patientId)
        let activityDeviance = try await self.getActivityPercentageDeviance(patientId: patientId)
        let sleepDeviance = try await self.getSleepPercentageDeviance(patientId: patientId)
        let moodDeviance = try await self.getMoodPercentageDeviance(patientId: patientId)
        
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
            
            let sleepPercentage = sleepDeviance.first {
                Calendar.current.isDate($0.date, inSameDayAs: currentDate)
            }
            let moodPercentage = moodDeviance.first {
                Calendar.current.isDate($0.date, inSameDayAs: currentDate)
            }
            
            
            patientPercentages.append(PatientPercentages(
                id: idCount,
                date: currentDate,
                patientId: patientId,
                physiological: physiologicalPercentage?.deviationPercentage,
                activity: activityPercentage?.deviationPercentage,
                sleep: sleepPercentage?.deviationPercentage,
                selfReported: moodPercentage?.deviationPercentage
            ))
            
            idCount += 1

            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }

            currentDate = nextDate
        }
        
        return patientPercentages
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
                            
                            // Update patient percentages
                            // TODO: MAKE THIS NOT OVERRIDE -> INSTEAD ADD NEW ENTRIES AND SAVE TO DB
                            // TODO: THIS IS TEMPORARY!
                            self.patientPercentages = try await self.calculatePatientPercentages(patientId: patientId)
//                            for i in self.patientPercentages {
//                                print(i)
//                            }
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

