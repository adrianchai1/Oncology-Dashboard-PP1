//
//  TimelineBar.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 30/4/2026.
//

import SwiftUI

struct TimelineBar: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.green, .yellow, .yellow, .yellow, .orange, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 30)
    }
}

#Preview {
    TimelineBar()
}
