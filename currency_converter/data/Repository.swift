//
//  Repository.swift
//  currency_converter
//
//  Created by Leonid on 15.08.2022.
//

import Foundation
import UIKit
import CoreData


class Repository : ObservableObject {
    
    private var pairs : [Pair] = []
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let userDefaults = UserDefaults()
    
    private var timer = Timer()
    
    @Published private(set) var datetime = ""
    
    static let shared = Repository()
    
    private let service = Service.shared
    
    
    func addPair(from : String, to : String, rate : Double){
        let pair = Pair(context: context)
        pair.rate = rate
        pair.code = from + to
    }
    
    
    func getPrice(for code : Code, amount : Double) -> Double? {
        for pair in pairs {
            if(pair.code == code.from + code.to){
               return pair.rate * amount
           }
       }

        return nil 
    }
    
    func fetchRates(){
        print("fetch method called")
        self.service.fetchPair(code: Constants.RUBTL, completion: self.onCurrencyRatesFetched)
        self.service.fetchPair(code: Constants.TLRUB, completion: self.onCurrencyRatesFetched)
    }
    
    func scheduleAPICalls(){
        print("fetched")
        
        fetchRates()
        
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true){
            _ in
            self.fetchRates()
        }
        
    }
    
    func cancelAPICalls(){
        timer.invalidate()
    }
    
    private func onCurrencyRatesFetched(pair: CurrencyPair?, error: Error?){
        DispatchQueue.main.async {
            print("currency rates fetch")
            if let error = error {
                print(error)
            }
            
            if let currencyPair = pair {
                print(currencyPair.rate)
                
                self.datetime = String(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium))
                
                do {
                    let request = Pair.fetchRequest()
                    self.pairs = try self.context.fetch(request)
                    print(self.pairs.count)
                }catch {
                    print(error)
                }
            
                let code = currencyPair.code.from + currencyPair.code.to
                let rate = currencyPair.rate
                
                do {
                    var foundPair = false
                    
                    for pair in self.pairs {
                        if(pair.code == code){
                            pair.rate = rate
                            foundPair = true
                        }
                    }
                    
                    if(!foundPair){
                        let pair = Pair(context: self.context)
                        pair.code = code
                        pair.rate = rate
                        print("not found")
                    }
                    
                    try self.context.save()
                    print("saved")
                }catch {
                    print(error)
                }
            }
        }
    }
}
