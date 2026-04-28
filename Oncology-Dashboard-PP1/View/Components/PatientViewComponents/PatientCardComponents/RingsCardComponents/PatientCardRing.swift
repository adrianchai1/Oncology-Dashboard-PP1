//
//  PatientCardRing.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 28/4/2026.
//

import SwiftUI

struct PatientCardRing: View {
    let ringWidth: CGFloat
    let percent: Double
    let fgColour: Color
    let bgColour: Color
    let startAngle: Double = -90
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                RingShape().stroke(style: StrokeStyle(lineWidth: ringWidth)).fill(bgColour.opacity(0.2))
                RingShape(percent: percent, startAngle: startAngle).stroke(style: StrokeStyle(lineWidth: ringWidth, lineCap: .round)).fill(fgColour)
                Text("\(Int(percent))%").font(.caption).foregroundStyle(Color(fgColour)).fontWeight(.bold)
            }.frame(height: 50)
        }
    }
}

#Preview {
    PatientCardRing(ringWidth: 15, percent: 25, fgColour: .green, bgColour: .green)
}
