//
//  CycleBreakdownView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 2/6/2026.
//

import SwiftUI

struct CycleBreakdownView: View {
    
    var patientId: Int
    var treatmentStartDate: Date
    var cycleLength: Int
    @Binding var selectedCycle: Int
    
    @State var cycleStartDate = Date()
    @State var cycleEndDate = Date()
    
    @State private var vm: CycleBreakdownViewViewModel? = nil
    @State private var mostConcerningMetrics: [MostConcerningMetrics] = []
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
                if vm!.mostConcerningMetrics.isEmpty {
                    Text("Data Loading")
                }
                else {
                    HStack(spacing: 20) {
                        VStack {
                            Text("Most Notable Metrics:")
                            MostConcerningLineGraph(mostConcerningMetrics: vm?.mostConcerningMetrics ?? [])
                        }
                        
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(.white.opacity(0.25), lineWidth: 1)
                        }
                        .shadow(radius: 12)
                        .padding()
                        
                        Spacer()
                        
                        VStack {
                            Text("Sleep Score: (%)")
                            GeneralLineGraph(dataPoints: vm?.sleepDataPoints ?? [], color: .sleep)
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(.white.opacity(0.25), lineWidth: 1)
                        }
                        .shadow(radius: 12)
                        .padding()
                    }
                    .frame(height: 300)
                    .padding(.horizontal)
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
            
            if vm != nil {
                do {
                    try await vm!.initCycleData(patientId: patientId)
                }
                catch {
                    print(error)
                }
            }
        }
    }
        
}

struct CycleBreakdownViewPreview: View {
    @State var selectedCycle = 0
    var body: some View {
        CycleBreakdownView(patientId: 1, treatmentStartDate: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 1)) ?? Date(), cycleLength: 14, selectedCycle: $selectedCycle, forceConcerningMetrics: true)
    }
}

#Preview {
    CycleBreakdownViewPreview()
}
