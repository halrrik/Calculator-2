//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Hanzhou Shi on 12/24/15.
//  Copyright © 2015 USF. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, Int, (Double, Double) -> Double)
        case ConstantOperation(String, Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _, _):
                    return symbol
                case .ConstantOperation(let symbol, _):
                    return symbol
                case .Variable(let name):
                    return name
                }
            }
        }
        
        var precedence: Int {
            switch self {
            case .UnaryOperation(_, _):
                return Int.max-1
            case .BinaryOperation(_, let precedence, _):
                return precedence
            default:
                return Int.max
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    var variableValues = [String:Double]()
    
    private func descriptionHelper(ops: [Op]) -> (str: String, precedence: Int, remain: [Op]) {
        guard ops.count > 0 else { return ("?", Int.max, ops) }
        
        var remainingOps = ops
        let op = remainingOps.removeLast()
        let precedence = op.precedence
        switch op {
        case .Operand(let val):
            return ("\(val)", precedence, remainingOps)
        case .UnaryOperation(let symbol, _):
            let operandDesc = descriptionHelper(remainingOps)
            let operandStr = encloseDesc(operandDesc, mine: precedence)
            return (symbol+operandStr, precedence, operandDesc.remain)
        case .BinaryOperation(let symbol, _, _):
            let op1Desc = descriptionHelper(remainingOps)
            let op1Str = encloseDesc(op1Desc, mine: precedence)
            let op2Desc = descriptionHelper(op1Desc.remain)
            let op2Str = encloseDesc(op2Desc, mine: precedence)
            return (op2Str + symbol + op1Str, precedence, op2Desc.remain)
        case .ConstantOperation(let symbol, _):
            return (symbol, precedence, remainingOps)
        case .Variable(let name):
            return (name, precedence, remainingOps)
        }
    }
    
    private func encloseDesc(desc: (String, Int, [Op]), mine: Int) -> String {
        var retStr = desc.0
        if desc.1 < mine {
            retStr = "(" + retStr + ")"
        }
        return retStr
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        // arithmetic operations
        learnOp(Op.BinaryOperation("+", 1, +))
        learnOp(Op.BinaryOperation("−", 1) {$1 - $0})
        learnOp(Op.BinaryOperation("×", 2, *))
        learnOp(Op.BinaryOperation("÷", 2) {$1 / $0})
        learnOp(Op.UnaryOperation("√") {sqrt($0)})
        learnOp(Op.UnaryOperation("±") {-$0})
        learnOp(Op.UnaryOperation("sin") {sin($0)})
        learnOp(Op.UnaryOperation("cos") {cos($0)})
        // constants
        learnOp(Op.ConstantOperation("π", M_PI))
        // variables (hard coded variable names)
        learnOp(Op.Variable("M"))

    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation( _, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, _, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .ConstantOperation(_, let constantValue):
                return (constantValue, remainingOps)
            case .Variable(let name):
                if let val = variableValues[name] {
                    return (val, remainingOps)
                }
            }
        }
        return (nil, ops)
    }

    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(operand: String) -> Double? {
        opStack.append(Op.Variable(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func resetOpStack() {
        opStack.removeAll()
    }
    
    func resetVariables() {
        variableValues.removeAll()
    }
    
    func resetBrain() {
        resetOpStack()
        resetVariables()
    }
        
    var description: String {
        var retDesc = descriptionHelper(opStack)
        var retStr = retDesc.str
        while retDesc.remain.count > 0 {
            retDesc = descriptionHelper(retDesc.remain)
            retStr = retDesc.str + "," + retStr
        }
        return retStr
    }
}