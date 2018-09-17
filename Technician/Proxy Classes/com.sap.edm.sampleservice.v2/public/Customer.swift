// # Proxy Compiler 18.3.1-fe2cc6-20180517

import Foundation
import SAPOData

open class Customer: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public static var city: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "City")

    public static var country: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "Country")

    public static var customerID: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "CustomerId")

    public static var dateOfBirth: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "DateOfBirth")

    public static var emailAddress: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "EmailAddress")

    public static var firstName: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "FirstName")

    public static var houseNumber: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "HouseNumber")

    public static var lastName: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "LastName")

    public static var phoneNumber: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "PhoneNumber")

    public static var postalCode: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "PostalCode")

    public static var street: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "Street")

    public static var updatedTimestamp: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "UpdatedTimestamp")

    public static var salesOrders: Property = ESPMContainerMetadata.EntityTypes.customer.property(withName: "SalesOrders")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: ESPMContainerMetadata.EntityTypes.customer)
    }

    open class func array(from: EntityValueList) -> Array<Customer> {
        return ArrayConverter.convert(from.toArray(), Array<Customer>())
    }

    open var city: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.city))
        }
        set(value) {
            self.setOptionalValue(for: Customer.city, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> Customer {
        return CastRequired<Customer>.from(self.copyEntity())
    }

    open var country: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.country))
        }
        set(value) {
            self.setOptionalValue(for: Customer.country, to: StringValue.of(optional: value))
        }
    }

    open var customerID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.customerID))
        }
        set(value) {
            self.setOptionalValue(for: Customer.customerID, to: StringValue.of(optional: value))
        }
    }

    open var dateOfBirth: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: Customer.dateOfBirth))
        }
        set(value) {
            self.setOptionalValue(for: Customer.dateOfBirth, to: value)
        }
    }

    open var emailAddress: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.emailAddress))
        }
        set(value) {
            self.setOptionalValue(for: Customer.emailAddress, to: StringValue.of(optional: value))
        }
    }

    open var firstName: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.firstName))
        }
        set(value) {
            self.setOptionalValue(for: Customer.firstName, to: StringValue.of(optional: value))
        }
    }

    open var houseNumber: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.houseNumber))
        }
        set(value) {
            self.setOptionalValue(for: Customer.houseNumber, to: StringValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(customerID: String?) -> EntityKey {
        return EntityKey().with(name: "CustomerId", value: StringValue.of(optional: customerID))
    }

    open var lastName: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.lastName))
        }
        set(value) {
            self.setOptionalValue(for: Customer.lastName, to: StringValue.of(optional: value))
        }
    }

    open var old: Customer {
        return CastRequired<Customer>.from(self.oldEntity)
    }

    open var phoneNumber: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.phoneNumber))
        }
        set(value) {
            self.setOptionalValue(for: Customer.phoneNumber, to: StringValue.of(optional: value))
        }
    }

    open var postalCode: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.postalCode))
        }
        set(value) {
            self.setOptionalValue(for: Customer.postalCode, to: StringValue.of(optional: value))
        }
    }

    open var salesOrders: Array<SalesOrderHeader> {
        get {
            return ArrayConverter.convert(EntityValueList.castRequired(self.requiredValue(for: Customer.salesOrders)).toArray(), Array<SalesOrderHeader>())
        }
        set(value) {
            Customer.salesOrders.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, Array<EntityValue>())))
        }
    }

    open var street: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Customer.street))
        }
        set(value) {
            self.setOptionalValue(for: Customer.street, to: StringValue.of(optional: value))
        }
    }

    open var updatedTimestamp: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: Customer.updatedTimestamp))
        }
        set(value) {
            self.setOptionalValue(for: Customer.updatedTimestamp, to: value)
        }
    }
}
