//
//  CGDKDateFormatter.swift
//  ChiuGaiOSDevKit
//
//  Created by Chiu on 2025/8/20.
//

import Foundation

public enum CGDKDateFormat {
    case short          // 8/20
    case medium         // Aug 20, 2025
    case long           // August 20, 2025
    case time           // 2:30 PM
    case timeWithSeconds // 2:30:45 PM
    case dateTime       // Aug 20, 2025 at 2:30 PM
    case iso8601        // 2025-08-20T14:30:00Z
    case relative       // 2 hours ago
    case custom(String) // Custom format
}

@MainActor
public final class CGDKDateFormatter {
    public static let shared = CGDKDateFormatter()
    
    private let shortFormatter: DateFormatter
    private let mediumFormatter: DateFormatter
    private let longFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    private let timeWithSecondsFormatter: DateFormatter
    private let dateTimeFormatter: DateFormatter
    private let iso8601Formatter: ISO8601DateFormatter
    private let relativeFormatter: RelativeDateTimeFormatter
    
    private init() {
        shortFormatter = DateFormatter()
        shortFormatter.dateStyle = .short
        shortFormatter.timeStyle = .none
        
        mediumFormatter = DateFormatter()
        mediumFormatter.dateStyle = .medium
        mediumFormatter.timeStyle = .none
        
        longFormatter = DateFormatter()
        longFormatter.dateStyle = .long
        longFormatter.timeStyle = .none
        
        timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        timeWithSecondsFormatter = DateFormatter()
        timeWithSecondsFormatter.dateStyle = .none
        timeWithSecondsFormatter.timeStyle = .medium
        
        dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateStyle = .medium
        dateTimeFormatter.timeStyle = .short
        
        iso8601Formatter = ISO8601DateFormatter()
        
        relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.dateTimeStyle = .named
    }
    
    public func string(from date: Date, format: CGDKDateFormat) -> String {
        switch format {
        case .short:
            return shortFormatter.string(from: date)
        case .medium:
            return mediumFormatter.string(from: date)
        case .long:
            return longFormatter.string(from: date)
        case .time:
            return timeFormatter.string(from: date)
        case .timeWithSeconds:
            return timeWithSecondsFormatter.string(from: date)
        case .dateTime:
            return dateTimeFormatter.string(from: date)
        case .iso8601:
            return iso8601Formatter.string(from: date)
        case .relative:
            return relativeFormatter.localizedString(for: date, relativeTo: Date())
        case .custom(let formatString):
            let formatter = DateFormatter()
            formatter.dateFormat = formatString
            return formatter.string(from: date)
        }
    }
    
    public func date(from string: String, format: CGDKDateFormat) -> Date? {
        switch format {
        case .short:
            return shortFormatter.date(from: string)
        case .medium:
            return mediumFormatter.date(from: string)
        case .long:
            return longFormatter.date(from: string)
        case .time:
            return timeFormatter.date(from: string)
        case .timeWithSeconds:
            return timeWithSecondsFormatter.date(from: string)
        case .dateTime:
            return dateTimeFormatter.date(from: string)
        case .iso8601:
            return iso8601Formatter.date(from: string)
        case .custom(let formatString):
            let formatter = DateFormatter()
            formatter.dateFormat = formatString
            return formatter.date(from: string)
        case .relative:
            return nil // Not supported for parsing
        }
    }
}