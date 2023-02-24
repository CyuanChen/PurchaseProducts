//
//  Helper.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 12/12/2022.
//

import Foundation
import CoreData

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


extension NSManagedObjectModel {
	/// We use this static shared model to prevent errors like:
	/// `Failed to find a unique match for an NSEntityDescription to a managed object subclass`
	///
	/// This error likely occurs when running tests with an in-memory store while the regular app launch loads a file backed store.
	static let sharedModel: NSManagedObjectModel = {
		let url = Bundle(for: CoreDataStack.self).url(forResource: "PurchaseProducts", withExtension: "momd")!
		guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
			fatalError("Managed object model could not be created")
		}
		return managedObjectModel
	}()
}
