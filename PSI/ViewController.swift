//
//  ViewController.swift
//  PSI
//
//  Created by Jacky Tjoa on 21/4/18.
//  Copyright © 2018 Jacky Tjoa. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let urlPath = "https://api.data.gov.sg/v1/environment/psi"
    let psiData = PSIData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //MapView delegate
        mapView.delegate = self
        
        //load data    
        Network.shared.loadPSIData(success: { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                self.psiData.parseJSON(json: json)
                
                var annotations:[MapAnnotation] = []
                for regionMetadata in self.psiData.regionMetadata {
                    let point = MapAnnotation(title: regionMetadata.name, subtitle: "", coordinate: CLLocationCoordinate2D(latitude: regionMetadata.latitude, longitude: regionMetadata.longitude))
                    annotations.append(point)
                }
                
                self.mapView.addAnnotations(annotations)
            }
            
        }) { (error) in
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let identifier = "marker"
            var view:MKMarkerAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }

            return view
        }
    }
}

