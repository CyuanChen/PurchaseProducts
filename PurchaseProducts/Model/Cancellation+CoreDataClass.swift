//
//  Cancellation+CoreDataClass.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 12/12/2022.
//
//

import Foundation
import CoreData


public class Cancellation: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case productItemID = "product_item_id"
        case orderedQuantity = "ordered_quantity"
        case lastUpdatedUserEntityID = "last_updated_user_entity_id"
        case created
        case transientIdentifier = "transient_identifier"
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
            orderedQuantity = try values.decode(Int32.self, forKey: .orderedQuantity)
            lastUpdatedUserEntityID = try values.decode(Int32.self, forKey: .lastUpdatedUserEntityID)
            transientIdentifier = try values.decode(String.self, forKey: .transientIdentifier)
            let createdString = try values.decode(String.self, forKey: .created)
            let formatter = DateFormatter.iso8601Full
            if let createdDate = formatter.date(from: createdString) {
                created = createdDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .created, in: values, debugDescription: "Created does not match format")
            }
        } catch {
            print("decode Error")
        }
//        print("self: \(self)")
    }
}
