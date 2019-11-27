//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Sergey Petrosyan on 11/24/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import Foundation



struct CalculatorBrain {
    
    var accumulator: Double?
    var storedValue: Double?
    private var resultIsPending: Bool {
        switch pendingBinaryOperation {
        case nil:
            return false
        default:
            return true
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case memoryOperation
        case equals
    }
    
    private var operations: [String:Operation] = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "±" : Operation.unaryOperation{-$0},
        "×" : Operation.binaryOperation{$0 * $1},
        "÷" : Operation.binaryOperation{$0 / $1},
        "+" : Operation.binaryOperation{$0 + $1},
        "-" : Operation.binaryOperation{$0 - $1},
        "x²": Operation.unaryOperation{pow($0, 2)},
        "MS" : Operation.memoryOperation,
        "MR" : Operation.memoryOperation,
        "AC" : Operation.memoryOperation,
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != 0 {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                }
                accumulator = nil
            case .memoryOperation:
                if symbol == "MS" {
                    storedValue = accumulator
                } else if symbol == "MR", storedValue != nil {
                    accumulator = storedValue
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if accumulator != nil, pendingBinaryOperation != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
        set {
            
        }
    }
}
