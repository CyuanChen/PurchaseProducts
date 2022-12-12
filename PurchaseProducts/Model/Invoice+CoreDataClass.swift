//
//  Invoice+CoreDataClass.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 12/12/2022.
//
//

import Foundation
import CoreData


public class Invoice: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case invoiceNumber = "invoice_number"
        case receivedStatus = "received_status"
        case created
        case lastUpdatedUserEntityID = "last_updated_user_entity_id"
        case transientIdentifier = "transient_identifier"
        case receipts
        case receiptSentDate = "receipt_sent_date"
        case activeFlag = "active_flag"
        case lastUpdated = "last_updated"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context else {
            fatalError("Error")
        }
        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError("Decode failure")
        }
        self.init(context: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(Int32.self, forKey: .id)
            invoiceNumber = try values.decode(String.self, forKey: .invoiceNumber)
            receivedStatus = try values.decode(Int16.self, forKey: .receivedStatus)
            lastUpdatedUserEntityID = try values.decode(Int32.self, forKey: .lastUpdatedUserEntityID)
            transientIdentifier = try values.decode(String.self, forKey: .transientIdentifier)
            
            // https://www.hackingwithswift.com/forums/swift/codable-in-core-data-with-to-many-relationships/1555
            receipts = NSSet(array: try values.decode([Receipt].self, forKey: .receipts))
            activeFlag = try values.decode(Bool.self, forKey: .activeFlag)
            let createdString = try values.decode(String.self, forKey: .created)
            let receiptSentDateString = try values.decode(String.self, forKey: .receiptSentDate)
            let lastUpdatedString = try values.decode(String.self, forKey: .lastUpdated)
            let formatter = DateFormatter.iso8601Full
            if let createdDate = formatter.date(from: createdString) {
                created = createdDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .created, in: values, debugDescription: "Created does not match format")
            }
            if let receiptSentDecodeDate = formatter.date(from: receiptSentDateString) {
                receiptSentDate = receiptSentDecodeDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .receiptSentDate, in: values, debugDescription: "Receipt sent date does not match format")
            }
            if let lastUpdatedDate = formatter.date(from: lastUpdatedString) {
                lastUpdated = lastUpdatedDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .lastUpdated, in: values, debugDescription: "Last Updated does not match format")
            }
        } catch {
            print("decode Error")
        }
//        print("self: \(self)")
    }
}
