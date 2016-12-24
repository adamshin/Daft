//
//  EvaluatorBinarySeriesTests.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

struct EvaluatorBinarySeriesTestCase {
    let input: ASTBinarySeriesExpression
    let expected: RValue
}

class EvaluatorBinarySeriesTests: XCTestCase {
    
    func testEvaluateBinarySeries() {
        let testCases = [
            EvaluatorBinarySeriesTestCase(
                input: binarySeries([
                    postfix(intLiteral("1")),
                    postfix(intLiteral("2")),
                ], [
                    binaryOperator(.addition),
                ]),
                expected: RValue(value: .int(3))
            ),
            EvaluatorBinarySeriesTestCase(
                input: binarySeries([
                    postfix(intLiteral("5")),
                    postfix(intLiteral("2")),
                    postfix(intLiteral("1")),
                ], [
                    binaryOperator(.addition),
                    binaryOperator(.subtraction),
                ]),
                expected: RValue(value: .int(6))
            ),
            EvaluatorBinarySeriesTestCase(
                input: binarySeries([
                    postfix(intLiteral("5")),
                    postfix(intLiteral("2")),
                    postfix(intLiteral("1")),
                    ], [
                        binaryOperator(.subtraction),
                        binaryOperator(.addition),
                        ]),
                expected: RValue(value: .int(4))
            ),
            EvaluatorBinarySeriesTestCase(
                input: binarySeries([
                    postfix(intLiteral("4")),
                    postfix(intLiteral("5")),
                    postfix(intLiteral("10")),
                ], [
                    binaryOperator(.addition),
                    binaryOperator(.multiplication),
                ]),
                expected: RValue(value: .int(54))
            ),
            EvaluatorBinarySeriesTestCase(
                input: binarySeries([
                    postfix(intLiteral("4")),
                    postfix(intLiteral("2")),
                    postfix(intLiteral("5")),
                    postfix(intLiteral("1")),
                    postfix(intLiteral("6")),
                    postfix(intLiteral("3")),
                ], [
                    binaryOperator(.addition),
                    binaryOperator(.multiplication),
                    binaryOperator(.subtraction),
                    binaryOperator(.addition),
                    binaryOperator(.division),
                ]),
                expected: RValue(value: .int(15))
            ),
        ]
        testCases.forEach {
            do {
                let result = try Evaluator.evaluateBinarySeriesExpression($0.input, stack: Stack())
                
                let expected = String(describing: $0.expected)
                let actual = String(describing: result)
                
                XCTAssertEqual(actual, expected)
            }
            catch let error {
                XCTFail("Evaluator threw error on valid input: \(error)")
            }
        }
    }
    
}
