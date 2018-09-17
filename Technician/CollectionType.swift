//
// CollectionType.swift
// Technician
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 04/07/18
//

import Foundation

enum CollectionType: String {
    case customers = "Customers"
    case purchaseOrderHeaders = "PurchaseOrderHeaders"
    case stock = "Stock"
    case productTexts = "ProductTexts"
    case salesOrderItems = "SalesOrderItems"
    case products = "Products"
    case productCategories = "ProductCategories"
    case salesOrderHeaders = "SalesOrderHeaders"
    case suppliers = "Suppliers"
    case purchaseOrderItems = "PurchaseOrderItems"
    case none = ""

    static let all = [
        customers, purchaseOrderHeaders, stock, productTexts, salesOrderItems, products, productCategories, salesOrderHeaders, suppliers, purchaseOrderItems,
    ]
}
