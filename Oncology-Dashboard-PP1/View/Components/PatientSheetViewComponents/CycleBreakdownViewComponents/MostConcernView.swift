//
//  MostConcernView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 2/6/2026.
//

import SwiftUI

struct MostConcernView: View {
    
    var concern: MostConcern
    @State var color: Color = Color.red
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(concern.title)
                    .font(.subheadline)
                    .foregroundStyle(color)
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(concern.value, specifier: "%.1f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(concern.unit)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(concern.date)
                    .font(.caption2)
                    .foregroundStyle(.black)
            }
            Spacer()
            Image(systemName: concern.good ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .foregroundStyle(concern.good ? .green : .red)
                .font(.system(size: 30))
        }
        .padding()
        .frame(width: 250)
        .background(color.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear() {
            switch self.concern.domain {
            case "Activity":
                self.color = .activity
            case "Physiological":
                self.color = .physiological
            case "Sleep":
                self.color = .sleep
            case "Self Reported":
                self.color = .selfReported
            default:
                self.color = .red
            }
        }
    }
}

#Preview {
    MostConcernView(concern: MostConcern(title: "Steps", value: 25000, unit: "steps", domain: "Actibity", date: "2025-06-01", good: true))
}
