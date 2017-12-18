//
//  ItemAccess+CoreDataClass.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData

@objc(ItemAccess)
public class ItemAccess: NSManagedObject, Codable {
    
    
    convenience public required init(from decoder: Decoder)throws{
        
        enum ItemKey: String, CodingKey{
            case item_id, access_token
        }
        
        //guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        let context = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "ItemAccess", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)

        let container = try! decoder.container(keyedBy: ItemKey.self)
        self.accessToken = try container.decode(String.self, forKey: .access_token)
        self.itemId = try container.decodeIfPresent(String.self, forKey: .item_id)
   
    }
}

//extension ItemAccess{
//    convenience init(context: NSManagedObjectContext) {
//        
//        let entityDescription = NSEntityDescription.entity(forEntityName: "ItemAcess", in:
//            context)!
//        
//        self.init(entity: entityDescription, insertInto: context)
//    }
//}

