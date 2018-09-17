// # Proxy Compiler 18.3.1-fe2cc6-20180517

import Foundation
import SAPOData

open class PurchaseOrderItem: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public static var currencyCode: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "CurrencyCode")

    public static var grossAmount: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "GrossAmount")

    public static var itemNumber: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "ItemNumber")

    public static var netAmount: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "NetAmount")

    public static var productID: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "ProductId")

    public static var purchaseOrderID: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "PurchaseOrderId")

    public static var quantity: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "Quantity")

    public static var quantityUnit: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "QuantityUnit")

    public static var taxAmount: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "TaxAmount")

    public static var header: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "Header")

    public static var productDetails: Property = ESPMContainerMetadata.EntityTypes.purchaseOrderItem.property(withName: "ProductDetails")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: ESPMContainerMetadata.EntityTypes.purchaseOrderItem)
    }

    open class func array(from: EntityValueList) -> Array<PurchaseOrderItem> {
        return ArrayConverter.convert(from.toArray(), Array<PurchaseOrderItem>())
    }

    open func copy() -> PurchaseOrderItem {
        return CastRequired<PurchaseOrderItem>.from(self.copyEntity())
    }

    open var currencyCode: String? {
        get {
            return StringValue.optional(self.optionalValue(for: PurchaseOrderItem.currencyCode))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.currencyCode, to: StringValue.of(optional: value))
        }
    }

    open var grossAmount: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: PurchaseOrderItem.grossAmount))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.grossAmount, to: DecimalValue.of(optional: value))
        }
    }

    open var header: PurchaseOrderHeader? {
        get {
            return CastOptional<PurchaseOrderHeader>.from(self.optionalValue(for: PurchaseOrderItem.header))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.header, to: value)
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open var itemNumber: Int? {
        get {
            return IntValue.optional(self.optionalValue(for: PurchaseOrderItem.itemNumber))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.itemNumber, to: IntValue.of(optional: value))
        }
    }

    open class func key(itemNumber: Int?, purchaseOrderID: String?) -> EntityKey {
        return EntityKey().with(name: "ItemNumber", value: IntValue.of(optional: itemNumber)).with(name: "PurchaseOrderId", value: StringValue.of(optional: purchaseOrderID))
    }

    open var netAmount: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: PurchaseOrderItem.netAmount))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.netAmount, to: DecimalValue.of(optional: value))
        }
    }

    open var old: PurchaseOrderItem {
        return CastRequired<PurchaseOrderItem>.from(self.oldEntity)
    }

    open var productDetails: Product? {
        get {
            return CastOptional<Product>.from(self.optionalValue(for: PurchaseOrderItem.productDetails))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.productDetails, to: value)
        }
    }

    open var productID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: PurchaseOrderItem.productID))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.productID, to: StringValue.of(optional: value))
        }
    }

    open var purchaseOrderID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: PurchaseOrderItem.purchaseOrderID))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.purchaseOrderID, to: StringValue.of(optional: value))
        }
    }

    open var quantity: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: PurchaseOrderItem.quantity))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.quantity, to: DecimalValue.of(optional: value))
        }
    }

    open var quantityUnit: String? {
        get {
            return StringValue.optional(self.optionalValue(for: PurchaseOrderItem.quantityUnit))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.quantityUnit, to: StringValue.of(optional: value))
        }
    }

    open var taxAmount: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: PurchaseOrderItem.taxAmount))
        }
        set(value) {
            self.setOptionalValue(for: PurchaseOrderItem.taxAmount, to: DecimalValue.of(optional: value))
        }
    }
}
