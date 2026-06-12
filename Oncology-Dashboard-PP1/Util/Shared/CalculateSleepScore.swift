//
//  CalculateSleepScore.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 10/6/2026.
//

/*
 So it is important to note that we had to create a calculator for this given that Apple does not expose their sleep score calculations to us when exporting the data. Originally I left this uncommented but I think it'll be easier to explain in the code for Michael vs putting it in the report line by line. Also keeps the report cleaner.
 */

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

    // can't calculate a sleep score if they did not sleep
    guard totalInBedMinutes > 0 else { return 0 }

    // sleep efficiency is basically a measure of how much time spent in bed vs how much time was actually asleep
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

    // 8 hours is considered to be 100% here
    let durationScore = min(totalAsleepMinutes / 480, 1.0) * 100
    
    // anything above 90% is considered to be 100% here.
    let efficiencyScore = min(sleepEfficiency / 0.9, 1.0) * 100
    
    // Each time the pt wakes up at night their awakening score is penalised by 8 points
    let awakeningScore = max(100 - Double(awakeningCount * 8), 0)

    // looks funky but the check is just to avoid a divide by zero later on
    // basically calculating how much time was spent in each deep sleep phase
    let deepRatio = totalAsleepMinutes > 0 ? deepMinutes / totalAsleepMinutes : 0
    let remRatio = totalAsleepMinutes > 0 ? remMinutes / totalAsleepMinutes : 0

    // 15% of time spent asleep in deep sleep is considered to be 100%
    let deepScore = min(deepRatio / 0.15, 1.0) * 100
    
    // 20% of time spent asleep in REM sleep is considered to be 100%
    let remScore = min(remRatio / 0.20, 1.0) * 100
    
    // taking the average because they both contribute to the quality relatively equally
    let stageScore = (deepScore + remScore) / 2

    let finalScore =
        durationScore * 0.35 +
        efficiencyScore * 0.30 +
        awakeningScore * 0.20 +
        stageScore * 0.15

    return finalScore.rounded()
}
