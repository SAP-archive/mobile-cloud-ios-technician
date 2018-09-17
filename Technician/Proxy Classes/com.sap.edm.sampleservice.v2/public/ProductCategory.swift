// # Proxy Compiler 18.3.1-fe2cc6-20180517

import Foundation
import SAPOData

open class ProductCategory: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public static var category: Property = ESPMContainerMetadata.EntityTypes.productCategory.property(withName: "Category")

    public static var categoryName: Property = ESPMContainerMetadata.EntityTypes.productCategory.property(withName: "CategoryName")

    public static var mainCategory: Property = ESPMContainerMetadata.EntityTypes.productCategory.property(withName: "MainCategory")

    public static var mainCategoryName: Property = ESPMContainerMetadata.EntityTypes.productCategory.property(withName: "MainCategoryName")

    public static var numberOfProducts: Property = ESPMContainerMetadata.EntityTypes.productCategory.property(withName: "NumberOfProducts")

    public static var updatedTimestamp: Property = ESPMContainerMetadata.EntityTypes.productCategory.property(withName: "UpdatedTimestamp")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: ESPMContainerMetadata.EntityTypes.productCategory)
    }

    open class func array(from: EntityValueList) -> Array<ProductCategory> {
        return ArrayConverter.convert(from.toArray(), Array<ProductCategory>())
    }

    open var category: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ProductCategory.category))
        }
        set(value) {
            self.setOptionalValue(for: ProductCategory.category, to: StringValue.of(optional: value))
        }
    }

    open var categoryName: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ProductCategory.categoryName))
        }
        set(value) {
            self.setOptionalValue(for: ProductCategory.categoryName, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> ProductCategory {
        return CastRequired<ProductCategory>.from(self.copyEntity())
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(category: String?) -> EntityKey {
        return EntityKey().with(name: "Category", value: StringValue.of(optional: category))
    }

    open var mainCategory: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ProductCategory.mainCategory))
        }
        set(value) {
            self.setOptionalValue(for: ProductCategory.mainCategory, to: StringValue.of(optional: value))
        }
    }

    open var mainCategoryName: String? {
        get {
            return StringValue.optional(self.optionalValue(for: ProductCategory.mainCategoryName))
        }
        set(value) {
            self.setOptionalValue(for: ProductCategory.mainCategoryName, to: StringValue.of(optional: value))
        }
    }

    open var numberOfProducts: Int64? {
        get {
            return LongValue.optional(self.optionalValue(for: ProductCategory.numberOfProducts))
        }
        set(value) {
            self.setOptionalValue(for: ProductCategory.numberOfProducts, to: LongValue.of(optional: value))
        }
    }

    open var old: ProductCategory {
        return CastRequired<ProductCategory>.from(self.oldEntity)
    }

    open var updatedTimestamp: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: ProductCategory.updatedTimestamp))
        }
        set(value) {
            self.setOptionalValue(for: ProductCategory.updatedTimestamp, to: value)
        }
    }
}
