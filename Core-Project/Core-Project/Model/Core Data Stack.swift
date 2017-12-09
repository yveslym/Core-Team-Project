//
//  Core Data Stack.swift
//  Core-Project
//
//  Created by Yveslym on 12/7/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import CoreData

//
//  CoreDataStack.swift
//  Shopping Card (core Data)
//
//  Created by Yveslym on 11/22/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    static var instance = CoreDataStack()
    
    private lazy var persistanceContainer: NSPersistentContainer = {
        let contenainer = NSPersistentContainer(name: "BankingModel")
        contenainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error), \(error.userInfo)") // need to be change
            }
        })
        return contenainer
    }()
    
    lazy var viewContext:NSManagedObjectContext = {
        let context = persistanceContainer.viewContext
        return context
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        //        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        //        context.persistentStoreCoordinator = persistanceContainer.persistentStoreCoordinator
        //        return context
        return persistanceContainer.newBackgroundContext()
    }()
    
    func saveTo(context: NSManagedObjectContext){
        if context.hasChanges{
            do{
                try context.save()
            }
            catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                // need to change by the alert view
            }
        }
    }
    
    func delete(context: NSManagedObjectContext, item: NSManagedObject){
        context.delete(item)
        saveTo(context: context)
    }
    
    
    func fetchRecordsForEntity(_ entity: Entity, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
}
enum Entity: String{
    case Product
    case ShoppingCard
    case User
}
