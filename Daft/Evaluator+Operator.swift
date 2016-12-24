//
//  Evaluator+Operator.swift
//  Daft
//
//  Created by Adam Shin on 12/23/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    class func evaluateBinaryOperator(op: BinaryOperator, _ lhs: ValueType, _ rhs: ValueType) throws -> RValue {
        switch op {
        case .addition: return try evaluateAddition(lhs, rhs)
        case .subtraction: return try evaluateSubtraction(lhs, rhs)
        case .multiplication: return try evaluateMultiplication(lhs, rhs)
        case .division: return try evaluateDivision(lhs, rhs)
            
        case .lessThan: return try evaluateLessThan(lhs, rhs)
        case .greaterThan: return try evaluateGreaterThan(lhs, rhs)
            
        case .equality: return try evaluateEquality(lhs, rhs)
            
        case .assignment: return try evaluateAssignment(lhs, rhs)
        }
    }
    
    private class func evaluateAddition(_ lhs: ValueType, _ rhs: ValueType) throws -> RValue {
        switch (lhs.value, rhs.value) {
        case let (.int(a), .int(b)):
            return addInts(a, b)
            
        case let (.string(a), .string(b)):
            return addStrings(a, b)
            
        case let (.string(a), .int(b)):
            return addStrings(a, String(b))
            
        case let (.int(a), .string(b)):
            return addStrings(String(a), b)
            
        default:
            throw EvaluatorError.invalidBinaryOperatorParameters
        }
    }
    
    private class func evaluateSubtraction(_ lhs: ValueType, _ rhs: ValueType) throws -> RValue {
        switch (lhs.value, rhs.value) {
        case let (.int(a), .int(b)):
            return subtractInts(a, b)
            
        default:
            throw EvaluatorError.invalidBinaryOperatorParameters
        }
    }
    
    private class func evaluateMultiplication(_ lhs: ValueType, _ rhs: ValueType) throws -> RValue {
        switch (lhs.value, rhs.value) {
        case let (.int(a), .int(b)):
            return multiplyInts(a, b)
            
        default:
            throw EvaluatorError.invalidBinaryOperatorParameters
        }
    }
    
    private class func evaluateDivision(_ lhs: ValueType, _ rhs: ValueType) throws -> RValue {
        switch (lhs.value, rhs.value) {
        case let (.int(a), .int(b)):
            return divideInts(a, b)
            
        default:
            throw EvaluatorError.invalidBinaryOperatorParameters
        }
    }
    
    private class func evaluateLessThan(_ lhs: ValueType, _ rhs: ValueType) throws -> RValue {
        switch (lhs.value, rhs.value) {
        case let (.int(a), .int(b)):
            return RValue(value: .bool(a < b))
            
        default:
            throw EvaluatorError.invalidBinaryOperatorParameters
        }
    }
    
    private class func evaluateGreaterThan(_ lhs: ValueType, _ rhs: ValueType) throws -> RValue {
        switch (lhs.value, rhs.value) {
        case let (.int(a), .int(b)):
            return RValue(value: .bool(a > b))
            
        default:
            throw EvaluatorError.invalidBinaryOperatorParameters
        }
    }
    
    private class func evaluateEquality(_ lhs: ValueType, _ rhs: ValueType) throws -> RValue {
        switch (lhs.value, rhs.value) {
        case let (.int(a), .int(b)):
            return RValue(value: .bool(a == b))
            
        case let (.bool(a), .bool(b)):
            return RValue(value: .bool(a == b))
            
        case let (.string(a), .string(b)):
            return RValue(value: .bool(a == b))
            
        default:
            throw EvaluatorError.invalidBinaryOperatorParameters
        }
    }
    
    private class func evaluateAssignment(_ lhs: ValueType, _ rhs: ValueType) throws -> RValue {
        guard let assignee = lhs as? LValue else {
            throw EvaluatorError.invalidAssignment
        }
        
        assignee.assign(rhs.value)
        return RValue(value: rhs.value)
    }
    
}

extension Evaluator {

    fileprivate class func addInts(_ a: Int, _ b: Int) -> RValue {
        return RValue(value: .int(a + b))
    }

    fileprivate class func addStrings(_ a: String, _ b: String) -> RValue {
        return RValue(value: .string(a + b))
    }

    fileprivate class func subtractInts(_ a: Int, _ b: Int) -> RValue {
        return RValue(value: .int(a - b))
    }
    
    fileprivate class func multiplyInts(_ a: Int, _ b: Int) -> RValue {
        return RValue(value: .int(a * b))
    }
    
    fileprivate class func divideInts(_ a: Int, _ b: Int) -> RValue {
        return RValue(value: .int(a / b))
    }

}
