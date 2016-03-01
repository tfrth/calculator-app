//
//  ViewController.swift
//  Calculator
//
//  Created by Tyler Frith on 12/29/15.
//  Copyright © 2015 tfrth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!  //property syntax
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var brain = CalculatorBrain() //creates instance of CalculatorBrain " // "green arrow" that goes from the controller to the model

    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
          display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
       
    }
    
//    @IBOutlet weak var history: UILabel!  //not sure how to implement history label 
//    
    @IBAction func clear(sender: UIButton) {
        displayValue = 0;
        brain.clear();
       
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
        } else {
            displayValue = 100
        }
    }
}
    
   
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
//            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    
}

