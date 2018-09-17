// # Proxy Compiler 18.3.1-fe2cc6-20180517

import Foundation
import SAPOData

open class Product: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public static var category: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "Category")

    public static var categoryName: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "CategoryName")

    public static var currencyCode: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "CurrencyCode")

    public static var dimensionDepth: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "DimensionDepth")

    public static var dimensionHeight: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "DimensionHeight")

    public static var dimensionUnit: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "DimensionUnit")

    public static var dimensionWidth: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "DimensionWidth")

    public static var longDescription: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "LongDescription")

    public static var name: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "Name")

    public static var pictureUrl: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "PictureUrl")

    public static var price: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "Price")

    public static var productID: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "ProductId")

    public static var quantityUnit: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "QuantityUnit")

    public static var shortDescription: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "ShortDescription")

    public static var supplierID: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "SupplierId")

    public static var updatedTimestamp: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "UpdatedTimestamp")

    public static var weight: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "Weight")

    public static var weightUnit: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "WeightUnit")

    public static var stockDetails: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "StockDetails")

    public static var supplierDetails: Property = ESPMContainerMetadata.EntityTypes.product.property(withName: "SupplierDetails")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: ESPMContainerMetadata.EntityTypes.product)
    }

    open class func array(from: EntityValueList) -> Array<Product> {
        return ArrayConverter.convert(from.toArray(), Array<Product>())
    }

    open var category: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.category))
        }
        set(value) {
            self.setOptionalValue(for: Product.category, to: StringValue.of(optional: value))
        }
    }

    open var categoryName: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.categoryName))
        }
        set(value) {
            self.setOptionalValue(for: Product.categoryName, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> Product {
        return CastRequired<Product>.from(self.copyEntity())
    }

    open var currencyCode: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.currencyCode))
        }
        set(value) {
            self.setOptionalValue(for: Product.currencyCode, to: StringValue.of(optional: value))
        }
    }

    open var dimensionDepth: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Product.dimensionDepth))
        }
        set(value) {
            self.setOptionalValue(for: Product.dimensionDepth, to: DecimalValue.of(optional: value))
        }
    }

    open var dimensionHeight: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Product.dimensionHeight))
        }
        set(value) {
            self.setOptionalValue(for: Product.dimensionHeight, to: DecimalValue.of(optional: value))
        }
    }

    open var dimensionUnit: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.dimensionUnit))
        }
        set(value) {
            self.setOptionalValue(for: Product.dimensionUnit, to: StringValue.of(optional: value))
        }
    }

    open var dimensionWidth: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Product.dimensionWidth))
        }
        set(value) {
            self.setOptionalValue(for: Product.dimensionWidth, to: DecimalValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(productID: String?) -> EntityKey {
        return EntityKey().with(name: "ProductId", value: StringValue.of(optional: productID))
    }

    open var longDescription: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.longDescription))
        }
        set(value) {
            self.setOptionalValue(for: Product.longDescription, to: StringValue.of(optional: value))
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.name))
        }
        set(value) {
            self.setOptionalValue(for: Product.name, to: StringValue.of(optional: value))
        }
    }

    open var old: Product {
        return CastRequired<Product>.from(self.oldEntity)
    }

    open var pictureUrl: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.pictureUrl))
        }
        set(value) {
            self.setOptionalValue(for: Product.pictureUrl, to: StringValue.of(optional: value))
        }
    }

    open var price: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Product.price))
        }
        set(value) {
            self.setOptionalValue(for: Product.price, to: DecimalValue.of(optional: value))
        }
    }

    open var productID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.productID))
        }
        set(value) {
            self.setOptionalValue(for: Product.productID, to: StringValue.of(optional: value))
        }
    }

    open var quantityUnit: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.quantityUnit))
        }
        set(value) {
            self.setOptionalValue(for: Product.quantityUnit, to: StringValue.of(optional: value))
        }
    }

    open var shortDescription: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.shortDescription))
        }
        set(value) {
            self.setOptionalValue(for: Product.shortDescription, to: StringValue.of(optional: value))
        }
    }

    open var stockDetails: Stock? {
        get {
            return CastOptional<Stock>.from(self.optionalValue(for: Product.stockDetails))
        }
        set(value) {
            self.setOptionalValue(for: Product.stockDetails, to: value)
        }
    }

    open var supplierDetails: Supplier? {
        get {
            return CastOptional<Supplier>.from(self.optionalValue(for: Product.supplierDetails))
        }
        set(value) {
            self.setOptionalValue(for: Product.supplierDetails, to: value)
        }
    }

    open var supplierID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.supplierID))
        }
        set(value) {
            self.setOptionalValue(for: Product.supplierID, to: StringValue.of(optional: value))
        }
    }

    open var updatedTimestamp: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: Product.updatedTimestamp))
        }
        set(value) {
            self.setOptionalValue(for: Product.updatedTimestamp, to: value)
        }
    }

    open var weight: BigDecimal? {
        get {
            return DecimalValue.optional(self.optionalValue(for: Product.weight))
        }
        set(value) {
            self.setOptionalValue(for: Product.weight, to: DecimalValue.of(optional: value))
        }
    }

    open var weightUnit: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Product.weightUnit))
        }
        set(value) {
            self.setOptionalValue(for: Product.weightUnit, to: StringValue.of(optional: value))
        }
    }
}
