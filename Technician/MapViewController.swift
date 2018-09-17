//
//  MapViewController.swift
//  Technician
//
//  Created by Kasseckert, Nils on 05.07.18.
//  Copyright © 2018 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let latitudinalMeters = 9000.0
    let longitudinalMeters = 9000.0
    let locationManager = CLLocationManager()
    
    var customerAddress : String?
    private var location : CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted: break
        case .denied: break
        case .authorizedAlways: break
        case .authorizedWhenInUse: break
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.delegate = self
        
        mapView.register(FioriMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.showsUserLocation = true
        
        guard let address = customerAddress else {
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let userLocation = placemarks.first?.location
            else {
                    return
            }
            
            self.location = userLocation
            let customerAnnotation = MKPointAnnotation()
            customerAnnotation.coordinate = self.location!.coordinate
            customerAnnotation.title = "Customer"
            
            self.mapView.addAnnotation(customerAnnotation)
            self.centerMap(on: self.location!.coordinate)
        }
    }
    
    private func centerMap(on location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: latitudinalMeters,
                                                  longitudinalMeters: longitudinalMeters)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        openShareAction()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        openShareAction()
    }
    
    private func openShareAction() {
        guard let userLocation = self.location else {
            return
        }
        
        var installedNavApps : [String] = ["Apple Maps"] // Apple Maps is always installed
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")! ) ) {
            installedNavApps.append("Google Maps")
        }
        
        let alertController = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Share", style: .default, handler: { (_) in
            let activityController = UIActivityViewController(activityItems: [self.customerAddress ?? ""], applicationActivities: nil)
            self.present(activityController, animated: true)
        }))
        
        for appName in installedNavApps {
            let button = UIAlertAction(title: appName, style: .default, handler: { (action) in
                if action.title == "Google Maps" {
                    UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=&daddr=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&directionsmode=driving")!, options: [:], completionHandler: nil)
                } else if action.title == "Apple Maps" {
                    let appleMapItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate, addressDictionary:nil))
                    appleMapItem.name = self.customerAddress
                    appleMapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                }
            })
            alertController.addAction(button)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

//Optional code to change the map annotations (icon and color)
class FioriMarker: FUIMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = .preferredFioriColor(forStyle: .map1)
            glyphImage = FUIIconLibrary.map.marker.functionalLocation.withRenderingMode(.alwaysTemplate)
            
        }
    }
}
