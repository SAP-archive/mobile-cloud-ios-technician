//
// SalesOrderHeaderDetailViewController.swift
// Technician
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 04/07/18
//

import Foundation
import SAPCommon
import SAPFiori
import SAPFoundation
import SAPOData
import SAPOfflineOData

class SalesOrderHeaderDetailViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var espmContainer: ESPMContainer<OfflineODataProvider> {
        return self.appDelegate.espmContainer
    }
    
    private var validity = [String: Bool]()
    private var _entity: SalesOrderHeader?
    private var address : String?
    private let objectHeader = FUIObjectHeader()
    
    var entity: SalesOrderHeader {
        get {
            if self._entity == nil {
                self._entity = self.createEntityWithDefaultValues()
            }
            return self._entity!
        }
        set {
            self._entity = newValue
        }
    }

    private let logger = Logger.shared(named: "SalesOrderHeaderMasterViewControllerLogger")
    var loadingIndicator: FUILoadingIndicatorView?
    var entityUpdater: EntityUpdaterDelegate?
    var tableUpdater: EntitySetUpdaterDelegate?
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    var preventNavigationLoop = false
    var entitySetName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.register(FUITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initUI() {
        do {
            try self.espmContainer.loadProperty(SalesOrderHeader.items, into: self.entity)
        } catch {
           UIFunctionsHelper.handleError(viewController: self, logger: self.logger, error: error)
        }
        
        
        guard let customerDetails = self.entity.customerDetails else {
            return
        }
        
        self.title = ""
        
        //Header
        self.tableView.tableHeaderView = objectHeader
        
        objectHeader.headlineText = "\(customerDetails.firstName ?? "") \(customerDetails.lastName ?? "")"
        
        objectHeader.footnoteText = self.entity.salesOrderID
        
        objectHeader.statusLabel.text = self.entity.lifeCycleStatusName
    }
    
    private func updateUI() {
        objectHeader.statusText = self.entity.lifeCycleStatusName
        
        self.tableView.reloadData()
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "showMapController" {
            self.logger.info("Showing the address of the customer in map controller")
            
            let mapController = segue.destination as! MapViewController
            mapController.customerAddress = self.address
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { //TaskCells
            return self.entity.items.count
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: //Timeline cells
            guard let objectStatus = self.entity.lifeCycleStatus else {
                return UITableViewCell()
            }
            
            return cellForTimeLine(tableView: tableView, indexPath: indexPath, status: objectStatus)
        case 1: //Map Cell
            return self.cellForMap(tableView: tableView, indexPath: indexPath, customer: self.entity.customerDetails!) //Force unwrap because we have checked it before
        case 2: //Task Cells
            let salesItem = self.entity.items[indexPath.row]
            
            do {
                try self.espmContainer.loadProperty(SalesOrderItem.productDetails, into: salesItem)
            } catch {
                UIFunctionsHelper.handleError(viewController: self, logger: self.logger, error: error)
            }
            
            return self.cellForSalesOrderItem(tableView: tableView, indexPath: indexPath, item: salesItem)
        default:
            return UITableViewCell()
        }
    }

    //MARK: TableViewHeader
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        
        switch section {
        case 0:
            view.titleLabel.text = "Timeline"
        case 1:
            view.titleLabel.text = "Address"
        case 2:
            view.titleLabel.text = "Tasks"
        default:
            return nil
        }
        return view
    }
    
    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1 :
             self.performSegue(withIdentifier: "showMapController", sender: self)
             break
        default:
            return
        }
    }

    // MARK: - OData property specific cell creators
    private func cellForMap(tableView: UITableView, indexPath: IndexPath, customer: Customer) -> UITableViewCell {
        let addressFirstLine = "\(customer.street ?? "") \(customer.houseNumber ?? "")"
        let addressSecondLine = "\(customer.postalCode ?? "") \(customer.city ?? "")"
        
        self.address = "\(addressFirstLine) \(addressSecondLine)"
        
        let cell = CellCreationHelper.cellForMap(tableView: tableView, indexPath: indexPath, addressFirstLine: addressFirstLine, addressSecondLine: addressSecondLine)
        
        return cell
    }
    
    
    private func cellForSalesOrderItem(tableView: UITableView, indexPath: IndexPath, item : SalesOrderItem) -> UITableViewCell {
        let productQuery = DataQuery().withKey(Product.key(productID: item.productID))
        
        do {
            let product = try self.espmContainer.fetchProduct(matching: productQuery)
            
        
            let cell = CellCreationHelper.objectCellWithNonEditableContent(tableView: tableView, indexPath: indexPath, key: "Task ID: \(item.itemNumber ?? 0)", value: product.name ?? "")
            cell.accessoryType = .none
            
            return cell
        } catch {
            self.logger.error(error.localizedDescription)
        }
        
        return UITableViewCell()
    }

    private func cellForTimeLine(tableView: UITableView, indexPath: IndexPath, status : String) -> UITableViewCell {
     let timelineData : [FUITimelineItem] = [
            FUITimelineItem(title: "New" , due: Date(), status: .open),
            FUITimelineItem(title: "In Progress" , due: Date(), status: .open),
            FUITimelineItem(title: "Completed" , due: Date(), status: .open),
            FUITimelineItem(title: "" , due: Date(), status: .end)
    ]
        
        if status == "N" {
            timelineData[0].status = .open
            timelineData[1].status = .open
            timelineData[2].status = .open
        } else if status == "I" {
            timelineData[0].status = .complete
            timelineData[1].status = .complete
            timelineData[2].status = .open
        } else {
            timelineData[0].status = .complete
            timelineData[1].status = .complete
            timelineData[2].status = .complete
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FUITimelinePreviewTableViewCell.reuseIdentifier, for: indexPath) as! FUITimelinePreviewTableViewCell
        
        cell.timelinePreviewView.header.isHidden = true
        cell.timelinePreviewView.header.isDisclosureAccessoryHidden = true
        

        cell.timelinePreviewView.addItems(timelineData)
        
        return cell
    }
    
    // MARK: - OData functionalities

    @objc func createEntity() {
        self.showFioriLoadingIndicator()
        self.view.endEditing(true)
        self.logger.info("Creating entity in backend.")
        self.espmContainer.createEntity(self.entity) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Create entry failed. Error: \(error)", error: error)
                let alertController = UIAlertController(title: NSLocalizedString("keyErrorEntityCreationTitle", value: "Create entry failed", comment: "XTIT: Title of alert message about entity creation error."), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: self.okTitle, style: .default))
                OperationQueue.main.addOperation({
                    // Present the alertController
                    self.present(alertController, animated: true)
                })
                return
            }
            self.logger.info("Create entry finished successfully.")
            OperationQueue.main.addOperation({
                self.dismiss(animated: true) {
                    FUIToastMessage.show(message: NSLocalizedString("keyEntityCreationBody", value: "Created", comment: "XMSG: Title of alert message about successful entity creation."))
                    self.tableUpdater?.entitySetHasChanged()
                }
            })
        }
    }

    func createEntityWithDefaultValues() -> SalesOrderHeader {
        let newEntity = SalesOrderHeader()
        // Fill the mandatory properties with default values
        newEntity.customerID = CellCreationHelper.defaultValueFor(SalesOrderHeader.customerID)
        newEntity.lifeCycleStatus = CellCreationHelper.defaultValueFor(SalesOrderHeader.lifeCycleStatus)
        newEntity.lifeCycleStatusName = CellCreationHelper.defaultValueFor(SalesOrderHeader.lifeCycleStatusName)
        newEntity.salesOrderID = CellCreationHelper.defaultValueFor(SalesOrderHeader.salesOrderID)

        // Key properties without default value should be invalid by default for Create scenario
        if newEntity.salesOrderID == nil || newEntity.salesOrderID!.isEmpty {
            self.validity["SalesOrderId"] = false
        }
        return newEntity
    }

    @IBAction func changeStatus(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Status", message:nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "New", style: .default, handler: { (_) in
            self.entity.lifeCycleStatus = "N"
            self.entity.lifeCycleStatusName = "New"
            
            self.updateEntity()
        }))
        
        alertController.addAction(UIAlertAction(title: "In Progress", style: .default, handler: { (_) in
            self.entity.lifeCycleStatus = "I"
            self.entity.lifeCycleStatusName = "In Progress"
            
            self.updateEntity()
        }))
        
        alertController.addAction(UIAlertAction(title: "Completed", style: .default, handler: { (_) in
            self.entity.lifeCycleStatus = "C"
            self.entity.lifeCycleStatusName = "Completed"
            
            self.updateEntity()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateEntity() {
        self.showFioriLoadingIndicator()
        self.view.endEditing(true)
        self.logger.info("Updating entity in backend.")
        self.espmContainer.updateEntity(self.entity) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Update entry failed. Error: \(error)", error: error)
                let alertController = UIAlertController(title: NSLocalizedString("keyErrorEntityUpdateTitle", value: "Update entry failed", comment: "XTIT: Title of alert message about entity update failure."), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: self.okTitle, style: .default))
                OperationQueue.main.addOperation({
                    // Present the alertController
                    self.present(alertController, animated: true)
                })
                return
            }
            self.logger.info("Update entry finished successfully.")
            OperationQueue.main.addOperation({
                self.updateUI()
                
                self.tableUpdater?.entitySetHasChanged()
            })
        }
    }
    
}

extension SalesOrderHeaderDetailViewController: EntityUpdaterDelegate {
    func entityHasChanged(_ entityValue: EntityValue?) {
        if let entity = entityValue {
            let currentEntity = entity as! SalesOrderHeader
            self.entity = currentEntity
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
