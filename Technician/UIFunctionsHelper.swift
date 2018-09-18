//
//  UIFunctionsHelper.swift
//  Technician
//
//  Created by Kasseckert, Nils on 09.07.18.
//  Copyright © 2018 SAP. All rights reserved.
//

import UIKit
import SAPCommon
import MessageUI
import SAPFiori
import SAPOData

class UIFunctionsHelper: NSObject {
    private static let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    
    static func handleError(viewController : UIViewController, logger : Logger, error : Error) {
        logger.error(error.localizedDescription)
        
        let alertController = UIAlertController(title: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: self.okTitle, style: .default))
        viewController.present(alertController, animated: true)
    }
    
    static func openPhoneNumber(phoneNumber : String) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func openMail(viewController : UIViewController, delegate : MFMailComposeViewControllerDelegate, logger : Logger, emailAddress : String) {
        guard MFMailComposeViewController.canSendMail()
        else {
            logger.error("Sending a mail not possible. No mail account")
            return
        }
        
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = delegate
        mailController.setToRecipients([emailAddress])
        mailController.navigationBar.tintColor = UIColor.white
        
        viewController.present(mailController, animated: true)
        
    }
    
    static func getEmptyCompletedSalesOrdersChart() -> FUIKPIHeader {
        let completedKPIChart = FUIKPIProgressView()
        completedKPIChart.chartSize = FUIKPIProgressViewSize.large
        
        completedKPIChart.colorScheme = .darkBackground
        
        let kpiHeader = FUIKPIHeader()
        kpiHeader.items = [completedKPIChart]
        
        return kpiHeader
    }
    
    static func updateSalesOrderChart(appDelegate : AppDelegate, logger : Logger, completedKPIChart : FUIKPIProgressView) {
        let totalOrdersCount = UIFunctionsHelper.getOrdersCount(appDelegate: appDelegate, logger: logger)
        let completedOrdersCount = UIFunctionsHelper.getCompletedOrdersCount(appDelegate: appDelegate, logger: logger)
        
        let completedOrdersFraction = FUIKPIFractionItem(string: "\(completedOrdersCount)")
        let unitFraction = FUIKPIFractionItem(string: "/")
        let totalOrdersFraction = FUIKPIFractionItem(string: "\(totalOrdersCount)")
        
        if totalOrdersCount == 0 {
            return
        }
        
        completedKPIChart.progress = Float(completedOrdersCount) / Float(totalOrdersCount)
        completedKPIChart.items = [completedOrdersFraction, unitFraction, totalOrdersFraction]
        completedKPIChart.captionLabelText = "Sales-Orders Completed"
    }
    
    static func getOrdersCount(appDelegate : AppDelegate, logger : Logger) -> Int64 {
        do {
            let ordersQuery = DataQuery().selectAll()
            let ordersCount = try appDelegate.espmContainer.executeQuery(ordersQuery.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderHeaders)).count()
            
           return ordersCount
        } catch {
            print(error)
            logger.error(error.localizedDescription)
        }
        
        return 0
    }
    
    static func getCompletedOrdersCount(appDelegate : AppDelegate, logger : Logger) -> Int64 {
        do {
            let ordersQuery = DataQuery().filter(SalesOrderHeader.lifeCycleStatus.equal("C"))
            
            let ordersCount = try appDelegate.espmContainer.executeQuery(ordersQuery.fromDefault(ESPMContainerMetadata.EntitySets.salesOrderHeaders)).count()
            
            return ordersCount
        } catch {
            print(error)
            logger.error(error.localizedDescription)
        }
        
        return 0
    }
}
