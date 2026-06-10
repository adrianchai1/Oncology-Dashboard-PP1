//
//  RadarGraphViewViewModel.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//

import Foundation
import Observation

struct RadarCycleData: Identifiable {
    let id = UUID()
    let cycleNumber: Int
    let sleep: Double
    let physiological: Double
    let activity: Double
    let selfReported: Double
}

@Observable
class RadarGraphViewViewModel {

    var patientSleepData: [SleepDomain] = []
    var patientPhysiologicalData: [PhysiologicalDomain] = []
    var patientActivityData: [ActivityDomain] = []

    var sleepScorePoints: [SleepScorePoint] {
        let groupedByDay = Dictionary(grouping: patientSleepData) { sleep in
            Calendar.current.startOfDay(for: sleep.startDate)
        }

        return groupedByDay.map { date, sleepEntries in
            SleepScorePoint(
                date: date,
                score: calculateSleepScore(from: sleepEntries)
            )
        }
        .sorted { $0.date < $1.date }
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
    
    private func getAveragePhysiological(
        from cycleStart: Date,
        to cycleEnd: Date
    ) -> Double {
        let physiologicalDataInCycle = patientPhysiologicalData.filter { item in
            item.date >= cycleStart && item.date < cycleEnd
        }

        return calculatePhysiologicalPercentage(from: physiologicalDataInCycle)
    }
    
    private func getAverageActivity(
        from cycleStart: Date,
        to cycleEnd: Date
    ) -> Double {

        let activityDataInCycle = patientActivityData.filter {
            $0.date >= cycleStart && $0.date < cycleEnd
        }

        return calculateActivityPercentage(from: activityDataInCycle)
    }

    func getLatestThreeCycleRadarData(
        latestCycle: Int,
        treatmentStartDate: Date,
        cycleDurationDays: Int = 14
    ) -> [RadarCycleData] {

        let firstCycleToShow = max(1, latestCycle - 2)
        let cyclesToShow = Array(firstCycleToShow...latestCycle)

        return cyclesToShow.map { cycleNumber in
            let cycleStart = Calendar.current.date(
                byAdding: .day,
                value: (cycleNumber - 1) * cycleDurationDays,
                to: treatmentStartDate
            )!

            let cycleEnd = Calendar.current.date(
                byAdding: .day,
                value: cycleDurationDays,
                to: cycleStart
            )!

            return RadarCycleData(
                cycleNumber: cycleNumber,
                sleep: getAverageSleepScore(from: cycleStart,to: cycleEnd),
                physiological: getAveragePhysiological(from: cycleStart, to: cycleEnd),
                activity: getAverageActivity(from: cycleStart, to: cycleEnd),
                selfReported: 80
            )
        }
    }

    private func getAverageSleepScore(
        from cycleStart: Date,
        to cycleEnd: Date
    ) -> Double {

        let scoresInCycle = sleepScorePoints.filter { point in
            point.date >= cycleStart && point.date < cycleEnd
        }

        guard !scoresInCycle.isEmpty else { return 0 }

        let total = scoresInCycle.reduce(0.0) { $0 + $1.score }
        return total / Double(scoresInCycle.count)
    }

    func calculateSleepScore(from sleepData: [SleepDomain]) -> Double {
        guard !sleepData.isEmpty else { return 0 }

        let asleepStates = sleepData.filter {
            $0.state.contains("Asleep")
        }

        let awakeStates = sleepData.filter {
            $0.state.contains("Awake")
        }

        let totalAsleepMinutes = asleepStates.reduce(0.0) { total, item in
            total + item.endDate.timeIntervalSince(item.startDate) / 60
        }

        let totalAwakeMinutes = awakeStates.reduce(0.0) { total, item in
            total + item.endDate.timeIntervalSince(item.startDate) / 60
        }

        let totalInBedMinutes = totalAsleepMinutes + totalAwakeMinutes

        guard totalInBedMinutes > 0 else { return 0 }

        let sleepEfficiency = totalAsleepMinutes / totalInBedMinutes
        let awakeningCount = awakeStates.count

        let deepMinutes = sleepData
            .filter { $0.state.contains("Deep") }
            .reduce(0.0) {
                $0 + $1.endDate.timeIntervalSince($1.startDate) / 60
            }

        let remMinutes = sleepData
            .filter { $0.state.contains("REM") }
            .reduce(0.0) {
                $0 + $1.endDate.timeIntervalSince($1.startDate) / 60
            }

        let durationScore = min(totalAsleepMinutes / 480, 1.0) * 100
        let efficiencyScore = min(sleepEfficiency / 0.9, 1.0) * 100
        let awakeningScore = max(100 - Double(awakeningCount * 8), 0)

        let deepRatio = totalAsleepMinutes > 0 ? deepMinutes / totalAsleepMinutes : 0
        let remRatio = totalAsleepMinutes > 0 ? remMinutes / totalAsleepMinutes : 0

        let deepScore = min(deepRatio / 0.15, 1.0) * 100
        let remScore = min(remRatio / 0.20, 1.0) * 100
        let stageScore = (deepScore + remScore) / 2

        let finalScore =
            durationScore * 0.35 +
            efficiencyScore * 0.30 +
            awakeningScore * 0.20 +
            stageScore * 0.15

        return finalScore.rounded()
    }
}
