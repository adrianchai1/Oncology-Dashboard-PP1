//
//  PhenotypePercentageCalculator.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 18/5/2026.
//

import Foundation


// Calculates the precentage difference based on two averages
// EG: currAvg = 40, prevAvg = 20 = +100% difference
private func calculatePercentageDifference(currAvg: Double, prevAvg: Double) -> Double {
    // Returns a percentage
    return ((currAvg - prevAvg) / prevAvg) * 100
}

// Calculates the average within the metric data based on either the raw value or the percentage
private func calculateMetricDataAverage(data: [MetricData], usePercentage: Bool = false) -> Double {
    if data.isEmpty {
        return 0.0
    }
    var sum = 0.0
    for metricData in data {
        // calculating the data average using the percentages or the raw value.
        if usePercentage {
            sum += metricData.deviationPercentage
        }
        else {
            sum += metricData.value
        }
    }
    
    return sum / Double(data.count)
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
