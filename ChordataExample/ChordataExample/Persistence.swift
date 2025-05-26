//
//  Persistence.swift
//  ChordataExample
//
//  Created by Andrew Clunis on 2025-05-26.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for preview
        createSampleData(in: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ChordataExample")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { [weak container] (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallowing writing.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            // Check if database is empty and populate with sample data if needed
            if !inMemory, let container = container {
                Task { @MainActor in
                    PersistenceController.loadSampleDataIfNeeded(for: container)
                }
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    @MainActor
    private static func loadSampleDataIfNeeded(for container: NSPersistentContainer) {
        let context = container.viewContext
        
        // Check if any data already exists by checking for products
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let existingProducts = try context.fetch(fetchRequest)
            if existingProducts.isEmpty {
                // Database is empty, load sample data
                print("Database is empty, loading sample data...")
                PersistenceController.createSampleData(in: context)
                try context.save()
                print("Sample data loaded successfully")
            } else {
                print("Database already contains data, skipping sample data load")
            }
        } catch {
            print("Error checking for existing data or loading sample data: \(error)")
        }
    }
    
    @MainActor
    static func createSampleData(in context: NSManagedObjectContext) {
        // Create Categories
        let beveragesCategory = Category(context: context)
        beveragesCategory.categoryID = 1
        beveragesCategory.categoryName = "Beverages"
        beveragesCategory.categoryDescription = "Soft drinks, coffees, teas, beers, and ales"
        
        let dairyCategory = Category(context: context)
        dairyCategory.categoryID = 2
        dairyCategory.categoryName = "Dairy Products"
        dairyCategory.categoryDescription = "Cheeses"
        
        let seafoodCategory = Category(context: context)
        seafoodCategory.categoryID = 3
        seafoodCategory.categoryName = "Seafood"
        seafoodCategory.categoryDescription = "Seaweed and fish"
        
        // Create Suppliers
        let exoticLiquids = Supplier(context: context)
        exoticLiquids.supplierID = 1
        exoticLiquids.companyName = "Exotic Liquids"
        exoticLiquids.contactName = "Charlotte Cooper"
        exoticLiquids.contactTitle = "Purchasing Manager"
        exoticLiquids.address = "49 Gilbert St."
        exoticLiquids.city = "London"
        exoticLiquids.postalCode = "EC1 4SD"
        exoticLiquids.country = "UK"
        exoticLiquids.phone = "(171) 555-2222"
        
        let newOrleansSupplier = Supplier(context: context)
        newOrleansSupplier.supplierID = 2
        newOrleansSupplier.companyName = "New Orleans Cajun Delights"
        newOrleansSupplier.contactName = "Shelley Burke"
        newOrleansSupplier.contactTitle = "Order Administrator"
        newOrleansSupplier.address = "P.O. Box 78934"
        newOrleansSupplier.city = "New Orleans"
        newOrleansSupplier.postalCode = "70117"
        newOrleansSupplier.country = "USA"
        newOrleansSupplier.phone = "(100) 555-4822"
        
        // Create Products
        let chai = Product(context: context)
        chai.productID = 1
        chai.productName = "Chai"
        chai.quantityPerUnit = "10 boxes x 20 bags"
        chai.unitPrice = NSDecimalNumber(string: "18.00")
        chai.unitsInStock = 39
        chai.unitsOnOrder = 0
        chai.reorderLevel = 10
        chai.discontinued = false
        chai.category = beveragesCategory
        chai.supplier = exoticLiquids
        
        let chang = Product(context: context)
        chang.productID = 2
        chang.productName = "Chang"
        chang.quantityPerUnit = "24 - 12 oz bottles"
        chang.unitPrice = NSDecimalNumber(string: "19.00")
        chang.unitsInStock = 17
        chang.unitsOnOrder = 40
        chang.reorderLevel = 25
        chang.discontinued = false
        chang.category = beveragesCategory
        chang.supplier = exoticLiquids
        
        let queso = Product(context: context)
        queso.productID = 3
        queso.productName = "Queso Cabrales"
        queso.quantityPerUnit = "1 kg pkg."
        queso.unitPrice = NSDecimalNumber(string: "21.00")
        queso.unitsInStock = 22
        queso.unitsOnOrder = 30
        queso.reorderLevel = 30
        queso.discontinued = false
        queso.category = dairyCategory
        queso.supplier = newOrleansSupplier
        
        // Create Customers
        let alfki = Customer(context: context)
        alfki.customerID = "ALFKI"
        alfki.companyName = "Alfreds Futterkiste"
        alfki.contactName = "Maria Anders"
        alfki.contactTitle = "Sales Representative"
        alfki.address = "Obere Str. 57"
        alfki.city = "Berlin"
        alfki.postalCode = "12209"
        alfki.country = "Germany"
        alfki.phone = "030-0074321"
        alfki.fax = "030-0076545"
        
        let anatr = Customer(context: context)
        anatr.customerID = "ANATR"
        anatr.companyName = "Ana Trujillo Emparedados y helados"
        anatr.contactName = "Ana Trujillo"
        anatr.contactTitle = "Owner"
        anatr.address = "Avda. de la Constitución 2222"
        anatr.city = "México D.F."
        anatr.postalCode = "05021"
        anatr.country = "Mexico"
        anatr.phone = "(5) 555-4729"
        anatr.fax = "(5) 555-3745"
        
        // Create Orders
        let order1 = Order(context: context)
        order1.orderID = 10248
        order1.orderDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())
        order1.requiredDate = Calendar.current.date(byAdding: .day, value: -15, to: Date())
        order1.shippedDate = Calendar.current.date(byAdding: .day, value: -25, to: Date())
        order1.freight = NSDecimalNumber(string: "32.38")
        order1.shipName = "Vins et alcools Chevalier"
        order1.shipAddress = "59 rue de l'Abbaye"
        order1.shipCity = "Reims"
        order1.shipPostalCode = "51100"
        order1.shipCountry = "France"
        order1.customer = alfki
        
        let order2 = Order(context: context)
        order2.orderID = 10249
        order2.orderDate = Calendar.current.date(byAdding: .day, value: -25, to: Date())
        order2.requiredDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        order2.shippedDate = Calendar.current.date(byAdding: .day, value: -20, to: Date())
        order2.freight = NSDecimalNumber(string: "11.61")
        order2.shipName = "Toms Spezialitäten"
        order2.shipAddress = "Luisenstr. 48"
        order2.shipCity = "Münster"
        order2.shipPostalCode = "44087"
        order2.shipCountry = "Germany"
        order2.customer = anatr
        
        // Create Order Details
        let orderDetail1 = OrderDetail(context: context)
        orderDetail1.unitPrice = NSDecimalNumber(string: "18.00")
        orderDetail1.quantity = 12
        orderDetail1.discount = 0.0
        orderDetail1.order = order1
        orderDetail1.product = chai
        
        let orderDetail2 = OrderDetail(context: context)
        orderDetail2.unitPrice = NSDecimalNumber(string: "19.00")
        orderDetail2.quantity = 10
        orderDetail2.discount = 0.0
        orderDetail2.order = order1
        orderDetail2.product = chang
        
        let orderDetail3 = OrderDetail(context: context)
        orderDetail3.unitPrice = NSDecimalNumber(string: "21.00")
        orderDetail3.quantity = 5
        orderDetail3.discount = 0.0
        orderDetail3.order = order2
        orderDetail3.product = queso
    }
}
