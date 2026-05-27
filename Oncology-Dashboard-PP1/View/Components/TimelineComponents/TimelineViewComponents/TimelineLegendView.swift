//
//  TimelineLegendView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 27/5/2026.
//

import SwiftUI

struct TimelineLegendView: View {
    
    @Binding var physiological: Bool
    @Binding var activity: Bool
    @Binding var sleep: Bool
    @Binding var selfReported: Bool
    
    var body: some View {
        HStack {
            TimelineLegendToggleView(selected: $activity, color: .activity, title: "Activity")
            TimelineLegendToggleView(selected: $sleep, color: .sleep, title: "Sleep")
            TimelineLegendToggleView(selected: $selfReported, color: .selfReported, title: "Self Reported")
            TimelineLegendToggleView(selected: $physiological, color: .physiological, title: "Physiological")
        }
    }
}

struct TimelineLegendViewPreview: View {
    
    @State var physiological: Bool = true
    @State var activity: Bool = false
    @State var sleep: Bool = false
    @State var selfReported: Bool = false
    
    var body: some View {
        
        TimelineLegendView(physiological: $physiological, activity: $activity, sleep: $sleep, selfReported: $selfReported)
    }
}

#Preview {
    TimelineLegendViewPreview()
}
