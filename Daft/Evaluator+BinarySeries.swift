//
//  Evaluator+BinarySeries.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    class func evaluateBinarySeriesExpression(_ expression: ASTBinarySeriesExpression, stack: Stack) throws -> RValue {
        let values = try expression.expressions.map { try evaluatePostfixExpression($0, stack: stack) }
        let operators = expression.operators.map { $0.type }
        
        let items = try interleave(values: values, operators: operators)
        let postfix = convertToPostfix(items: items, precedence: precedence, associativity: associativity)
        return try evaluatePostfix(items: postfix, evaluate: Evaluator.evaluateBinaryOperator)
    }
    
}
    
private enum ExpressionItem {
    case value(ValueType)
    case op(BinaryOperator)
}

private enum Associativity {
    case left
    case right
}

private func precedence(op: BinaryOperator) -> Int {
    switch op {
    case .multiplication, .division:
        return 5
    case .addition, .subtraction:
        return 4
    case .lessThan, .greaterThan:
        return 3
    case .equality:
        return 2
    case .assignment:
        return 1
    }
}

private func associativity(op: BinaryOperator) -> Associativity {
    switch op {
    case .addition, .subtraction, .multiplication, .division, .lessThan, .greaterThan, .equality:
        return .left
    case .assignment:
        return .right
    }
}

private func interleave(values: [ValueType], operators: [BinaryOperator]) throws -> [ExpressionItem] {
    guard values.count > 0, operators.count == values.count - 1 else {
        throw EvaluatorError.invalidBinarySeriesExpression
    }
    
    var valueList = values
    var operatorList = operators
    var output = [ExpressionItem]()
    
    output.append(.value(valueList.removeFirst()))
    while !valueList.isEmpty {
        output.append(.op(operatorList.removeFirst()))
        output.append(.value(valueList.removeFirst()))
    }
    return output
}

private func convertToPostfix(items: [ExpressionItem], precedence: (BinaryOperator) -> Int, associativity: (BinaryOperator) -> Associativity) -> [ExpressionItem] {
    var input = items
    var output = [ExpressionItem]()
    var operatorStack = [BinaryOperator]()
    
    while !input.isEmpty {
        switch input.removeFirst() {
        case let .value(v):
            output.append(.value(v))
            
        case let .op(o1):
            while let o2 = operatorStack.last, (associativity(o1) == .left && precedence(o1) <= precedence(o2)) || (associativity(o1) == .right && precedence(o1) < precedence(o2)) {
                output.append(.op(operatorStack.removeLast()))
            }
            operatorStack.append(o1)
        }
    }
    
    while !operatorStack.isEmpty {
        output.append(.op(operatorStack.removeLast()))
    }
    
    return output
}

private func evaluatePostfix(items: [ExpressionItem], evaluate: (BinaryOperator, ValueType, ValueType) throws -> RValue) throws -> RValue {
    var input = items
    var stack = [ValueType]()
    
    while !input.isEmpty {
        switch input.removeFirst() {
        case let .value(v):
            stack.append(v)
            
        case let .op(o):
            guard stack.count >= 2 else {
                throw EvaluatorError.invalidBinarySeriesExpression
            }
            
            let rhs = stack.removeLast()
            let lhs = stack.removeLast()
            
            try stack.append(evaluate(o, lhs, rhs))
        }
    }
    
    guard let result = stack.first, stack.count == 1 else {
        throw EvaluatorError.invalidBinarySeriesExpression
    }
    
    return RValue(value: result.value)
}
