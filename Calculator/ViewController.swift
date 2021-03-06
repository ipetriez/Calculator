//
//  ViewController.swift
//  Calculator
//
//  Created by Sergey Petrosyan on 11/23/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var loggingDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let textCurrentlyInDisplay = display.text!
        if let digit = sender.currentTitle, userIsInTheMiddleOfTyping == false, digit != "." {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        } else if let digit = sender.currentTitle, userIsInTheMiddleOfTyping == true {
            if !(display.text?.contains("."))! || digit != "." {
                display.text = textCurrentlyInDisplay + digit
            }
        }
        getDescriptionForLoggingDisplay()
    }
    
    private func getDescriptionForLoggingDisplay() {
        if brain.pendingBinaryOperation == nil {
            loggingDisplay.text = "\(brain.description)="
        } else if brain.pendingBinaryOperation != nil {
            loggingDisplay.text = "\(brain.description)..."
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            if Double(String(newValue)) == Double(String(Int(newValue))) {
                display.text = String(Int(newValue))
            } else {
                display.text = String(newValue)
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if sender.currentTitle == "AC" {
            displayValue = 0
            brain.result = nil
            brain.accumulator = nil
            brain.description = ""
            brain.pendingBinaryOperation = nil
        }
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        getDescriptionForLoggingDisplay()
    }
    
}

