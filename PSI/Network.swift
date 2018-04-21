//
//  Network.swift
//  PSI
//
//  Created by Jacky Tjoa on 21/4/18.
//  Copyright © 2018 Jacky Tjoa. All rights reserved.
//

import Alamofire

class Network {
    
    static let shared = Network()
    let urlPath = "https://api.data.gov.sg/v1/environment/psi"
    
    func loadPSIData(success: @escaping (DataResponse<Any>) -> Void,
                     failure: @escaping (Error) -> Void) {
        
        Alamofire.request(urlPath).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                success(response)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
