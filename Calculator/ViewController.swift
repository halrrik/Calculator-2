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
    @IBOutlet weak var history: UILabel!
    
    var userIsTyping = false
    let brain = CalculatorBrain()

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
    
    @IBAction func appendDecimalPoint() {
        let value = display.text!
        display.text = value.rangeOfString(".") == nil ? value + "." : "0."
        userIsTyping = true
    }
    
    @IBAction func enter() {
        displayValue = brain.pushOperand(displayValue!)
        userIsTyping = false
        history.text = brain.description
    }
    
    var displayValue: Double? {
        get {
            let strVal = display.text!
            return NSNumberFormatter().numberFromString(strVal)?.doubleValue
        }
        
        set {
            if newValue == nil {
                display.text = "0"
            }
            else {
                display.text = "\(newValue!)"
                history.text?.append("=" as Character)
            }
            history.text = brain.description
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
        }
    }
    
    @IBAction func dropDigit() {
        if userIsTyping {
            if let sub = display.text?.characters.dropLast() {
                if sub.count > 0 {
                    display.text = String(sub)
                }
                else {
                    display.text = "0"
                    userIsTyping = false
                }
            }
        }
    }
    
    @IBAction func reset() {
        brain.resetBrain()
        userIsTyping = false
        history.text = "EMPTY"
        display.text = "0"
    }
    
    @IBAction func flipSign(sender: UIButton) {
        if userIsTyping {
            displayValue = -displayValue!
        }
        else {
            if let symbol = sender.currentTitle {
                if let result = brain.performOperation(symbol) {
                    displayValue = result
                }
            }
        }
    }
    
    @IBAction func defineVariable() {
        userIsTyping = false
        // define variable
        brain.variableValues["M"] = displayValue!
        // evaluate and show result
        displayValue = brain.evaluate()
    }
    
}

