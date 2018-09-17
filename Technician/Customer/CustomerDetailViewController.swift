//
// CustomerDetailViewController.swift
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

class CustomerDetailViewController: FUIFormTableViewController, SAPFioriLoadingIndicator, MFMailComposeViewControllerDelegate {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var espmContainer: ESPMContainer<OfflineODataProvider> {
        return self.appDelegate.espmContainer
    }

    private var validity = [String: Bool]()
    private var _entity: Customer?
    
    private var address : String? = nil
    
    var allowsEditableCells = false
    var entity: Customer {
        get {
            return self._entity!
        }
        set {
            self._entity = newValue
        }
    }

    private let logger = Logger.shared(named: "CustomerMasterViewControllerLogger")
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

    func initUI() {
        self.title = ""
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return cellForCustomer(tableView: tableView, indexPath: indexPath, currentEntity: self.entity)
        } else if indexPath.section == 1 {
           return cellForMap(tableView: tableView, indexPath: indexPath, currentEntity: self.entity)
        }
        
        return UITableViewCell()
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //MARK: TableViewHeader
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        
        switch section {
        case 0:
            view.titleLabel.text = "Customer"
        case 1:
            view.titleLabel.text = "Address"
        default:
            return nil
        }
        
        return view
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "showMapController", sender: self)
        }
    }
    
    // MARK: - OData property specific cell creators
    private func cellForCustomer(tableView: UITableView, indexPath: IndexPath, currentEntity : Customer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIContactCell.reuseIdentifier) as! FUIContactCell
        
        cell.headlineText = "\(currentEntity.firstName ?? "") \(currentEntity.lastName ?? "")"
        cell.subheadlineText = "\(currentEntity.dateOfBirth!)"
        cell.activityControl.addActivities( [FUIActivityItem.phone, FUIActivityItem.message])
        
        // Implement onActivitySelectedHandler.
        cell.onActivitySelectedHandler = { activityItem in
            
            switch activityItem {
            case FUIActivityItem.phone:
                UIFunctionsHelper.openPhoneNumber(phoneNumber: currentEntity.phoneNumber ?? "")
                break
            case FUIActivityItem.message:
                UIFunctionsHelper.openMail(viewController: self, delegate: self, logger: self.logger, emailAddress: currentEntity.emailAddress ?? "")
                break
            default:
                break
            }
        }
        
        return cell
    }

    
    private func cellForMap(tableView: UITableView, indexPath: IndexPath, currentEntity: Customer) -> UITableViewCell {
        let addressFirstLine = "\(currentEntity.street ?? "") \(currentEntity.houseNumber ?? "")"
        let addressSecondLine = "\(currentEntity.postalCode ?? "") \(currentEntity.city ?? "")"
        
        self.address = "\(addressFirstLine) \(addressSecondLine)"
        
        let cell = CellCreationHelper.cellForMap(tableView: tableView, indexPath: indexPath, addressFirstLine: addressFirstLine, addressSecondLine: addressSecondLine)
        
        return cell
    }
    
    //MARK: MFMailComposerViewController Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension CustomerDetailViewController: EntityUpdaterDelegate {
    func entityHasChanged(_ entityValue: EntityValue?) {
        if let entity = entityValue {
            let currentEntity = entity as! Customer
            self.entity = currentEntity
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
