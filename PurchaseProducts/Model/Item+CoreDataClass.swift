//
//  Item+CoreDataClass.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 12/12/2022.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case productItemID = "product_item_id"
        case quantity
        case lastUpdatedUserEntityID = "last_updated_user_entity_id"
        case transientIdentifier = "transient_identifier"
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
            quantity = try values.decode(Int32.self, forKey: .quantity)
            lastUpdateUserEntityID = try values.decode(Int32.self, forKey: .lastUpdatedUserEntityID)
            transientIdentifier = try values.decode(String.self, forKey: .transientIdentifier)
            activeFlag = try values.decode(Bool.self, forKey: .activeFlag)
            let lastUpdatedString = try values.decode(String.self, forKey: .lastUpdated)
            let formatter = DateFormatter.iso8601Full
            if let lastUpdatedDate = formatter.date(from: lastUpdatedString) {
                lastUpdated = lastUpdatedDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .lastUpdated, in: values, debugDescription: "Last updated does not match format")
            }
        } catch {
            print("decode Error")
        }
    }
}
