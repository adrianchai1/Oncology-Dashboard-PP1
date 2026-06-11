//
//  CalculateSleepScorePoints.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 10/6/2026.
//

import Foundation

func calculateSleepScorePoints(from sleepData: [SleepDomain]) -> [SleepScorePoint] {
    let groupedByDay = Dictionary(grouping: sleepData) {
        Calendar.current.startOfDay(for: $0.startDate)
    }

    return groupedByDay.map { date, entries in
        SleepScorePoint(
            date: date,
            score: calculateSleepScore(from: entries)
        )
    }
    .sorted { $0.date < $1.date }
}
