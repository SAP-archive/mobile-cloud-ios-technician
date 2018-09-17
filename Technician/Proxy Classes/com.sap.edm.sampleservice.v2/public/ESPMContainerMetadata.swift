// # Proxy Compiler 18.3.1-fe2cc6-20180517

import Foundation
import SAPOData

public class ESPMContainerMetadata {
    public static var document: CSDLDocument = ESPMContainerMetadata.resolve()

    private static func resolve() -> CSDLDocument {
        try! ESPMContainerFactory.registerAll()
        ESPMContainerMetadataParser.parsed.hasGeneratedProxies = true
        return ESPMContainerMetadataParser.parsed
    }

    public class EntityTypes {
        public static var customer: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.Customer")

        public static var product: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.Product")

        public static var productCategory: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.ProductCategory")

        public static var productText: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.ProductText")

        public static var purchaseOrderHeader: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.PurchaseOrderHeader")

        public static var purchaseOrderItem: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.PurchaseOrderItem")

        public static var salesOrderHeader: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.SalesOrderHeader")

        public static var salesOrderItem: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.SalesOrderItem")

        public static var stock: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.Stock")

        public static var supplier: EntityType = ESPMContainerMetadataParser.parsed.entityType(withName: "ESPM.Supplier")
    }

    public class EntitySets {
        public static var customers: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "Customers")

        public static var productCategories: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "ProductCategories")

        public static var productTexts: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "ProductTexts")

        public static var products: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "Products")

        public static var purchaseOrderHeaders: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "PurchaseOrderHeaders")

        public static var purchaseOrderItems: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "PurchaseOrderItems")

        public static var salesOrderHeaders: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "SalesOrderHeaders")

        public static var salesOrderItems: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "SalesOrderItems")

        public static var stock: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "Stock")

        public static var suppliers: EntitySet = ESPMContainerMetadataParser.parsed.entitySet(withName: "Suppliers")
    }

    public class ActionImports {
        public static var generateSamplePurchaseOrders: DataMethod = ESPMContainerMetadataParser.parsed.dataMethod(withName: "GenerateSamplePurchaseOrders")

        public static var generateSampleSalesOrders: DataMethod = ESPMContainerMetadataParser.parsed.dataMethod(withName: "GenerateSampleSalesOrders")

        public static var resetSampleData: DataMethod = ESPMContainerMetadataParser.parsed.dataMethod(withName: "ResetSampleData")

        public static var updateSalesOrderStatus: DataMethod = ESPMContainerMetadataParser.parsed.dataMethod(withName: "UpdateSalesOrderStatus")
    }
}
