// # Proxy Compiler 18.3.1-fe2cc6-20180517

import Foundation
import SAPOData

open class ESPMContainer<Provider: DataServiceProvider>: DataService<Provider> {
    public override init(provider: Provider) {
        super.init(provider: provider)
        self.provider.metadata = ESPMContainerMetadata.document
    }

    @available(swift, deprecated: 4.0, renamed: "fetchCustomers")
    open func customers(query: DataQuery = DataQuery()) throws -> Array<Customer> {
        return try self.fetchCustomers(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchCustomers")
    open func customers(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<Customer>?, Error?) -> Void) {
        self.fetchCustomers(matching: query, completionHandler: completionHandler)
    }

    open func fetchCustomer(matching query: DataQuery) throws -> Customer {
        return try CastRequired<Customer>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.customers)).requiredEntity())
    }

    open func fetchCustomer(matching query: DataQuery, completionHandler: @escaping (Customer?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Customer = try self.fetchCustomer(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchCustomers(matching query: DataQuery = DataQuery()) throws -> Array<Customer> {
        return try Customer.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.customers)).entityList())
    }

    open func fetchCustomers(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<Customer>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<Customer> = try self.fetchCustomers(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchProduct(matching query: DataQuery) throws -> Product {
        return try CastRequired<Product>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.products)).requiredEntity())
    }

    open func fetchProduct(matching query: DataQuery, completionHandler: @escaping (Product?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Product = try self.fetchProduct(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchProductCategories(matching query: DataQuery = DataQuery()) throws -> Array<ProductCategory> {
        return try ProductCategory.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.productCategories)).entityList())
    }

    open func fetchProductCategories(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<ProductCategory>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<ProductCategory> = try self.fetchProductCategories(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchProductCategory(matching query: DataQuery) throws -> ProductCategory {
        return try CastRequired<ProductCategory>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.productCategories)).requiredEntity())
    }

    open func fetchProductCategory(matching query: DataQuery, completionHandler: @escaping (ProductCategory?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: ProductCategory = try self.fetchProductCategory(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchProductText(matching query: DataQuery) throws -> ProductText {
        return try CastRequired<ProductText>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.productTexts)).requiredEntity())
    }

    open func fetchProductText(matching query: DataQuery, completionHandler: @escaping (ProductText?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: ProductText = try self.fetchProductText(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchProductTexts(matching query: DataQuery = DataQuery()) throws -> Array<ProductText> {
        return try ProductText.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.productTexts)).entityList())
    }

    open func fetchProductTexts(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<ProductText>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<ProductText> = try self.fetchProductTexts(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchProducts(matching query: DataQuery = DataQuery()) throws -> Array<Product> {
        return try Product.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.products)).entityList())
    }

    open func fetchProducts(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<Product>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<Product> = try self.fetchProducts(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchPurchaseOrderHeader(matching query: DataQuery) throws -> PurchaseOrderHeader {
        return try CastRequired<PurchaseOrderHeader>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.purchaseOrderHeaders)).requiredEntity())
    }

    open func fetchPurchaseOrderHeader(matching query: DataQuery, completionHandler: @escaping (PurchaseOrderHeader?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: PurchaseOrderHeader = try self.fetchPurchaseOrderHeader(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchPurchaseOrderHeaders(matching query: DataQuery = DataQuery()) throws -> Array<PurchaseOrderHeader> {
        return try PurchaseOrderHeader.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.purchaseOrderHeaders)).entityList())
    }

    open func fetchPurchaseOrderHeaders(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<PurchaseOrderHeader>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<PurchaseOrderHeader> = try self.fetchPurchaseOrderHeaders(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchPurchaseOrderItem(matching query: DataQuery) throws -> PurchaseOrderItem {
        return try CastRequired<PurchaseOrderItem>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.purchaseOrderItems)).requiredEntity())
    }

    open func fetchPurchaseOrderItem(matching query: DataQuery, completionHandler: @escaping (PurchaseOrderItem?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: PurchaseOrderItem = try self.fetchPurchaseOrderItem(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchPurchaseOrderItems(matching query: DataQuery = DataQuery()) throws -> Array<PurchaseOrderItem> {
        return try PurchaseOrderItem.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.purchaseOrderItems)).entityList())
    }

    open func fetchPurchaseOrderItems(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<PurchaseOrderItem>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<PurchaseOrderItem> = try self.fetchPurchaseOrderItems(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchSalesOrderHeader(matching query: DataQuery) throws -> SalesOrderHeader {
        return try CastRequired<SalesOrderHeader>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderHeaders)).requiredEntity())
    }

    open func fetchSalesOrderHeader(matching query: DataQuery, completionHandler: @escaping (SalesOrderHeader?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: SalesOrderHeader = try self.fetchSalesOrderHeader(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchSalesOrderHeaders(matching query: DataQuery = DataQuery()) throws -> Array<SalesOrderHeader> {
        return try SalesOrderHeader.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderHeaders)).entityList())
    }

    open func fetchSalesOrderHeaders(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<SalesOrderHeader>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<SalesOrderHeader> = try self.fetchSalesOrderHeaders(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchSalesOrderItem(matching query: DataQuery) throws -> SalesOrderItem {
        return try CastRequired<SalesOrderItem>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderItems)).requiredEntity())
    }

    open func fetchSalesOrderItem(matching query: DataQuery, completionHandler: @escaping (SalesOrderItem?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: SalesOrderItem = try self.fetchSalesOrderItem(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchSalesOrderItems(matching query: DataQuery = DataQuery()) throws -> Array<SalesOrderItem> {
        return try SalesOrderItem.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderItems)).entityList())
    }

    open func fetchSalesOrderItems(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<SalesOrderItem>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<SalesOrderItem> = try self.fetchSalesOrderItems(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchStock(matching query: DataQuery = DataQuery()) throws -> Array<Stock> {
        return try Stock.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.stock)).entityList())
    }

    open func fetchStock(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<Stock>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<Stock> = try self.fetchStock(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchStock1(matching query: DataQuery) throws -> Stock {
        return try CastRequired<Stock>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.stock)).requiredEntity())
    }

    open func fetchStock1(matching query: DataQuery, completionHandler: @escaping (Stock?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Stock = try self.fetchStock1(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchSupplier(matching query: DataQuery) throws -> Supplier {
        return try CastRequired<Supplier>.from(self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.suppliers)).requiredEntity())
    }

    open func fetchSupplier(matching query: DataQuery, completionHandler: @escaping (Supplier?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Supplier = try self.fetchSupplier(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchSuppliers(matching query: DataQuery = DataQuery()) throws -> Array<Supplier> {
        return try Supplier.array(from: self.executeQuery(query.fromDefault(ESPMContainerMetadata.EntitySets.suppliers)).entityList())
    }

    open func fetchSuppliers(matching query: DataQuery = DataQuery(), completionHandler: @escaping (Array<Supplier>?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Array<Supplier> = try self.fetchSuppliers(matching: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func generateSamplePurchaseOrders(query: DataQuery = DataQuery()) throws -> Bool? {
        return try BooleanValue.optional(self.executeQuery(query.invoke(ESPMContainerMetadata.ActionImports.generateSamplePurchaseOrders, ParameterList.empty)).result)
    }

    open func generateSamplePurchaseOrders(query: DataQuery = DataQuery(), completionHandler: @escaping (Bool?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Bool? = try self.generateSamplePurchaseOrders(query: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func generateSampleSalesOrders(query: DataQuery = DataQuery()) throws -> Bool? {
        return try BooleanValue.optional(self.executeQuery(query.invoke(ESPMContainerMetadata.ActionImports.generateSampleSalesOrders, ParameterList.empty)).result)
    }

    open func generateSampleSalesOrders(query: DataQuery = DataQuery(), completionHandler: @escaping (Bool?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Bool? = try self.generateSampleSalesOrders(query: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    @available(swift, deprecated: 4.0, renamed: "fetchProductCategories")
    open func productCategories(query: DataQuery = DataQuery()) throws -> Array<ProductCategory> {
        return try self.fetchProductCategories(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchProductCategories")
    open func productCategories(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<ProductCategory>?, Error?) -> Void) {
        self.fetchProductCategories(matching: query, completionHandler: completionHandler)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchProductTexts")
    open func productTexts(query: DataQuery = DataQuery()) throws -> Array<ProductText> {
        return try self.fetchProductTexts(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchProductTexts")
    open func productTexts(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<ProductText>?, Error?) -> Void) {
        self.fetchProductTexts(matching: query, completionHandler: completionHandler)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchProducts")
    open func products(query: DataQuery = DataQuery()) throws -> Array<Product> {
        return try self.fetchProducts(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchProducts")
    open func products(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<Product>?, Error?) -> Void) {
        self.fetchProducts(matching: query, completionHandler: completionHandler)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchPurchaseOrderHeaders")
    open func purchaseOrderHeaders(query: DataQuery = DataQuery()) throws -> Array<PurchaseOrderHeader> {
        return try self.fetchPurchaseOrderHeaders(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchPurchaseOrderHeaders")
    open func purchaseOrderHeaders(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<PurchaseOrderHeader>?, Error?) -> Void) {
        self.fetchPurchaseOrderHeaders(matching: query, completionHandler: completionHandler)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchPurchaseOrderItems")
    open func purchaseOrderItems(query: DataQuery = DataQuery()) throws -> Array<PurchaseOrderItem> {
        return try self.fetchPurchaseOrderItems(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchPurchaseOrderItems")
    open func purchaseOrderItems(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<PurchaseOrderItem>?, Error?) -> Void) {
        self.fetchPurchaseOrderItems(matching: query, completionHandler: completionHandler)
    }

    open override func refreshMetadata() throws {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        do {
            try ProxyInternal.refreshMetadata(service: self, fetcher: nil, options: ESPMContainerMetadataParser.options)
            ESPMContainerMetadataChanges.merge(metadata: self.metadata)
        }
    }

    open func resetSampleData(query: DataQuery = DataQuery()) throws -> Bool? {
        return try BooleanValue.optional(self.executeQuery(query.invoke(ESPMContainerMetadata.ActionImports.resetSampleData, ParameterList.empty)).result)
    }

    open func resetSampleData(query: DataQuery = DataQuery(), completionHandler: @escaping (Bool?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Bool? = try self.resetSampleData(query: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    @available(swift, deprecated: 4.0, renamed: "fetchSalesOrderHeaders")
    open func salesOrderHeaders(query: DataQuery = DataQuery()) throws -> Array<SalesOrderHeader> {
        return try self.fetchSalesOrderHeaders(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchSalesOrderHeaders")
    open func salesOrderHeaders(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<SalesOrderHeader>?, Error?) -> Void) {
        self.fetchSalesOrderHeaders(matching: query, completionHandler: completionHandler)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchSalesOrderItems")
    open func salesOrderItems(query: DataQuery = DataQuery()) throws -> Array<SalesOrderItem> {
        return try self.fetchSalesOrderItems(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchSalesOrderItems")
    open func salesOrderItems(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<SalesOrderItem>?, Error?) -> Void) {
        self.fetchSalesOrderItems(matching: query, completionHandler: completionHandler)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchStock")
    open func stock(query: DataQuery = DataQuery()) throws -> Array<Stock> {
        return try self.fetchStock(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchStock")
    open func stock(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<Stock>?, Error?) -> Void) {
        self.fetchStock(matching: query, completionHandler: completionHandler)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchSuppliers")
    open func suppliers(query: DataQuery = DataQuery()) throws -> Array<Supplier> {
        return try self.fetchSuppliers(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchSuppliers")
    open func suppliers(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<Supplier>?, Error?) -> Void) {
        self.fetchSuppliers(matching: query, completionHandler: completionHandler)
    }

    open func updateSalesOrderStatus(id: String, newStatus: String, query: DataQuery = DataQuery()) throws -> Bool? {
        return try BooleanValue.optional(self.executeQuery(query.invoke(ESPMContainerMetadata.ActionImports.updateSalesOrderStatus, ParameterList(capacity: (2 as Int)).with(name: "id", value: StringValue.of(id)).with(name: "newStatus", value: StringValue.of(newStatus)))).result)
    }

    open func updateSalesOrderStatus(id: String, newStatus: String, query: DataQuery = DataQuery(), completionHandler: @escaping (Bool?, Error?) -> Void) {
        self.addBackgroundOperation {
            do {
                let result: Bool? = try self.updateSalesOrderStatus(id: id, newStatus: newStatus, query: query)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }
}
