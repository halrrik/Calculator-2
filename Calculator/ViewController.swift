//
//  ViewController.swift
//  Calculator
//
//  Created by Hanzhou Shi on 12/23/15.
//  Copyright © 2015 USF. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsTyping = false
    var operandStack = [Double]()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsTyping = true
        }
    }
    
    @IBAction func enter() {
        userIsTyping = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)");
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsTyping = false
        }
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        switch operation {
//        case "+":
//        case "−":
//        case "×":
//        case "÷":
        default: break
        }
    }
}

