//
//  TimelineLegendToggleView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 27/5/2026.
//

import SwiftUI

struct TimelineLegendToggleView: View {
    
    @Binding var selected: Bool
    var color: Color
    var title: String
    
    var body: some View {
        Button(action: {
            selected = !selected
        }) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(color.opacity(0.5), lineWidth: 2)
                        .frame(width: 22, height: 22)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(selected ? color : Color.clear)
                        )
                    
                    if selected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                
                Text(title)
                    .foregroundStyle(color)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
//                    .fill(Color(white: 0.95))
                    .fill(color.opacity(0.4))
            )
        }
    }
}

struct TimelineLegendToggleViewPreview: View {
    @State var test = true
    var body: some View {
        TimelineLegendToggleView(selected: $test, color: .physiological, title: "Physiological")
    }
}

#Preview {
    TimelineLegendToggleViewPreview()
}
