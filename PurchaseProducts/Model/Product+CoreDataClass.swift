//
//  Product+CoreDataClass.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 12/12/2022.
//
//

import Foundation
import CoreData


public class Product: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case supplierID = "supplier_id"
        case purchaseOrderNumber = "purchase_order_number"
        case stockPurchaseProcessIDs = "stock_purchase_process_ids"
        case issueDate = "issue_date"
        case items, invoices, cancellations, status
        case activeFlag = "active_flag"
        case lastUpdated = "last_updated"
        case lastUpdatedUserEntityID = "last_updated_user_entity_id"
        case sentDate = "sent_date"
        case serverTimestamp = "server_timestamp"
        case deviceKey = "device_key"
        case approvalStatus = "approval_status"
        case preferredDeliveryDate = "preferred_delivery_date"
        case deliveryNote = "delivery_note"
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
            supplierID = try values.decode(Int32.self, forKey: .supplierID)
            purchaseOrderNumber = try values.decode(String.self, forKey: .purchaseOrderNumber)
            stockPurchaseProcessIDs = try values.decode([Int].self, forKey: .stockPurchaseProcessIDs)
            activeFlag = try values.decode(Bool.self, forKey: .activeFlag)
            lastUpdateUserEntityID = try values.decode(Int32.self, forKey: .lastUpdatedUserEntityID)

            serverTimestamp = try values.decode(Int32.self, forKey: .serverTimestamp)
            deviceKey = try values.decode(String.self, forKey: .deviceKey)
            approvalStatus = try values.decode(Int32.self, forKey: .approvalStatus)
            deliveryNote = try values.decode(String.self, forKey: .deliveryNote)
            items = NSSet(array: try values.decode([Item].self, forKey: .items))
            invoices = NSSet(array: try values.decode([Invoice].self, forKey: .invoices))
            cancellations = NSSet(array: try values.decode([Cancellation].self, forKey: .cancellations))
            status = try values.decode(Int32.self, forKey: .status)
            let issueDateString = try values.decode(String.self, forKey: .issueDate)
            let sentDateString = try values.decode(String.self, forKey: .sentDate)
            let formatter = DateFormatter.iso8601Full
            if let issueDecodeDate = formatter.date(from: issueDateString) {
                issueDate = issueDecodeDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .issueDate, in: values, debugDescription: "Issue Date does not match format")
            }
            if let sentDecodeDate = formatter.date(from: sentDateString) {
                sentDate = sentDecodeDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .sentDate, in: values, debugDescription: "Sent Date does not match format")
            }
            let lastUpdatedString = try values.decode(String.self, forKey: .lastUpdated)
            if let lastUpdatedDate = formatter.date(from: lastUpdatedString) {
                lastUpdated = lastUpdatedDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .lastUpdated, in: values, debugDescription: "Last Update does not match format")
            }
            let preferredDeliveryDateString = try values.decode(String.self, forKey: .preferredDeliveryDate)
            if let preferDeliveryDecodeDate = formatter.date(from: preferredDeliveryDateString) {
                preferredDeliveryDate = preferDeliveryDecodeDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .preferredDeliveryDate, in: values, debugDescription: "Prefer Delivery Date does not match format")
            }
        } catch {
            print("decode Error")
        }
        print("self: \(self)")
    }
}


