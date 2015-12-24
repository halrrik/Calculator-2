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
        display.text = value.rangeOfString(".") == nil ? "0." : display.text! + "."
        userIsTyping = true
    }
    
    @IBAction func enter() {
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        else {
            displayValue = 0
        }
        history.text = brain.getHistory()
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsTyping = false
            history.text = brain.getHistory()
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
            else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func reset() {
        brain.resetBrain()
        userIsTyping = false
        history.text = "EMPTY"
        display.text = "0"
    }
}

