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
        Alamofire.request(urlPath).validate().responseJSON { (response) in
            switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        psiData.parseJSON(json: json)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}

