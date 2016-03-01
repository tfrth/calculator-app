//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Tyler Frith on 1/27/16.
//  Copyright © 2016 tfrth. All rights reserved.
//

//the "model" in MVC

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()          //creates a dictionary
    
    init() {                                        //initializer
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops    //makes copy of ops to be mutable array to work with
            let op = remainingOps.removeLast()
            
            switch op {                   //how you pull associated values  out of enum
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation (_, let operation):           //_ to ignore
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluaiton = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluaiton.result {
                        return (operation(operand1, operand2), op2Evaluaiton.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)   //default return nil if ops IS empty
    }
    
    func clear() -> Double! {
        opStack.removeAll()
        return evaluate()
    }
    
    func evaluate() -> Double? {  //must be an optional b/c nil may need to be returned (ie someone just enters in + but no operands)
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {   //function to look up values in dictionary
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}

