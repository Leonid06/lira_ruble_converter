//
//  Service.swift
//  currency_converter
//
//  Created by Leonid on 14.08.2022.
//

import Foundation

class Service  {
    static let shared = Service()
    
    
    func fetchPair(code : Code, completion: @escaping (CurrencyPair?, Error?) -> Void) {
        let url = Service.HEAD_URL + "convert?from=\(code.from)&to=\(code.to)"
       
        performRequest(url: url, completion: completion)
    }
    
    private func performRequest(url : String, completion: @escaping (CurrencyPair?, Error?)-> Void ){
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("Data fetched")
                    completion(nil, error)
                    return 
                } else 
                
                if let safeData = data {
                    let currency = self.parseJSON(data: safeData)
                    print(currency)
                    completion(currency,nil)
                
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(data: Data?) -> CurrencyPair? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: data ?? Data())
            
            let from = decodedData.query.from
            let to = decodedData.query.to
            let rate = decodedData.result
            
            return CurrencyPair(code: Code(from: from, to: to), rate: rate)
        } catch {
            print(error)
            return nil
        }
    }
}

//constants
extension Service  {
    private static let HEAD_URL = "https://api.exchangerate.host/"
}
