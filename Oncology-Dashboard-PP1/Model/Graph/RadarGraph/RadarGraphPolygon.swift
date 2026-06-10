//
//  RadarGraphPolygon.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 10/6/2026.
//

import SwiftUI

struct RadarPolygon: Shape {
    let values: [Double]
    let center: CGPoint
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for i in values.indices {
            let angle = (Double(i) / Double(values.count)) * 2 * .pi - .pi / 2
            let point = CGPoint(
                x: center.x + cos(angle) * radius * values[i],
                y: center.y + sin(angle) * radius * values[i]
            )
            i == 0 ? path.move(to: point) : path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}
