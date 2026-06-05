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
    
    private func setAll() {
        physiological = false
        activity = false
        sleep = false
        selfReported = false
    }
    
    var body: some View {
        HStack {
            TimelineLegendToggleView(selected: $activity, color: .activity, title: "Activity", setAll: setAll)
            TimelineLegendToggleView(selected: $sleep, color: .sleep, title: "Sleep", setAll: setAll)
            TimelineLegendToggleView(selected: $selfReported, color: .selfReported, title: "Self Reported", setAll: setAll)
            TimelineLegendToggleView(selected: $physiological, color: .physiological, title: "Physiological", setAll: setAll)
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
