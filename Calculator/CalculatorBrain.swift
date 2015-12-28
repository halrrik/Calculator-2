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
        case BinaryOperation(String, (Double, Double) -> Double)
        case ConstantOperation(String, Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .ConstantOperation(let symbol, _):
                    return symbol
                case .Variable(let name):
                    return name
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var variableValues = [String:Double]()
    
    private func descriptionHelper(ops: [Op]) -> (str: String, remain: [Op]) {
        guard ops.count > 0 else { return ("?", ops) }
        
        var remainingOps = ops
        let op = remainingOps.removeLast()
        
        switch op {
        case .Operand(let val):
            return ("\(val)", remainingOps)
        case .UnaryOperation(let symbol, _):
            let operandDesc = descriptionHelper(remainingOps)
            return (symbol+operandDesc.str, operandDesc.remain)
        case .BinaryOperation(let symbol, _):
            let op1Desc = descriptionHelper(remainingOps)
            let op2Desc = descriptionHelper(op1Desc.remain)
            return ("("+op2Desc.str + symbol + op1Desc.str+")", op2Desc.remain)
        case .ConstantOperation(let symbol, _):
            return (symbol, remainingOps)
        case .Variable(let name):
            return (name, remainingOps)
        }
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1 - $0})
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") {$1 / $0})
        learnOp(Op.UnaryOperation("√") {sqrt($0)})
        learnOp(Op.UnaryOperation("±") {-$0})
        learnOp(Op.UnaryOperation("sin") {sin($0)})
        learnOp(Op.UnaryOperation("cos") {cos($0)})

        learnOp(Op.ConstantOperation("π", M_PI))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
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
    
    func resetBrain() {
        opStack.removeAll()
    }
        
    var description: String {
        var retDesc = descriptionHelper(opStack)
        var retStr = retDesc.str
        while retDesc.remain.count > 0 {
            retDesc = descriptionHelper(retDesc.remain)
            retStr = retStr + "," + retDesc.str
        }
        return retStr
    }
}