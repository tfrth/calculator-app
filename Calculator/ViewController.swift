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
    
    var userIsInTheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
          display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
       
    }
    
  
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
            case "×": performOperation { $0 * $1 }
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $1 - $0 }
            default: break

            
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
        }
    }
    
    //performOperation function is allowing us to condense operation into one function since all operators are very similar in that they take two doubles and return another double.
    
//    func multiply(op1: Double, op2: Double) -> Double {  //multiply bit
//        return op1 * op2
//    }
//    
//    func divide(op1: Double, op2: Double) -> Double {  //divide bit
//        return op1 / op2
//    }
//    
//    func add(op1: Double, op2: Double) -> Double {  //add bit
//        return op1 + op2
//    }
//    
//    func subtract(op1: Double, op2: Double) -> Double {  //subtract bit
//        return op1 - op2
//    }
    
    var operandStack = Array<Double>() //var can infer type from value i.e Array<Double>
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
        
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue //
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

