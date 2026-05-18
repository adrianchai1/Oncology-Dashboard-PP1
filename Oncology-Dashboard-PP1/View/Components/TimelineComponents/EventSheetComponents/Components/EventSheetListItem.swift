//
//  SwiftUIView.swift
//  Oncology-Dashboard-PP1
//
//  Created by Adrian Chai on 17/5/2026.
//

import SwiftUI

struct EventSheetListItem: View {
    let title: String
    let descriptor: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(descriptor)
                .foregroundStyle(.secondary)
        }
    }
}
