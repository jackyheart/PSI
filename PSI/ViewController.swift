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
    let psiData = PSIData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //MapView delegate
        mapView.delegate = self
        
        //load data
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - IBActions

extension ViewController {
    
    @IBAction func onSegmentedChanged(_ sender: Any) {
        let segmentControl = sender as! UISegmentedControl
        switch segmentControl.selectedSegmentIndex {
            case 1:
                mapView.mapType = .satellite
            case 2:
                mapView.mapType = .hybrid
            default:
                mapView.mapType = .standard
        }
    }
}

//MARK: - Helpers

extension ViewController {
    
    func loadData() {
        Network.shared.loadPSIData(success: { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                self.psiData.parseJSON(json: json)
                self.addAnnotationsToMap(psiData: self.psiData)
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    func addAnnotationsToMap(psiData: PSIData) {
        
        var annotations:[MapAnnotation] = []
        for regionMetadata in psiData.regionMetadata {
            
            if regionMetadata.name == Region.national.rawValue {
                continue
            }
            
            let point = MapAnnotation(title: regionMetadata.name.capitalized, subtitle: "", coordinate: CLLocationCoordinate2D(latitude: regionMetadata.latitude, longitude: regionMetadata.longitude))
            
            //psi 24 hours reading
            if let psi24 = psiData.readings[Readings.psi_twenty_four_hourly.rawValue] as? [String:NSNumber] {
                let val = psi24[regionMetadata.name] ?? 0
                point.psi24Val = val.floatValue
            }
            
            //subtitle
            var subtitle = "Readings:\n"
            for key in psiData.readings.keys {
                if let reading = psiData.readings[key] as? [String:NSNumber] {
                    if let val = reading[regionMetadata.name] {
                        subtitle += "\(key): \(val)\n"
                    }
                }
            }
            point.subtitle = subtitle
            
            annotations.append(point)
        }
        
        self.mapView.addAnnotations(annotations)
    }
}

//MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            
            guard let annotation = annotation as? MapAnnotation else { return nil }
            
            let identifier = "marker"
            var view:MKMarkerAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
            }
            
            if let psi24 = psiData.readings[Readings.psi_twenty_four_hourly.rawValue] as? [String:NSNumber] {
                view.glyphText = "\(psi24[annotation.regionKey] ?? 0)"
            }
            view.markerTintColor = annotation.markerTintColor
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = annotation.subtitle
            view.detailCalloutAccessoryView = detailLabel
            
            return view
        }
    }
}

