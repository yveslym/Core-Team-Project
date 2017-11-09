//
//  Networking.swift
//  Core-Project
//
//  Created by Yveslym on 11/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
class Networking{
    
    static func network(bank: BankAccount?, route: Route, apiHost: ApiHost,clientId: String,secret: String, date:[Date]? = nil, completion:@escaping(Data?)->Void){
        
    // get the url by combing the base url and access point
        let baseURL = apiHost.baseLink()
        let path = route.accessPoint()

        guard let url = URL(string: baseURL+path) else {return}
    
        var request = URLRequest(url: url)
        
    // get the http body
        switch (route) {
        
        case .transactions:
            request.httpBody = route.jsonBody(client_id: clientId, secret: secret, access_token: bank?.access_token, startDate: date?[0], endDate: date?[1])
        case .auth:
            request.httpBody = route.jsonBody(client_id: clientId, secret: secret, access_token: bank?.access_token)
        case .identity:
             request.httpBody = route.jsonBody(client_id: clientId, secret: secret, access_token: bank?.access_token)
        case .income:
             request.httpBody = route.jsonBody(client_id: clientId, secret: secret, access_token: bank?.access_token)
        case .balance:
            request.httpBody = route.jsonBody(bank: bank, client_id: clientId, secret: secret, access_token: bank?.access_token)
        }
    
    request.httpMethod = " POST"
    request.addValue("content-type", forHTTPHeaderField: "application/json")
    
    let session = URLSession.shared
        let task = session.dataTask(with: request){data,response,error in
            
            do{
                guard let data = data else{return}
            
            }
    }
 task.resume()
}
}





