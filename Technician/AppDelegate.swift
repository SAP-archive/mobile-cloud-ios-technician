//
// AppDelegate.swift
// Technician
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 04/07/18
//

import SAPCommon
import SAPFiori
import SAPFioriFlows
import SAPFoundation
import SAPOData
import SAPOfflineOData
import UserNotifications

protocol EntityUpdaterDelegate {
    func entityHasChanged(_ entity: EntityValue?)
}

protocol EntitySetUpdaterDelegate {
    func entitySetHasChanged()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate, OnboardingManagerDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    let mainURL = URL(string: "https://mobile-a326aab34.hana.ondemand.com/com.sap.edm.sampleservice.v2")!
    var globalSession : SAPURLSession?
    
    private let logger = Logger.shared(named: "AppDelegateLogger")
    var espmContainer: ESPMContainer<OfflineODataProvider>!
    private(set) var isOfflineStoreOpened = false

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set a FUIInfoViewController as the rootViewController, since there it is none set in the Main.storyboard
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = FUIInfoViewController.createSplashScreenInstanceFromStoryboard()

        do {
            // Attaches a LogUploadFileHandler instance to the root of the logging system
            try SAPcpmsLogUploader.attachToRootLogger()
        } catch {
            self.logger.error("Failed to attach to root logger.", error: error)
        }

        //Styling
        UINavigationBar.applyFioriStyle()
        
        UITabBar.appearance().barTintColor = UIColor.preferredFioriColor(forStyle: FUIColorStyle.navigationBar)
        UITabBar.appearance().tintColor = UIColor.preferredFioriColor(forStyle: FUIColorStyle.primary6)
        
        OnboardingManager.shared.delegate = self
        OnboardingManager.shared.onboardOrRestore()
        
        return true
    }

    // To only support portrait orientation during onboarding
    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        switch OnboardingFlowController.presentationState {
        case .onboarding, .restoring:
            return .portrait
        default:
            return .allButUpsideDown
        }
    }

    // Delegate to OnboardingManager.
    func applicationDidEnterBackground(_: UIApplication) {
        OnboardingManager.shared.applicationDidEnterBackground()
        self.closeOfflineStore()
    }

    // Delegate to OnboardingManager.
    func applicationWillEnterForeground(_: UIApplication) {
        OnboardingManager.shared.applicationWillEnterForeground()
        self.openOfflineStore(false)
    }

    func onboardingContextCreated(onboardingContext: OnboardingContext, onboarding: Bool) {
        let configurationURL = URL(string: "\(mainURL.absoluteString)")!
        self.configureOData(onboardingContext.sapURLSession, configurationURL, onboarding)
    }

    func onboarded(onboardingContext: OnboardingContext) {
        self.uploadLogs(onboardingContext.sapURLSession, onboardingContext.info[.sapcpmsSettingsParameters]! as! SAPcpmsSettingsParameters)
        self.registerForRemoteNotification(onboardingContext.sapURLSession, onboardingContext.info[.sapcpmsSettingsParameters]! as! SAPcpmsSettingsParameters)
        self.openOfflineStore(true)
        
        self.globalSession = onboardingContext.sapURLSession
    }

    private func setRootViewController() {        
        DispatchQueue.main.async {
            let tabBarViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            
            //Orders
            let salesOrderHeaderStoryBoard = UIStoryboard(name: "SalesOrderHeader", bundle: nil)
            let orderNavigationViewController = salesOrderHeaderStoryBoard.instantiateViewController(withIdentifier: "SalesOrderHeaderMaster") as! UINavigationController
            
            let orderViewController = orderNavigationViewController.viewControllers[0]
            (orderViewController as! SalesOrderHeaderMasterViewController).entitySetName = "SalesOrderHeaders"
            func fetchSalesOrderHeaders(_ completionHandler: @escaping ([SalesOrderHeader]?, Error?) -> Void) {
                let query = DataQuery().selectAll().top(20)
                do {
                    self.espmContainer!.fetchSalesOrderHeaders(matching: query) { salesOrderHeaders, error in
                        if error == nil {
                            completionHandler(salesOrderHeaders, nil)
                        } else {
                            completionHandler(nil, error)
                        }
                    }
                }
            }
            (orderViewController as! SalesOrderHeaderMasterViewController).loadEntitiesBlock = fetchSalesOrderHeaders
            orderViewController.navigationItem.title = "Orders"
            orderNavigationViewController.tabBarItem = UITabBarItem(title: "Orders", image: UIImage(named: "orders"), selectedImage: nil)
            
            //Customer
            let customerStoryBoard = UIStoryboard(name: "Customer", bundle: nil)
            let customerNavigationViewController = customerStoryBoard.instantiateViewController(withIdentifier: "CustomerMaster") as! UINavigationController
            
            let customerViewController = customerNavigationViewController.viewControllers[0]
            (customerViewController as! CustomerMasterViewController).entitySetName = "Customers"
            func fetchCustomers(_ completionHandler: @escaping ([Customer]?, Error?) -> Void) {
                let query = DataQuery().selectAll()
                do {
                    self.espmContainer!.fetchCustomers(matching: query) { customers, error in
                        if error == nil {
                            completionHandler(customers, nil)
                        } else {
                            completionHandler(nil, error)
                        }
                    }
                }
            }
            (customerViewController as! CustomerMasterViewController).loadEntitiesBlock = fetchCustomers
            customerViewController.navigationItem.title = "Customers"
            customerNavigationViewController.tabBarItem = UITabBarItem(title: "Customers", image: FUIIconLibrary.app.staffOff, selectedImage: nil)
            
            //Products
            let productStoryBoard = UIStoryboard(name: "Product", bundle: nil)
            let productNavigationViewController = productStoryBoard.instantiateViewController(withIdentifier: "ProductMaster") as! UINavigationController
            
            let productViewController = productNavigationViewController.viewControllers[0]
            (productViewController as! ProductMasterViewController).entitySetName = "Products"
            func fetchProducts(_ completionHandler: @escaping ([Product]?, Error?) -> Void) {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll()
                do {
                    self.espmContainer!.fetchProducts(matching: query) { products, error in
                        if error == nil {
                            completionHandler(products, nil)
                        } else {
                            completionHandler(nil, error)
                        }
                    }
                }
            }
            (productViewController as! ProductMasterViewController).loadEntitiesBlock = fetchProducts
            productViewController.navigationItem.title = "Products"
            
            let tabbarBarItem = UITabBarItem(title: "Products", image: UIImage(named: "products"), selectedImage: nil);
            productNavigationViewController.tabBarItem = tabbarBarItem
            
            tabBarViewController.viewControllers = [orderNavigationViewController, customerNavigationViewController, productNavigationViewController]
            self.window!.rootViewController = tabBarViewController
        }
    }
    
    // MARK: - Remote Notification handling

    private var deviceToken: Data?

    func application(_: UIApplication, willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UIApplication.shared.registerForRemoteNotifications()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
            // Enable or disable features based on authorization.
        }
        center.delegate = self
        return true
    }

    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.logger.info("App opened via user selecting notification: \(response.notification.request.content.body)")
        // Here is where you want to take action to handle the notification, maybe navigate the user to a given screen.
        completionHandler()
    }

    // Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        self.logger.info("Remote Notification arrived while app was in foreground: \(notification.request.content.body)")
        // Currently we are presenting the notification alert as the application were in the background.
        // If you have handled the notification and do not want to display an alert, call the completionHandler with empty options: completionHandler([])
        completionHandler([.alert, .sound])
    }

    func registerForRemoteNotification(_ urlSession: SAPURLSession, _ settingsParameters: SAPcpmsSettingsParameters) {
        guard let deviceToken = self.deviceToken else {
            // Device token has not been acquired
            return
        }

        let remoteNotificationClient = SAPcpmsRemoteNotificationClient(sapURLSession: urlSession, settingsParameters: settingsParameters)
        remoteNotificationClient.registerDeviceToken(deviceToken) { error in
            if let error = error {
                self.logger.error("Register DeviceToken failed", error: error)
                return
            }
            self.logger.info("Register DeviceToken succeeded")
        }
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.logger.error("Failed to register for Remote Notification", error: error)
    }

    // MARK: - Log uploading

    // This function is invoked on every application start, but you can reuse it to manually triger the logupload.
    private func uploadLogs(_ urlSession: SAPURLSession, _ settingsParameters: SAPcpmsSettingsParameters) {
        SAPcpmsLogUploader.uploadLogs(sapURLSession: urlSession, settingsParameters: settingsParameters) { error in
            if let error = error {
                self.logger.error("Error happened during log upload.", error: error)
                return
            }
            self.logger.info("Logs have been uploaded successfully.")
        }
    }

    // MARK: - Configure Offline OData

    private func configureOData(_ urlSession: SAPURLSession, _ serviceRoot: URL, _ onboarding: Bool) {
        var offlineParameters = OfflineODataParameters()
        offlineParameters.customHeaders = ["X-SMP-APPID": "com.sap.bp.demo.technician.ios"]
        offlineParameters.enableRepeatableRequests = true
        // Setup an instance of delegate. See sample code below for definition of OfflineODataDelegateSample class.
        let delegate = OfflineODataDelegateSample()
        let offlineODataProvider = try! OfflineODataProvider(serviceRoot: serviceRoot, parameters: offlineParameters, sapURLSession: urlSession, delegate: delegate)

        let query = DataQuery().selectAll()
        if onboarding {
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.customers.localName, query: "/\(ESPMContainerMetadata.EntitySets.customers.localName)\(query)", automaticallyRetrievesStreams: false))
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.purchaseOrderHeaders.localName, query: "/\(ESPMContainerMetadata.EntitySets.purchaseOrderHeaders.localName)\(query)", automaticallyRetrievesStreams: false))
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.stock.localName, query: "/\(ESPMContainerMetadata.EntitySets.stock.localName)\(query)", automaticallyRetrievesStreams: false))
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.productTexts.localName, query: "/\(ESPMContainerMetadata.EntitySets.productTexts.localName)\(query)", automaticallyRetrievesStreams: false))
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.salesOrderItems.localName, query: "/\(ESPMContainerMetadata.EntitySets.salesOrderItems.localName)\(query)", automaticallyRetrievesStreams: false))
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.products.localName, query: "/\(ESPMContainerMetadata.EntitySets.products.localName)\(query)", automaticallyRetrievesStreams: false))
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.productCategories.localName, query: "/\(ESPMContainerMetadata.EntitySets.productCategories.localName)\(query)", automaticallyRetrievesStreams: false))
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.salesOrderHeaders.localName, query: "/\(ESPMContainerMetadata.EntitySets.salesOrderHeaders.localName)\(query)", automaticallyRetrievesStreams: false))
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.suppliers.localName, query: "/\(ESPMContainerMetadata.EntitySets.suppliers.localName)\(query)", automaticallyRetrievesStreams: false))
            try! offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name: ESPMContainerMetadata.EntitySets.purchaseOrderItems.localName, query: "/\(ESPMContainerMetadata.EntitySets.purchaseOrderItems.localName)\(query)", automaticallyRetrievesStreams: false))
        }
        self.espmContainer = ESPMContainer(provider: offlineODataProvider)
    }

    private func openOfflineStore(_ sync: Bool = false) {
        if !self.isOfflineStoreOpened {
            // The OfflineODataProvider needs to be opened before performing any operations.
            self.espmContainer.open { error in
                if let error = error {
                    self.logger.error("*** Could not open offline store.", error: error)
                    DispatchQueue.main.async(execute: {
                        let errorOfflineInfoVC = FUIInfoViewController.createSplashScreenInstanceFromStoryboard()
                        errorOfflineInfoVC.informationTextView.text = "Opening Offline Store failed: \(error)"
                        errorOfflineInfoVC.informationTextView.textColor = UIColor.black
                        errorOfflineInfoVC.informationTextView.isHidden = false
                        errorOfflineInfoVC.loadingIndicatorView.dismiss()
                        self.window!.rootViewController = errorOfflineInfoVC
                    })
                    return
                }
                self.isOfflineStoreOpened = true
                
                self.logger.info("*** Offline store opened.")
            }
        }
        
        if sync {
            self.setRootViewController()
            self.uploadOfflineStore()
            self.downloadOfflineStore()
        }
    }

    private func closeOfflineStore() {
        if self.isOfflineStoreOpened {
            do {
                // the Offline store should be closed when it is no longer used.
                try self.espmContainer.close()
                self.isOfflineStoreOpened = false
            } catch {
                self.logger.error("*** Offline Store closing failed.")
            }
        }
        self.logger.info("*** Offline Store closed.")
    }

    private func downloadOfflineStore() {
        if !self.isOfflineStoreOpened {
            self.logger.error("*** Offline Store still closed")
            return
        }
        // the download function updates the client’s offline store from the backend.
        self.espmContainer.download { error in
            if let error = error {
                self.logger.error("*** Offline Store download failed.", error: error)
                return
            }
            self.logger.info("*** Offline Store is downloaded.")
        }
    }

    private func uploadOfflineStore() {
        if !self.isOfflineStoreOpened {
            self.logger.error("*** Offline Store still closed")
            return
        }
        // the upload function updates the backend from the client’s offline store.
        self.espmContainer.upload { error in
            if let error = error {
                self.logger.error("*** Offline Store upload failed.", error: error)
                return
            }
            self.logger.info("*** Offline Store is uploaded.")
        }
    }
}

class OfflineODataDelegateSample: OfflineODataDelegate {
    private let logger = Logger.shared(named: "AppDelegateLogger")

    public func offlineODataProvider(_: OfflineODataProvider, didUpdateDownloadProgress progress: OfflineODataProgress) {
        self.logger.info("downloadProgress: \(progress.bytesSent)  \(progress.bytesReceived)")
    }

    public func offlineODataProvider(_: OfflineODataProvider, didUpdateFileDownloadProgress progress: OfflineODataFileDownloadProgress) {
        self.logger.info("downloadProgress: \(progress.bytesReceived)  \(progress.fileSize)")
    }

    public func offlineODataProvider(_: OfflineODataProvider, didUpdateUploadProgress progress: OfflineODataProgress) {
        self.logger.info("downloadProgress: \(progress.bytesSent)  \(progress.bytesReceived)")
    }

    public func offlineODataProvider(_: OfflineODataProvider, requestDidFail request: OfflineODataFailedRequest) {
        self.logger.info("requestFailed: \(request.httpStatusCode)")
    }

    // The OfflineODataStoreState is a Swift OptionSet. Use the set operation to retrieve each setting.
    private func storeState2String(_ state: OfflineODataStoreState) -> String {
        var result = ""
        if state.contains(.opening) {
            result = result + ":opening"
        }
        if state.contains(.open) {
            result = result + ":open"
        }
        if state.contains(.closed) {
            result = result + ":closed"
        }
        if state.contains(.downloading) {
            result = result + ":downloading"
        }
        if state.contains(.uploading) {
            result = result + ":uploading"
        }
        if state.contains(.initializing) {
            result = result + ":initializing"
        }
        if state.contains(.fileDownloading) {
            result = result + ":fileDownloading"
        }
        if state.contains(.initialCommunication) {
            result = result + ":initialCommunication"
        }
        return result
    }

    public func offlineODataProvider(_: OfflineODataProvider, stateDidChange newState: OfflineODataStoreState) {
        let stateString = storeState2String(newState)
        self.logger.info("stateChanged: \(stateString)")
    }
}
