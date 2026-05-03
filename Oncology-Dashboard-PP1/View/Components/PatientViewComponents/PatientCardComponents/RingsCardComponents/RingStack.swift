//
//  RingStack.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 28/4/2026.
//

import SwiftUI

struct RingStack: View {
    let title: String
    let percentage: Double
    let stackColour: Color
    var body: some View {
        VStack {
            Text(title).padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)).foregroundStyle(Color(stackColour)).font(.subheadline).multilineTextAlignment(.center).lineLimit(2).frame(height: 70)
            PatientCardRing(ringWidth: 5, percent: percentage, fgColour: stackColour, bgColour: stackColour).frame(height: 60).padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
        }
    }
}

#Preview {
    RingStack(title: "Patient\nReported", percentage: 40, stackColour: .purple)
}
