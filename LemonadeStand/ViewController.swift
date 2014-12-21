//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Clint Greive on 21/12/2014.
//  Copyright (c) 2014 Clint Greive. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var moneySupplyCount: UILabel!
    @IBOutlet weak var lemonSupplyCount: UILabel!
    @IBOutlet weak var iceCubeSupplyCount: UILabel!
    @IBOutlet weak var lemonPurchaseCount: UILabel!
    @IBOutlet weak var iceCubePurchaseCount: UILabel!
    @IBOutlet weak var lemonMixCount: UILabel!
    @IBOutlet weak var iceCubeMixCount: UILabel!
    
    var supplies = Supplies(aMoney: 10, aLemons: 1, aIceCubes: 1)
    let price = Price()
    
    var lemonsToPurchase = 0
    var iceCubesToPurchase = 0
    
    var lemonsToMix = 0
    var iceCubesToMix = 0
    
    var weatherArray:[[Int]] = [[5, 8, 10,9], [-10, -9, -5, -7], [22, 25, 27, 23]]
    var weatherToday:[Int] = [0, 0, 0, 0]
    
    var weatherImageView: UIImageView = UIImageView(frame: CGRect(
        x: 20,
        y: 50,
        width: 50,
        height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(weatherImageView)
        self.updateMainView()
        self.simulateWeatherToday()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // IBActions
    
    @IBAction func purchaseLemonButtonPressed(sender: UIButton) {
        if self.supplies.money >= self.price.lemon {
            self.lemonsToPurchase += 1
            self.supplies.money -= self.price.lemon
            self.supplies.lemons += 1
            self.updateMainView()
        } else {
            self.showAlertWithText(message: "You don't have enough money")
        }
    }
    
    @IBAction func purchasedIceCubeButtonPressed(sender: UIButton) {
        if self.supplies.money >= self.price.iceCube {
            self.iceCubesToPurchase += 1
            self.supplies.money -= self.price.iceCube
            self.supplies.iceCubes += 1
            self.updateMainView()
        } else {
            self.showAlertWithText(header: "Error", message: "You don't have enough money")
        }
    }
    
    @IBAction func unpurchaseLemonButtonPressed(sender: UIButton) {
        if self.lemonsToPurchase > 0 {
            self.lemonsToPurchase -= 1
            self.supplies.money += self.price.lemon
            self.supplies.lemons -= 1
            self.updateMainView()
        } else {
            self.showAlertWithText(message: "You don't have anythig to return")
        }
    }
    
    @IBAction func unpurchaseIceCubeButtonPressed(sender: UIButton) {
        if self.iceCubesToPurchase > 0 {
            self.iceCubesToPurchase -= 1
            self.supplies.money += self.price.iceCube
            self.supplies.iceCubes -= 1
            self.updateMainView()
        } else {
            self.showAlertWithText(message: "You don't have anything to return")
        }
    }
    
    @IBAction func mixLemonsButtonPressed(sender: UIButton) {
        if self.supplies.lemons > 0 {
            self.lemonsToPurchase = 0
            self.supplies.lemons -= 1
            self.lemonsToMix += 1
            self.updateMainView()
        } else {
            self.showAlertWithText(message: "You don't have enough inventory")
        }
    }
    
    @IBAction func mixIceCubeButtonPressed(sender: UIButton) {
        if self.supplies.iceCubes > 0 {
            self.iceCubesToPurchase = 0
            self.supplies.iceCubes -= 1
            self.iceCubesToMix += 1
            self.updateMainView()
        } else {
            self.showAlertWithText(message: "You don't have enough inventory")
        }
    }
    
    @IBAction func unmixLemonButtonPressed(sender: UIButton) {
        if self.lemonsToMix > 0 {
            self.lemonsToPurchase = 0
            self.lemonsToMix -= 1
            self.supplies.lemons += 1
            self.updateMainView()
        } else {
            self.showAlertWithText(message: "You have nothing to un-mix")
        }
    }

    @IBAction func unmixIceCubeButtonPressed(sender: UIButton) {
        if self.iceCubesToMix > 0 {
            self.iceCubesToPurchase = 0
            self.iceCubesToMix -= 1
            self.supplies.iceCubes += 1
            self.updateMainView()
        } else {
            self.showAlertWithText(message: "You have nothing to un-mix")
        }
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        let average = self.findAverage(self.weatherToday)
        let customers = Int(arc4random_uniform(UInt32(abs(average))))
        println("customers: \(customers)")
        
        if lemonsToMix == 0 || iceCubesToMix == 0 {
            self.showAlertWithText(message: "You need to add at least 1 Lemon and 1 Ice Cube")
        } else {
            let lemonadeRatio = Double(lemonsToMix) / Double(iceCubesToMix)
            
            for x in 0...customers {
                let preference = Double(arc4random_uniform(UInt32(101))) / 100
                
                if preference < 0.4 && lemonadeRatio > 1 {
                    self.supplies.money += 1
                    println("Paid")
                } else if preference > 0.6 && preference < 1 {
                   self.supplies.money += 1
                    println("Paid")
                } else if preference <= 0.6 && preference >= 0.4 && lemonadeRatio == 1 {
                    self.supplies.money += 1
                    println("Paid")
                } else {
                    println("else statement evaluating")
                }
            }
            
            self.lemonsToPurchase = 0
            self.iceCubesToPurchase = 0
            self.lemonsToMix = 0
            self.iceCubesToMix = 0
            
            self.simulateWeatherToday()
            self.updateMainView()
        }
    }
    
    // HELPERS
    func updateMainView () {
        self.moneySupplyCount.text = "$\(self.supplies.money)"
        self.lemonSupplyCount.text = "\(self.supplies.lemons) lemons"
        self.iceCubeSupplyCount.text = "\(self.supplies.iceCubes) Ice Cubes"
        
        self.lemonPurchaseCount.text = "\(self.lemonsToPurchase)"
        self.iceCubePurchaseCount.text = "\(self.iceCubesToPurchase)"
        
        self.lemonMixCount.text = "\(self.lemonsToMix)"
        self.iceCubeMixCount.text = "\(self.iceCubesToMix)"
    }
    
    func showAlertWithText (header: String = "Warning", message: String) {
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func simulateWeatherToday () {
        let index = Int(arc4random_uniform(UInt32(self.weatherArray.count)))
            self.weatherToday = weatherArray[index]
        
        switch index {
        case 0:
            weatherImageView.image = UIImage(named: "Cold")
        case 1:
            weatherImageView.image = UIImage(named: "Mild")
        case 2:
            weatherImageView.image = UIImage(named: "Warm")
        default:
            weatherImageView.image = UIImage(named: "Warm")
        }
    }
    
    func findAverage(data: [Int]) -> Int {
        var sum = 0
        for x in data {
            sum += x
        }
        var average:Double = Double(sum) / Double(data.count)
        var rounded:Int = Int(ceil(average))
        
        return rounded
    }
}

