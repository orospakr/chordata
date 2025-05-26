//
//  ContentView.swift
//  ChordataExample
//
//  Created by Andrew Clunis on 2025-05-26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView {
            ProductsView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Products")
                }
            
            CustomersView()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Customers")
                }
            
            OrdersView()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("Orders")
                }
            
            CategoriesView()
                .tabItem {
                    Image(systemName: "folder")
                    Text("Categories")
                }
        }
        .environment(\.managedObjectContext, viewContext)
    }
}

struct ProductsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(products) { product in
                    NavigationLink {
                        ProductDetailView(product: product)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.productName ?? "Unknown Product")
                                .font(.headline)
                            Text("Category: \(product.category?.categoryName ?? "None")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Supplier: \(product.supplier?.companyName ?? "None")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack {
                                Text("Price: $\(product.unitPrice?.stringValue ?? "0")")
                                    .font(.caption)
                                Spacer()
                                Text("Stock: \(product.unitsInStock)")
                                    .font(.caption)
                                    .foregroundColor(product.unitsInStock > 0 ? .green : .red)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .navigationTitle("Products")
            Text("Select a product")
        }
    }
}

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        Form {
            Section("Product Information") {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(product.productName ?? "Unknown")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Price")
                    Spacer()
                    Text("$\(product.unitPrice?.stringValue ?? "0")")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Quantity Per Unit")
                    Spacer()
                    Text(product.quantityPerUnit ?? "N/A")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Units in Stock")
                    Spacer()
                    Text("\(product.unitsInStock)")
                        .foregroundColor(product.unitsInStock > 0 ? .green : .red)
                }
                
                HStack {
                    Text("Discontinued")
                    Spacer()
                    Text(product.discontinued ? "Yes" : "No")
                        .foregroundColor(product.discontinued ? .red : .green)
                }
            }
            
            Section("Category") {
                if let category = product.category {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.categoryName ?? "Unknown Category")
                            .font(.headline)
                        if let description = category.categoryDescription {
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    Text("No category assigned")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Supplier") {
                if let supplier = product.supplier {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(supplier.companyName ?? "Unknown Supplier")
                            .font(.headline)
                        if let contactName = supplier.contactName {
                            Text("Contact: \(contactName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        if let city = supplier.city, let country = supplier.country {
                            Text("\(city), \(country)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    Text("No supplier assigned")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CustomersView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Customer.companyName, ascending: true)],
        animation: .default)
    private var customers: FetchedResults<Customer>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(customers) { customer in
                    NavigationLink {
                        CustomerDetailView(customer: customer)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(customer.companyName ?? "Unknown Company")
                                .font(.headline)
                            if let contactName = customer.contactName {
                                Text("Contact: \(contactName)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            if let city = customer.city, let country = customer.country {
                                Text("\(city), \(country)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Text("Orders: \(customer.orders?.count ?? 0)")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .navigationTitle("Customers")
            Text("Select a customer")
        }
    }
}

struct CustomerDetailView: View {
    let customer: Customer
    
    var body: some View {
        Form {
            Section("Company Information") {
                HStack {
                    Text("Company")
                    Spacer()
                    Text(customer.companyName ?? "Unknown")
                        .foregroundColor(.secondary)
                }
                
                if let contactName = customer.contactName {
                    HStack {
                        Text("Contact")
                        Spacer()
                        Text(contactName)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let contactTitle = customer.contactTitle {
                    HStack {
                        Text("Title")
                        Spacer()
                        Text(contactTitle)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section("Address") {
                if let address = customer.address {
                    Text(address)
                }
                if let city = customer.city {
                    Text(city)
                }
                if let country = customer.country {
                    Text(country)
                }
            }
            
            Section("Orders (\(customer.orders?.count ?? 0))") {
                if let orders = customer.orders?.allObjects as? [Order], !orders.isEmpty {
                    ForEach(orders.sorted { ($0.orderDate ?? Date.distantPast) > ($1.orderDate ?? Date.distantPast) }) { order in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Order #\(order.orderID)")
                                .font(.headline)
                            if let orderDate = order.orderDate {
                                Text("Date: \(orderDate, formatter: dateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Text("Items: \(order.orderDetails?.count ?? 0)")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    Text("No orders")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Customer Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OrdersView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Order.orderDate, ascending: false)],
        animation: .default)
    private var orders: FetchedResults<Order>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orders) { order in
                    NavigationLink {
                        OrderDetailView(order: order)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Order #\(order.orderID)")
                                .font(.headline)
                            Text("Customer: \(order.customer?.companyName ?? "Unknown")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if let orderDate = order.orderDate {
                                Text("Date: \(orderDate, formatter: dateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Text("Items: \(order.orderDetails?.count ?? 0)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text("Freight: $\(order.freight?.stringValue ?? "0")")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .navigationTitle("Orders")
            Text("Select an order")
        }
    }
}

struct OrderDetailView: View {
    let order: Order
    
    var body: some View {
        Form {
            Section("Order Information") {
                HStack {
                    Text("Order ID")
                    Spacer()
                    Text("#\(order.orderID)")
                        .foregroundColor(.secondary)
                }
                
                if let orderDate = order.orderDate {
                    HStack {
                        Text("Order Date")
                        Spacer()
                        Text(orderDate, formatter: dateFormatter)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let shippedDate = order.shippedDate {
                    HStack {
                        Text("Shipped Date")
                        Spacer()
                        Text(shippedDate, formatter: dateFormatter)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text("Freight")
                    Spacer()
                    Text("$\(order.freight?.stringValue ?? "0")")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Customer") {
                if let customer = order.customer {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(customer.companyName ?? "Unknown Customer")
                            .font(.headline)
                        if let contactName = customer.contactName {
                            Text("Contact: \(contactName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    Text("No customer assigned")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Order Details (\(order.orderDetails?.count ?? 0) items)") {
                if let orderDetails = order.orderDetails?.allObjects as? [OrderDetail], !orderDetails.isEmpty {
                    ForEach(orderDetails, id: \.objectID) { detail in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(detail.product?.productName ?? "Unknown Product")
                                .font(.headline)
                            HStack {
                                Text("Qty: \(detail.quantity)")
                                    .font(.caption)
                                Spacer()
                                Text("Price: $\(detail.unitPrice?.stringValue ?? "0")")
                                    .font(.caption)
                                Spacer()
                                if detail.discount > 0 {
                                    Text("Discount: \(Int(detail.discount * 100))%")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                } else {
                    Text("No order details")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CategoriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.categoryName, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.categoryName ?? "Unknown Category")
                            .font(.headline)
                        if let description = category.categoryDescription {
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Text("Products: \(category.products?.count ?? 0)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 2)
                }
            }
            .navigationTitle("Categories")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
