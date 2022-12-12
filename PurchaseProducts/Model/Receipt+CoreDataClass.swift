//
//  Receipt+CoreDataClass.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 12/12/2022.
//
//

import Foundation
import CoreData


public class Receipt: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
            case id
            case productItemID = "product_item_id"
            case receivedQuantity = "received_quantity"
            case created
            case lastUpdatedUserEntityID = "last_updated_user_entity_id"
            case transientIdentifier = "transient_identifier"
            case sentDate = "sent_date"
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
            productItemID = try values.decode(Int32.self, forKey: .productItemID)
            receivedQuantity = try values.decode(Int32.self, forKey: .receivedQuantity)
            lastUpdatedUserEntityID = try values.decode(Int32.self, forKey: .lastUpdatedUserEntityID)
            transientIdentifier = try values.decode(String.self, forKey: .transientIdentifier)
            activeFlag = try values.decode(Bool.self, forKey: .activeFlag)
            let createdString = try values.decode(String.self, forKey: .created)
            let sentDateString = try values.decode(String.self, forKey: .sentDate)
            let lastUpdatedString = try values.decode(String.self, forKey: .lastUpdated)
            let formatter = DateFormatter.iso8601Full
            if let createdDate = formatter.date(from: createdString) {
                created = createdDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .created, in: values, debugDescription: "Created does not match format")
            }
            if let sentDecodeDate = formatter.date(from: sentDateString) {
                sentDate = sentDecodeDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .sentDate, in: values, debugDescription: "Sent date does not match format")
            }
            if let lastUpdatedDate = formatter.date(from: lastUpdatedString) {
                lastUpdated = lastUpdatedDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .lastUpdated, in: values, debugDescription: "Last Updated does not match format")
            }
        } catch {
            print("decode Error")
        }
    }
}
