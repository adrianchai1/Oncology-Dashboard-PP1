//
//  RadarGraphViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//

import Foundation
import Observation

@Observable
class RadarGraphViewViewModel {

    var patientSleepData: [SleepDomain] = []
    var patientPhysiologicalData: [PhysiologicalDomain] = []
    var patientActivityData: [ActivityDomain] = []
    var patientMoodData: [MoodDomain] = []

    var sleepScorePoints: [SleepScorePoint] {
        calculateSleepScorePoints(from: patientSleepData)
    }

    func loadSleepData(patientId: Int) async {
        do {
            patientSleepData = try await fetchSleepData(for: patientId)
        } catch {
            print("Failed to fetch sleep data:", error)
        }
    }
    
    func loadPhysiologicalData(patientId: Int) async {
        do {
            patientPhysiologicalData = try await fetchPhysiologicalData(for: patientId)
        } catch {
            print("Failed to fetch physiological data:", error)
        }
    }
    
    func loadActivityData(patientId: Int) async {
        do {
            patientActivityData = try await fetchActivityData(for: patientId)
        } catch {
            print("Failed to fetch activity data:", error)
        }
    }
    
    func loadMoodData(patientId: Int) async {
        do {
            patientMoodData = try await fetchMoodData(for: patientId)
        } catch {
            print("Failed to fetch activity data:", error)
        }
    }
    
    private func getAveragePhysiological(from cycleStart: Date, to cycleEnd: Date) -> Double {
        let physiologicalDataInCycle = patientPhysiologicalData.filter { item in
            item.date >= cycleStart && item.date < cycleEnd
        }

        return calculatePhysiologicalPercentage(from: physiologicalDataInCycle)
    }
    
    private func getAverageActivity(from cycleStart: Date, to cycleEnd: Date) -> Double {

        let activityDataInCycle = patientActivityData.filter {
            $0.date >= cycleStart && $0.date < cycleEnd
        }

        return calculateActivityPercentage(from: activityDataInCycle)
    }
    
    private func getAverageSleepScore(from cycleStart: Date, to cycleEnd: Date) -> Double {
        let scoresInCycle = sleepScorePoints.filter { point in
            point.date >= cycleStart && point.date < cycleEnd
        }

        guard !scoresInCycle.isEmpty else { return 0 }

        let total = scoresInCycle.reduce(0.0) { $0 + $1.score }
        return total / Double(scoresInCycle.count)
    }
    
    private func getAverageSelfReported(from cycleStart: Date, to cycleEnd: Date) -> Double {
        let moodDataInCycle = patientMoodData.filter {
            $0.date >= cycleStart && $0.date < cycleEnd
        }

        guard !moodDataInCycle.isEmpty else { return 0 }

        let total = moodDataInCycle.reduce(0.0) {
            $0 + Double($1.mood)
        }

        let averageMood = total / Double(moodDataInCycle.count)

        return (averageMood / 10.0) * 100
    }

    func getLatestThreeCycleRadarData(latestCycle: Int, treatmentStartDate: Date, cycleDurationDays: Int = 14) -> [RadarCycleData] {
        let firstCycleToShow = max(1, latestCycle - 2)
        let cyclesToShow = Array(firstCycleToShow...latestCycle)

        return cyclesToShow.map { cycleNumber in
            let cycleStart = Calendar.current.date(byAdding: .day, value: (cycleNumber - 1) * cycleDurationDays, to: treatmentStartDate)!

            let cycleEnd = Calendar.current.date(byAdding: .day, value: cycleDurationDays, to: cycleStart)!

            return RadarCycleData(
                cycleNumber: cycleNumber,
                sleep: getAverageSleepScore(from: cycleStart, to: cycleEnd),
                physiological: getAveragePhysiological(from: cycleStart, to: cycleEnd),
                activity: getAverageActivity(from: cycleStart, to: cycleEnd),
                selfReported: getAverageSelfReported(from: cycleStart, to: cycleEnd)
            )
        }
    }
}
