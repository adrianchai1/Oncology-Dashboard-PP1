//
//  RadarGraph.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 31/5/2026.
//

import SwiftUI

struct RadarChartView: View {
    let datasets: [RadarDataset]
    let labels: [String]

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = size / 2.25
            let axisCount = labels.count

            ZStack {
                ForEach(1...4, id: \.self) { ring in
                    RadarPolygon(
                        values: Array(repeating: Double(ring) / 4.0, count: axisCount),
                        center: center,
                        radius: radius
                    )
                    .stroke(.gray.opacity(0.25), lineWidth: 1)
                }

                ForEach(0..<axisCount, id: \.self) { i in
                    Path { path in
                        path.move(to: center)
                        path.addLine(to: point(index: i, value: 1, count: axisCount, center: center, radius: radius))
                    }
                    .stroke(.gray.opacity(0.25), lineWidth: 1)
                }

                ForEach(datasets.indices, id: \.self) { i in
                    RadarPolygon(values: datasets[i].values, center: center, radius: radius)
                        .fill(datasets[i].color.opacity(0.18))

                    RadarPolygon(values: datasets[i].values, center: center, radius: radius)
                        .stroke(datasets[i].color, lineWidth: 2)
                }

                ForEach(labels.indices, id: \.self) { i in
                    Text(labels[i])
                        .font(.caption)
                        .position(point(index: i, value: 1.15, count: axisCount, center: center, radius: radius))
                }
            }
        }
        .frame(height: 320)
    }

    private func point(index: Int, value: Double, count: Int, center: CGPoint, radius: CGFloat) -> CGPoint {
        let angle = (Double(index) / Double(count)) * 2 * .pi - .pi / 2

        return CGPoint(
            x: center.x + cos(angle) * radius * value,
            y: center.y + sin(angle) * radius * value
        )
    }
}

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
