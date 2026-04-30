//
//  TimelineView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 29/4/2026.
//

import SwiftUI

struct TimelineView: View {
    var body: some View {
        ScrollView(.horizontal) {
            ZStack(alignment: .leading) {
                // All of the timeline Cycles
                LazyHStack {
                    TimelineCycle()
                    TimelineCycle()
                    TimelineCycle()
                    TimelineCycle()
                    TimelineCycle()
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
    TimelineView()
}
