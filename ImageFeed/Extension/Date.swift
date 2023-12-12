//
//  Date.swift
//  ImageFeed
//
//  Created by Арина Колганова on 06.12.2023.
//

import Foundation

extension Date {
    static func convertStringToDate(date: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from:date)
    }
}
