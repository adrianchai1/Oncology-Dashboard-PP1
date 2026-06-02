//
//  CycleBreakdownView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 2/6/2026.
//

import SwiftUI

struct CycleBreakdownView: View {
    
    
    var treatmentStartDate: Date
    var cycleLength: Int
    @Binding var selectedCycle: Int
    
    @State var cycleStartDate = Date()
    @State var cycleEndDate = Date()
    
    @State private var vm: CycleBreakdownViewViewModel? = nil
    @State private var mostConcerningMetrics: MostConcerningMetrics? = nil
    var forceConcerningMetrics = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Cycle \(selectedCycle + 1)")
                    .font(.system(size: 30))
                    .padding(.leading, 20)
                    .padding(.top, 10)
                Spacer()
                Button(action: {
                    selectedCycle = -1
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.blue)
                        .font(.system(size: 50))
                }
                
                    
            }
            if vm != nil {
                if vm!.patientDomainData == nil {
                    Text("Data Loading")
                }
                else {
                   Text("Most Concering Metrics")
                    if mostConcerningMetrics != nil && mostConcerningMetrics!.mostConcern != nil {
                        ForEach(mostConcerningMetrics!.mostConcern!, id: \.title) { concern in
                            MostConcernView(concern: concern)
                        }
                    }
                }
            }
            Spacer()
        }
        .task {
            cycleStartDate = Calendar.current.date(
                byAdding: .day,
                value: selectedCycle * 14,
                to: treatmentStartDate
            ) ?? Date()
            cycleEndDate = Calendar.current.date(
                byAdding: .day,
                value: 14,
                to: cycleStartDate
            ) ?? Date()
            
            vm = CycleBreakdownViewViewModel(cycleStartDate: cycleStartDate, cycleEndDate: cycleEndDate)
            
            await vm?.fetchPatientCycleData(for: 1)
            
            do {
                // FOR TESTING PURPOSES
                if forceConcerningMetrics {
                    mostConcerningMetrics = MostConcerningMetrics(mostConcern: [
                        MostConcern(title: "Steps", value: 25000, unit: "steps", domain: "Activity", date: "2025-06-02", good: true),
                        MostConcern(title: "Sleep Efficiency", value: 67, unit: "%", domain: "Sleep", date: "2025-06-01", good: false),
                        MostConcern(title: "Energy Burned", value: 2000, unit: "kg", domain: "Activity", date: "2025-06-02", good: true)
                    ])
                }
                else {
                    mostConcerningMetrics = try await vm?.extractMostConcerningMetrics()
                }
            }
            catch {
                print("Apple Intelligence \(error)")
            }
        }
    }
        
}

struct CycleBreakdownViewPreview: View {
    @State var selectedCycle = 0
    var body: some View {
        CycleBreakdownView(treatmentStartDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 1)) ?? Date(), cycleLength: 14, selectedCycle: $selectedCycle, forceConcerningMetrics: true)
    }
}

#Preview {
    CycleBreakdownViewPreview()
}
