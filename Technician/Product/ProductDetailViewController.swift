//
// ProductDetailViewController.swift
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
import MessageUI

class ProductDetailViewController: FUIFormTableViewController, SAPFioriLoadingIndicator, MFMailComposeViewControllerDelegate {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var espmContainer: ESPMContainer<OfflineODataProvider> {
        return self.appDelegate.espmContainer
    }

    let objectHeader = FUIObjectHeader()
    var address : String?
    
    private var validity = [String: Bool]()
    private var _entity: Product?
    var entity: Product {
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

    private let logger = Logger.shared(named: "ProductMasterViewControllerLogger")
    var loadingIndicator: FUILoadingIndicatorView?
    var entityUpdater: EntityUpdaterDelegate?
    var tableUpdater: EntitySetUpdaterDelegate?
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
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
        //Load Data
        do {
            try self.espmContainer.loadProperty(Product.supplierDetails, into: self.entity)
            try self.espmContainer.loadProperty(Product.stockDetails, into: self.entity)
        } catch {
            UIFunctionsHelper.handleError(viewController: self, logger: self.logger, error: error)
        }
        
        self.title = ""
        
        //Header
        self.tableView.tableHeaderView = objectHeader
        
        objectHeader.headlineText = "\(self.entity.name ?? "")"
        objectHeader.footnoteText = self.entity.productID
        
        objectHeader.statusText = "\(self.entity.price ?? BigDecimal(0.0) )"
        objectHeader.substatusText = "\(self.entity.currencyCode ?? "EUR")"
        
        
       // let imageExtension = self.entity.pictureUrl?.replacingOccurrences(of: "/SampleServices/ESPM.svc", with: "")
        let imageURL =  URL(string: (self.entity.pictureUrl ?? "") )!
        
        getDataFromUrl(url: imageURL) { data, response, error in
            guard let imageData = data, error == nil else {
                self.logger.error(error?.localizedDescription ?? "Unkown error during downloading image for product")
                return
            }

            self.logger.info("Product image downloaded")
            DispatchQueue.main.async() {
                self.objectHeader.detailImage = UIImage(data: imageData)
            }
        }
       
    }
    
    //MARK: TableViewHeader
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        
        switch section {
        case 0:
            view.titleLabel.text = "Supplier"
        case 1:
            view.titleLabel.text = "Stock"
        default:
            return nil
        }
        return view
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
        return 2
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return self.cellForSupplier(tableView: tableView, indexPath: indexPath, supplier: self.entity.supplierDetails!) //Force unwrap because we have loaded it before
            } else {
                return self.cellForMap(tableView: tableView, indexPath: indexPath, currentEntity: self.entity.supplierDetails!) //Force unwrap because we have loaded it before
            }
        case 1:
            if indexPath.row == 0 {
                return self.cellForMinStock(tableView: tableView, indexPath: indexPath, currentEntity: self.entity.stockDetails!) //Force unwrap because we have loaded it before
            } else {
                return self.cellForQuanity(tableView: tableView, indexPath: indexPath, currentEntity: self.entity.stockDetails!) //Force unwrap because we have loaded it before
            }
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            self.performSegue(withIdentifier: "showMapController", sender: self)
        }
    }

    // MARK: - OData property specific cell creators

    private func cellForSupplier(tableView: UITableView, indexPath: IndexPath, supplier : Supplier) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIContactCell.reuseIdentifier) as! FUIContactCell
        
        cell.headlineText = supplier.supplierName
        cell.subheadlineText = supplier.supplierID
        cell.activityControl.addActivities( [FUIActivityItem.phone, FUIActivityItem.message])
        
        // Implement onActivitySelectedHandler.
        cell.onActivitySelectedHandler = { activityItem in
            
            switch activityItem {
            case FUIActivityItem.phone:
                UIFunctionsHelper.openPhoneNumber(phoneNumber: self.entity.supplierDetails!.phoneNumber ?? "")
                break
            case FUIActivityItem.message:
                UIFunctionsHelper.openMail(viewController: self, delegate: self, logger: self.logger, emailAddress: self.entity.supplierDetails!.emailAddress ?? "")
                break
            default:
                break
            }
        }
        
        return cell
    }

    private func cellForMap(tableView: UITableView, indexPath: IndexPath, currentEntity: Supplier) -> UITableViewCell {
        let addressFirstLine = "\(currentEntity.street ?? "") \(currentEntity.houseNumber ?? "")"
        let addressSecondLine = "\(currentEntity.postalCode ?? "") \(currentEntity.city ?? "")"
        
        self.address = "\(addressFirstLine) \(addressSecondLine)"
        
        let cell = CellCreationHelper.cellForMap(tableView: tableView, indexPath: indexPath, addressFirstLine: addressFirstLine, addressSecondLine: addressSecondLine)
        
        return cell
    }
    
    private func cellForMinStock(tableView: UITableView, indexPath: IndexPath, currentEntity: Stock) -> UITableViewCell {
        let cell = CellCreationHelper.objectCellWithNonEditableContent(tableView: tableView, indexPath: indexPath, key: "Min Stock", value: "\(currentEntity.minStock ?? BigDecimal(0) )")
        cell.accessoryType = .none
        
        return cell
    }
    
    private func cellForQuanity(tableView: UITableView, indexPath: IndexPath, currentEntity: Stock) -> UITableViewCell {
        let cell =  CellCreationHelper.objectCellWithNonEditableContent(tableView: tableView, indexPath: indexPath, key: "Quantity", value: "\(currentEntity.quantity ?? BigDecimal(0) )")
        
        cell.accessoryType = .none
        
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

    func createEntityWithDefaultValues() -> Product {
        let newEntity = Product()
        // Fill the mandatory properties with default values
        newEntity.productID = CellCreationHelper.defaultValueFor(Product.productID)
        newEntity.supplierID = CellCreationHelper.defaultValueFor(Product.supplierID)

        // Key properties without default value should be invalid by default for Create scenario
        if newEntity.productID == nil || newEntity.productID!.isEmpty {
            self.validity["ProductId"] = false
        }
        
        return newEntity
    }

    @objc func updateEntity(_: AnyObject) {
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
                self.dismiss(animated: true) {
                    FUIToastMessage.show(message: NSLocalizedString("keyUpdateEntityFinishedTitle", value: "Updated", comment: "XTIT: Title of alert message about successful entity update."))
                    self.entityUpdater?.entityHasChanged(self.entity)
                }
            })
        }
    }

    //MARK: MFMailComposerViewController Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        self.appDelegate.globalSession?.dataTask(with: url, completionHandler: { (data,response, error) in
             completion(data, response, error)
        }).resume()
    }
}

extension ProductDetailViewController: EntityUpdaterDelegate {
    func entityHasChanged(_ entityValue: EntityValue?) {
        if let entity = entityValue {
            let currentEntity = entity as! Product
            self.entity = currentEntity
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
