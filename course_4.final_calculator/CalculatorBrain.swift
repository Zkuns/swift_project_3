//
//  File.swift
//  course_4.final_calculator
//
//  Created by 朱坤 on 10/12/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

func == (a: CalculatorBrain.Op, b: CalculatorBrain.Op) -> Bool{
    switch (a, b) {
    case (.Constant(let x, _), .Constant(let y, _)): return (x == y)
    default: return false
    }
}

import Foundation

class CalculatorBrain{
    
    enum Op: CustomStringConvertible, Equatable{
        case Number(Double);
        case Constant(String,value: Double?);
        case UnaryOperation(String, (Double)->Double);
        case BinaryOperation(String, (Double, Double)->Double);
        var description: String{
            get{
                switch self{
                case .Number(let number):
                    return "\(number)"
                case .Constant(let name, _):
                    return name
                case .UnaryOperation(let name, _):
                    return name
                case .BinaryOperation(let name, _):
                    return name
                }
            }
        }
    }
    
    var process: String{
        get{
            return describe(operations)
        }
    }
    var operations = [Op]()
    private var knownOperation = [String: Op]()
    var last_operation_is_lower_priority = false
    private var m_value:Double?
    
    init(){
        knownOperation["+"] = Op.BinaryOperation("+", +)
        knownOperation["−"] = Op.BinaryOperation("−"){ $1 - $0 }
        knownOperation["×"] = Op.BinaryOperation("×", *)
        knownOperation["÷"] = Op.BinaryOperation("÷"){ $1 / $0 }
        knownOperation["√"] = Op.UnaryOperation("√", sqrt)
        knownOperation["sin"] = Op.UnaryOperation("sin", sin)
        knownOperation["cos"] = Op.UnaryOperation("cos", cos)
        knownOperation["π"] = Op.Constant("π", value: M_PI)
        knownOperation["M"] = Op.Constant("M", value: m_value)
    }
    
    func has_m() -> Bool{
        var result = false
        operations.map{
            switch $0{
            case .Constant(let str, _):
                result = (str == "M" && m_value == nil)
            default: break;
            }
        }
        return result
    }
    
    func addNumber(sym: String){
        if let op = knownOperation[sym]{
            operations.append(op)
        } else {
            let digit = NSNumberFormatter().numberFromString(sym)!.doubleValue
            operations.append(Op.Number(digit))
        }
    }
    
    func addOperation(name: String) -> (run: Bool, result: Double, desc: String){
        var run = true
        var result = 0.0
        var desc = process
        if let opera = knownOperation[name] {
            switch opera{
                case .UnaryOperation(_, _):
                    operations.append(opera)
                    desc = process
                    result = evaluate()
                case .BinaryOperation(let b_opera, _):
                    if ( (b_opera == "×" || b_opera == "÷") && last_operation_is_lower_priority ) {
                        run = false
                        last_operation_is_lower_priority = true
                    } else {
                        result = evaluate()
                    }
                    if (b_opera == "+" || b_opera == "−"){ last_operation_is_lower_priority = true }
                    operations.append(opera)
                default: break
            }
        }
        return (run, result, desc)
    }
    
    private func evaluate(result: Double?, var remain: [Op]) -> Double{
        if (remain.count > 0) {
            let opera = remain.removeLast()
            switch opera{
                case .Number(let digit):
                    return evaluate(digit, remain: remain)
                case .Constant(let str, let digit):
                    if str == "M"{
                        return evaluate(m_value, remain: remain)
                    } else{
                        return evaluate(digit, remain: remain)
                    }
                case .UnaryOperation(_, let function):
                    let opera_second = remain.removeLast()
                    switch opera_second{
                        case .Number(let digit):
                            return evaluate(function(digit), remain: remain)
                        case .Constant(let str, let digit):
                            if str == "M"{
                                return evaluate(function(m_value!), remain: remain)
                            } else {
                                return evaluate(function(digit!), remain: remain)
                            }
                        default: break
                    }
                case .BinaryOperation(_, let function):
                    if let digit = result {
                        let opera_second = remain.removeLast()
                        switch opera_second {
                        case .Number(let digit_second):
                            return evaluate(function(digit, digit_second), remain: remain)
                        case .Constant(let str, let digit_second):
                            if str == "M"{
                                return evaluate(function(digit, m_value!), remain: remain)
                            } else {
                                return evaluate(function(digit, digit_second!), remain: remain)
                            }
                        default: break
                        }
                    }
            }
        }
        return result!
    }
    
    func describe(var stack: [Op])-> String{
        var str = ""
        for (index, element) in stack.enumerate(){
            switch element{
                case .UnaryOperation(_, _):
                    let temp = stack[index]
                    stack[index] = stack[index-1]
                    stack[index-1] = temp
                default: break
            }
        }
        for element in stack{
            str = str + element.description
        }
        return str
    }
    
    func evaluate() -> Double{
        if (!has_m()){
            let result = evaluate(0, remain: operations)
            operations = [Op.Number(result)]
            return result
        } else {
            return 0
        }
    }
    
    func evaluate_for_image(x: Double) -> Double{
        m_value = x
        print(evaluate(0, remain: operations))
        return evaluate(0, remain: operations)
    }
    
    func clear(){
        operations = []
        m_value = nil
    }
    
    func enterM(sym: String){
        if let op = knownOperation[sym]{
            switch op{
            case .Constant(_, let digit): m_value = digit
            default: break
            }
        } else {
            m_value = NSNumberFormatter().numberFromString(sym)!.doubleValue
        }
    }
}