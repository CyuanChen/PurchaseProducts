//
//  Helper.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 12/12/2022.
//

import Foundation

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}


extension DateFormatter {
    // https://useyourloaf.com/blog/swift-codable-with-custom-dates/
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
    //https://stackoverflow.com/questions/41628425/how-to-convert-2017-01-09t110000-000z-into-date-in-swift-3
        // "2020-05-07T09:32:28.213Z"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
