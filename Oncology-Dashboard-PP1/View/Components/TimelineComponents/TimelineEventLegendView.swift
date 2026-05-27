//
//  TimelineLegend.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 3/5/2026.
//

import SwiftUI

struct TimelineEventLegendView: View {
    
    @State private var openSheet = false
    
    var body: some View {
        Button(action: {
            openSheet = true
        }) {
            HStack {
                Text("Icons ")
                Image(systemName: "questionmark.circle")
            }
            .font(.system(size: 20))
//            .foregroundStyle(.secondary)
        }.sheet(isPresented: $openSheet) {
            List {
                HStack {
                    Image(systemName: EventID.appointment.icon)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(EventID.appointment.color)
                    Text(EventID.appointment.title)
                    Spacer()
                }
                HStack {
                    Image(systemName: EventID.chemotherapy.icon)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(EventID.chemotherapy.color)
                    Text(EventID.chemotherapy.title)
                    Spacer()
                }
                HStack {
                    Image(systemName: EventID.emergency.icon)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(EventID.emergency.color)
                    Text(EventID.emergency.title)
                    Spacer()
                }
                HStack {
                    Image(systemName: EventID.other.icon)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(EventID.other.color)
                    Text(EventID.other.title)
                    Spacer()
                }
            }.scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    TimelineEventLegendView()
}
