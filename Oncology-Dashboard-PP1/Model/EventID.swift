//
//  EventID.swift
//  Oncology-Dashboard-PP1
//
//  Created by Jonathan Dummett on 6/5/2026.
//

import Foundation
import SwiftUI

// TODO: Need to add cases for blood pressure, sleep etc. Things doctors could flag as a problem and put it on the timeline view.
enum EventID: String, Codable, CaseIterable {
    case chemotherapy
    case appointment
    case emergency
    case other
    
    
    var title: String {
        switch self {
        case .chemotherapy: return "Chemotherapy"
        case .appointment: return "Appointment"
        case .emergency: return "Emergency"
        case .other: return "Other"
        }
    }

    var icon: String {
        switch self {
        case .chemotherapy: return "pills"
        case .appointment: return "calendar"
        case .emergency: return "heart"
        case .other: return "questionmark"
        }
    }

    var color: Color {
        switch self {
        case .chemotherapy: return .green.opacity(0.5)
        case .appointment: return .blue.opacity(0.5)
        case .emergency: return .red.opacity(0.5)
        case .other: return .gray.opacity(0.5)
        }
    }
}
