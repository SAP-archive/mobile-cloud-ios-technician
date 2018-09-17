// # Proxy Compiler 18.3.1-fe2cc6-20180517

import Foundation
import SAPOData

open class Stock: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public static var lotSize: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "LotSize")

    public static var minStock: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "MinStock")

    public static var productID: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "ProductId")

    public static var quantity: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "Quantity")

    public static var quantityLessMin: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "QuantityLessMin")

    public static var updatedTimestamp: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "UpdatedTimestamp")

    public static var productDetails: Property = ESPMContainerMetadata.EntityTypes.stock.property(withName: "ProductDetails")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: ESPMContainerMetadata.EntityTypes.stock)
    }

    open class func array(from: EntityValueList) -> Array<Stock> {
        return ArrayConverter.convert(from.toArray(), Array<Stock>())
    }

    open func copy() -> Stock {
        return CastRequired<Stock>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(productID: String?) -> EntityKey {
        return EntityKey().with(name: "ProductId", value: StringValue.of(optional: productID))
    }

    open var lotSize: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Stock.lotSize))
        }
        set(value) {
            self.setOptionalValue(for: Stock.lotSize, to: DecimalValue.of(optional: value))
        }
    }

    open var minStock: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Stock.minStock))
        }
        set(value) {
            self.setOptionalValue(for: Stock.minStock, to: DecimalValue.of(optional: value))
        }
    }

    open var old: Stock {
        return CastRequired<Stock>.from(self.oldEntity)
    }

    open var productDetails: Product? {
        get {
            return CastOptional<Product>.from(self.optionalValue(for: Stock.productDetails))
        }
        set(value) {
            self.setOptionalValue(for: Stock.productDetails, to: value)
        }
    }

    open var productID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Stock.productID))
        }
        set(value) {
            self.setOptionalValue(for: Stock.productID, to: StringValue.of(optional: value))
        }
    }

    open var quantity: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Stock.quantity))
        }
        set(value) {
            self.setOptionalValue(for: Stock.quantity, to: DecimalValue.of(optional: value))
        }
    }

    open var quantityLessMin: Bool? {
        get {
            return BooleanValue.optional(self.optionalValue(for: Stock.quantityLessMin))
        }
        set(value) {
            self.setOptionalValue(for: Stock.quantityLessMin, to: BooleanValue.of(optional: value))
        }
    }

    open var updatedTimestamp: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: Stock.updatedTimestamp))
        }
        set(value) {
            self.setOptionalValue(for: Stock.updatedTimestamp, to: value)
        }
    }
}
