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
            LazyHStack {
                TimelineCycle()
                TimelineCycle()
                TimelineCycle()
                TimelineCycle()
                TimelineCycle()
            }
        }
    }
}

#Preview {
    TimelineView()
}
