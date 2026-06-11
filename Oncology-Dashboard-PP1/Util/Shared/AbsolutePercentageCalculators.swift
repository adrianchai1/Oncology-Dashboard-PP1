//
//  AbsolutePercentageCalculators.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 9/6/2026.
//

import Foundation

// below is physiological, also note perhaps we should split these up?

func calculatePhysiologicalPercentage(from data: [PhysiologicalDomain]) -> Double {
    guard !data.isEmpty else { return 0 }

    let groupedByType = Dictionary(grouping: data) { $0.type }

    func average(for type: String) -> Double? {
        guard let entries = groupedByType[type], !entries.isEmpty else { return nil }
        let total = entries.reduce(0.0) { $0 + $1.value }
        return total / Double(entries.count)
    }

    var scores: [(score: Double, weight: Double)] = []

    if let hrv = average(for: "HKQuantityTypeIdentifierHeartRateVariabilitySDNN") {
        scores.append((hrvScore(hrv), 0.25))
    }

    if let restingHR = average(for: "HKQuantityTypeIdentifierRestingHeartRate") {
        scores.append((restingHeartRateScore(restingHR), 0.25))
    }

    if let oxygen = average(for: "HKQuantityTypeIdentifierOxygenSaturation") {
        scores.append((oxygenSaturationScore(oxygen), 0.20))
    }

    if let respiratoryRate = average(for: "HKQuantityTypeIdentifierRespiratoryRate") {
        scores.append((respiratoryRateScore(respiratoryRate), 0.20))
    }

    if let walkingHR = average(for: "HKQuantityTypeIdentifierWalkingHeartRateAverage") {
        scores.append((walkingHeartRateScore(walkingHR), 0.10))
    }

    guard !scores.isEmpty else { return 0 }

    let weightedTotal = scores.reduce(0.0) { $0 + ($1.score * $1.weight) }
    let totalWeight = scores.reduce(0.0) { $0 + $1.weight }

    return (weightedTotal / totalWeight).rounded()
}

private func hrvScore(_ hrv: Double) -> Double {
    clamp((hrv / 100.0) * 100)
}

private func restingHeartRateScore(_ bpm: Double) -> Double {
    switch bpm {
    case ..<50: return 70
    case 50..<60: return 100
    case 60..<70: return 95
    case 70..<80: return 85
    case 80..<90: return 70
    case 90...100: return 50
    default: return 25
    }
}

private func oxygenSaturationScore(_ oxygen: Double) -> Double {
    let spo2 = oxygen <= 1.0 ? oxygen * 100 : oxygen

    switch spo2 {
    case 98...100: return 100
    case 96..<98: return 85
    case 94..<96: return 65
    case 92..<94: return 40
    default: return 20
    }
}

private func respiratoryRateScore(_ rate: Double) -> Double {
    switch rate {
    case 12...20:
        return 100
    case 10..<12, 20..<24:
        return 75
    case 8..<10, 24..<28:
        return 50
    default:
        return 25
    }
}

private func walkingHeartRateScore(_ bpm: Double) -> Double {
    switch bpm {
    case ..<80: return 100
    case 80..<95: return 90
    case 95..<110: return 75
    case 110..<125: return 55
    case 125..<140: return 35
    default: return 20
    }
}

private func clamp(_ value: Double) -> Double {
    min(max(value, 0), 100)
}

// below is activity

func calculateActivityPercentage(from data: [ActivityDomain]) -> Double {
    guard !data.isEmpty else { return 0 }

    let groupedByType = Dictionary(grouping: data) { $0.type }

    func average(for type: String) -> Double? {
        guard let entries = groupedByType[type], !entries.isEmpty else {
            return nil
        }

        let total = entries.reduce(0.0) { $0 + $1.value }
        return total / Double(entries.count)
    }

    var scores: [(score: Double, weight: Double)] = []

    if let steps = average(for: "HKQuantityTypeIdentifierStepCount") {
        scores.append((stepCountScore(steps), 0.35))
    }

    if let exercise = average(for: "HKQuantityTypeIdentifierAppleExerciseTime") {
        scores.append((exerciseTimeScore(exercise), 0.25))
    }

    if let distance = average(for: "HKQuantityTypeIdentifierDistanceWalkingRunning") {
        scores.append((distanceScore(distance), 0.15))
    }

    if let flights = average(for: "HKQuantityTypeIdentifierFlightsClimbed") {
        scores.append((flightsClimbedScore(flights), 0.10))
    }

    if let energy = average(for: "HKQuantityTypeIdentifierActiveEnergyBurned") {
        scores.append((activeEnergyScore(energy), 0.10))
    }

    if let speed = average(for: "HKQuantityTypeIdentifierWalkingSpeed") {
        scores.append((walkingSpeedScore(speed), 0.05))
    }

    guard !scores.isEmpty else { return 0 }

    let weightedTotal = scores.reduce(0.0) { $0 + ($1.score * $1.weight) }
    let totalWeight = scores.reduce(0.0) { $0 + $1.weight }

    return (weightedTotal / totalWeight).rounded()
}

private func stepCountScore(_ steps: Double) -> Double {
    clamp((steps / 10000.0) * 100)
}

private func exerciseTimeScore(_ minutes: Double) -> Double {
    clamp((minutes / 30.0) * 100)
}

private func distanceScore(_ metres: Double) -> Double {
    clamp((metres / 8000.0) * 100)
}

private func flightsClimbedScore(_ flights: Double) -> Double {
    clamp((flights / 10.0) * 100)
}

private func activeEnergyScore(_ kcal: Double) -> Double {
    clamp((kcal / 500.0) * 100)
}

private func walkingSpeedScore(_ metresPerSecond: Double) -> Double {
    clamp((metresPerSecond / 1.4) * 100)
}

func calculateSleepPercentage(from data: [SleepDomain]) -> Double {
    guard !data.isEmpty else { return 0 }
    
    let sleepScorePoints = calculateSleepScorePoints(from: data)
    
    let total = sleepScorePoints.reduce(0.0) { $0 + $1.score }
    return (total / Double(sleepScorePoints.count)).rounded()
    
}


func calculateMoodPercentage(from moodData: [MoodDomain]) -> Double {
    guard !moodData.isEmpty else { return 0 }
    
    let total = moodData.reduce(0) { $0 + $1.mood }
    return (Double(total) / Double(moodData.count)).rounded()
}
