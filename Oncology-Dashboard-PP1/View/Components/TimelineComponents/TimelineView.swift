//
//  TimelineView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 29/4/2026.
//

import SwiftUI

struct TimelineView: View {
    let timelineCycleCount: Int
    let patientStartDate: Date
    @Binding var selectedCycle: Int
    
    var body: some View {
        ScrollView(.horizontal) {
            ZStack(alignment: .leading) {
                // All of the timeline Cycles
                LazyHStack {
                    ForEach(0..<timelineCycleCount) { i in
                        let cycleStart = Calendar.current.date(byAdding: .day, value: i * 14, to: Date())
                        TimelineCycle(cycleNumber: i, cycleStartDate: cycleStart ?? Date(), cycleLength: 14, isSelected: selectedCycle == i).contentShape(Rectangle()).onTapGesture {
                                selectedCycle = i
                        }
                    }
                }
                
                // Timeline heatmap bar
                TimelineBar()
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
            }
        }
    }
}

#Preview {
    TimelineView(timelineCycleCount: TinaDinh.cycleCount, patientStartDate: TinaDinh.treatmentStartDate, selectedCycle: .constant(0))
}
