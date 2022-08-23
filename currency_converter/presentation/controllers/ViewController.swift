//
//  ViewController.swift
//  currency_converter
//
//  Created by Leonid on 14.08.2022.
//

import UIKit
import Combine
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    
    private let repository = Repository.shared
    
    private var subscriber : AnyCancellable?
    
    override func viewWillAppear(_ animated: Bool) {
        repository.cancelAPICalls()
        print("calls were cancelled")
        repository.scheduleAPICalls()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriber = repository.$datetime.sink{
            date in
            print(date)
            self.updateTime(text: date)
        }
        fromTextField.delegate = self
        toTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNetworkData(_:)), name: Constants.Keys.Notifications.notificationKey, object: nil)
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let amount = Double(textField.text!) {
            if(textField == fromTextField){
                updateRates(for: Constants.TLRUB, amount: amount)
            }
            if(textField == toTextField){
                updateRates(for: Constants.RUBTL, amount: amount)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fromTextField.endEditing(true)
        toTextField.endEditing(true)
        return true
    }

}

extension ViewController {
    private func updateRates(for pair: Code, amount : Double){
        if let price = repository.getPrice(for: pair, amount: amount){
            if(pair.from == Constants.RUB){
                fromTextField.text = String(format: "%.2f", price)
            }
            if(pair.from == Constants.TL){
                toTextField.text = String(format: "%.2f", price)
            }
        }
    }
    
    @objc func updateNetworkData(_ : NSNotification){
        repository.cancelAPICalls()
        repository.scheduleAPICalls()
    }
    
    private func updateTime(text : String){
        datetimeLabel.text = text
    }
}




