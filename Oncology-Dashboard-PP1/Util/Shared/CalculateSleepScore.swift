//
//  CalculateSleepScore.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 10/6/2026.
//

import Foundation

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
