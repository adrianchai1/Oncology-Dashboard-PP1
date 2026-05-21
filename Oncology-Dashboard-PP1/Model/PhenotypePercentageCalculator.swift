//
//  PhenotypePercentageCalculator.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 18/5/2026.
//

import Foundation

struct MetricData {
    let date: Date
    let value: Double
    var deviationPercentage: Double = 0.0
}



private let calendar = Calendar.current

let testMetricData: [MetricData] = [
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 1))!, value: 102),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 2))!, value: 98),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 3))!, value: 105),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 4))!, value: 110),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 5))!, value: 108),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 6))!, value: 115),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 7))!, value: 117),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 8))!, value: 120),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 9))!, value: 119),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 10))!, value: 123),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 11))!, value: 125),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 12))!, value: 130),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 13))!, value: 128),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 14))!, value: 132),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 15))!, value: 135),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 16))!, value: 137),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 17))!, value: 140),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 18))!, value: 142),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 19))!, value: 145),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 20))!, value: 147),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 21))!, value: 150),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 22))!, value: 149),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 23))!, value: 153),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 24))!, value: 156),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 25))!, value: 158),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 26))!, value: 160),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 27))!, value: 162),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 28))!, value: 165),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 29))!, value: 162),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 4, day: 30))!, value: 160),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 1))!, value: 158),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 2))!, value: 157),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 3))!, value: 155),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 4))!, value: 153),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 5))!, value: 150),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 6))!, value: 146),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 7))!, value: 145),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 8))!, value: 146),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 9))!, value: 142),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 10))!, value: 139),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 11))!, value: 138),
    MetricData(date: calendar.date(from: DateComponents(year: 2026, month: 5, day: 12))!, value: 138)
]

private let cycleStartDate = calendar.date(
    from: DateComponents(year: 2026, month: 4, day: 1)
)!

private let cycleDurationDays = 14

private func calculatePercentageDifference(currAvg: Double, prevAvg: Double) -> Double {
    // Returns a percentage
    
    
    return ((currAvg - prevAvg) / prevAvg) * 100
}

func calculateMetricDataAverage(data: [MetricData], usePercentage: Bool = false) -> Double {
    if data.isEmpty {
        return 0.0
    }
    var sum = 0.0
    for metricData in data {
        if usePercentage {
            sum += metricData.deviationPercentage
        }
        else {
            sum += metricData.value
        }
    }
    
    return sum / Double(data.count)
}



private func splitDataIntoCycles(data: [MetricData], cycleStartDate: Date, cycleDurationDays: Int) -> [[MetricData]]{
    let sortedData = data.sorted { $0.date < $1.date }
    let calendar = Calendar.current
    var cycles: [[MetricData]] = []
    
    
    for item in sortedData {
        let daysFromStart = calendar.dateComponents([.day],from: cycleStartDate,to: item.date).day ?? 0
        
        let cycleIndex = daysFromStart / cycleDurationDays
        if cycleIndex >= cycles.count {
            cycles.append([])
        }
        
        cycles[cycleIndex].append(item)
    }
    return cycles
}

func calculateDeviationPercentage(cycles: [[MetricData]]) {
    var firstCycleAvg = 0.0
    var previousCycleAvg = 0.0
    
    var cycleCount = 1 // THIS IS JUST FOR PRINTING
    for cycle in cycles {
        print("Cycle \(cycleCount)")
        let avg = calculateMetricDataAverage(data: cycle)
        print("Average: \(avg)")
        
        if firstCycleAvg == 0.0 {
            firstCycleAvg = avg
        }
        
        if previousCycleAvg != 0.0 {
            let percentageDifference = calculatePercentageDifference(currAvg: avg, prevAvg: previousCycleAvg)
            print("Precentage Difference compared to cycle \(cycleCount - 1): \(percentageDifference)")
        }
        else {
            print("Cant calculate percentage difference.")
        }
        
        previousCycleAvg = avg
        cycleCount += 1
        
    }
    print("------------")
    if firstCycleAvg == 0.0 || previousCycleAvg == 0.0 {return}
    let percentageDifference = calculatePercentageDifference(currAvg: previousCycleAvg, prevAvg: firstCycleAvg)
    print("Percentage difference from first cycle: \(percentageDifference)")
    
}

private func calculateDeviationPercentageSingleValue(cycles: [[MetricData]], currValue: Double) {
    
    if cycles.isEmpty { return }
    
    let firstCycleAvg = calculateMetricDataAverage(data: cycles[0])
    
    let percentageDifference = calculatePercentageDifference(currAvg: currValue, prevAvg: firstCycleAvg)
    
    print("\n--------------------")
    print("Difference from cycle 1 average - most recent value")
    print("Percentage Difference: \(percentageDifference)")
}




func calculateDayByDayDomainDeviation(data: [MetricData]) -> [MetricData] {
    if data.isEmpty {return []}
    let baselineData = data.first!
    
    var newData = data
    for index in newData.indices {
        if newData[index].date == baselineData.date {
            newData[index].deviationPercentage = 0.0
        }
        
        newData[index].deviationPercentage = calculatePercentageDifference(currAvg: newData[index].value, prevAvg: baselineData.value)
    }
    
    return newData
}

private func testTheFunctions() {
    let cycles = splitDataIntoCycles(data: testMetricData, cycleStartDate: cycleStartDate, cycleDurationDays: cycleDurationDays)
    print(cycles)
    calculateDeviationPercentage(cycles: cycles)
    calculateDeviationPercentageSingleValue(cycles: cycles, currValue: 145)
    
    let newMetricData = calculateDayByDayDomainDeviation(data: testMetricData)
    for i in newMetricData {
        print("\(i.date) : \(i.deviationPercentage)")
    }
}


// THE BIG ONE!!
// This is what calulates the domain percentage deviance based on every value of each type in the domain
func calculateDomainPercentageDeviance(data: [[MetricData]], startDate: Date, endDate: Date) -> [MetricData] {
    
    // Calculate the domain percentage deviance based on all the different types
    //   per day
    let calendar = Calendar.current
    var currentDate = startDate
    
    var percentageDeviance: [MetricData] = []
    while currentDate <= endDate {
        
        let matches = data.flatMap { $0 }.filter {
            Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
        
        let domainDayAverage = calculateMetricDataAverage(data: matches, usePercentage: true)
        percentageDeviance.append(MetricData(date: currentDate, value: 0.0, deviationPercentage: domainDayAverage))
        

        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
            break
        }

        currentDate = nextDate
    }
    return percentageDeviance

}
