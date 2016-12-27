//
//  ParserExpressionTests.swift
//  Daft
//
//  Created by Adam Shin on 12/17/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

class ParserExpressionTests: XCTestCase {
    
    // MARK: - Expressions
    
    func testParseBinarySeriesExpression() {
        let testCases = [
            ParserTestCase(
                input: "1",
                expected: binarySeries(postfix(intLiteral("1")))
            ),
            ParserTestCase(
                input: "2 + 3",
                expected: binarySeries([
                    postfix(intLiteral("2")),
                    postfix(intLiteral("3")),
                ], [
                    binaryOperator(.addition)
                ])
            ),
            ParserTestCase(
                input: "4 - 5 + 6",
                expected: binarySeries([
                    postfix(intLiteral("4")),
                    postfix(intLiteral("5")),
                    postfix(intLiteral("6")),
                ], [
                    binaryOperator(.subtraction),
                    binaryOperator(.addition),
                ])
            ),
        ]
        let errorCases = [
            ParserErrorCase(input: "1 +", error: .endOfFile),
            ParserErrorCase(input: "1 + +", error: .unexpectedToken),
            ParserErrorCase(input: "+ 2", error: .unexpectedToken),
        ]
        testParser(testCases: testCases, errorCases: errorCases) { try $0.parseBinarySeriesExpression() }
    }
    
    // MARK: - Postfix Expressions
    
    func testParsePostfixExpression() {
        let testCases = [
            ParserTestCase(
                input: "a",
                expected: postfix(identifier("a"), [])
            ),
            ParserTestCase(
                input: "b()",
                expected: postfix(
                    identifier("b"),
                    [
                        functionCallArgumentList([])
                    ]
                )
            ),
            ParserTestCase(
                input: "c()()",
                expected: postfix(
                    identifier("c"),
                    [
                        functionCallArgumentList([]),
                        functionCallArgumentList([]),
                    ]
                )
            ),
        ]
        testParser(testCases: testCases, errorCases: []) { try $0.parsePostfixExpression() }
    }
    
    func testParseFunctionCallArgumentList() {
        let testCases = [
            ParserTestCase(
                input: "()",
                expected: functionCallArgumentList([])
            ),
            ParserTestCase(
                input: "(spam)",
                expected: functionCallArgumentList([
                    binarySeries(postfix(identifier("spam")))
                ])
            ),
            ParserTestCase(
                input: "(ham, eggs)",
                expected: functionCallArgumentList([
                    binarySeries(postfix(identifier("ham"))),
                    binarySeries(postfix(identifier("eggs"))),
                ])
            ),
            ParserTestCase(
                input: "(2, 4, 8)",
                expected: functionCallArgumentList([
                    binarySeries(postfix(intLiteral("2"))),
                    binarySeries(postfix(intLiteral("4"))),
                    binarySeries(postfix(intLiteral("8"))),
                ])
            ),
        ]
        let errorCases = [
            ParserErrorCase(input: "a", error: .unexpectedToken),
            ParserErrorCase(input: ")", error: .unexpectedToken),
            ParserErrorCase(input: "(", error: .endOfFile),
            ParserErrorCase(input: "(a,)", error: .unexpectedToken),
            ParserErrorCase(input: "(, b)", error: .unexpectedToken),
        ]
        testParser(testCases: testCases, errorCases: errorCases) { try $0.parseFunctionCallArgumentList() }
    }
    
    // MARK: - Primary Expressions
    
    func testParsePrimaryExpression() {
        let testCases = [
            ParserTestCase(
                input: "(1)",
                expected: parenthesized(binarySeries(postfix(intLiteral("1"))))
            ),
            ParserTestCase(
                input: "bacon",
                expected: identifier("bacon")
            ),
            ParserTestCase(
                input: "5555",
                expected: intLiteral("5555")
            ),
            ParserTestCase(
                input: "\"hello world\"",
                expected: stringLiteral("hello world")
            ),
            ParserTestCase(
                input: "void",
                expected: voidLiteral()
            ),
            ParserTestCase(
                input: "func() { }",
                expected: function(argumentList([]), codeBlock([]))
            ),
        ]
        let errorCases = [
            ParserErrorCase(input: "var", error: .unexpectedToken),
            ParserErrorCase(input: "+", error: .unexpectedToken),
            ParserErrorCase(input: ";", error: .unexpectedToken),
            ParserErrorCase(input: "{", error: .unexpectedToken),
        ]
        testParser(testCases: testCases, errorCases: errorCases) { try $0.parsePrimaryExpression() }
    }
    
    func testParseParenthesizedExpression() {
        let testCases = [
            ParserTestCase(
                input: "(banana)",
                expected: parenthesized(
                    binarySeries(postfix(identifier("banana")))
                )
            ),
            ]
        let errorCases = [
            ParserErrorCase(input: "()", error: .unexpectedToken),
            ParserErrorCase(input: "a", error: .unexpectedToken),
            ParserErrorCase(input: "(a", error: .endOfFile),
            ParserErrorCase(input: "(a;", error: .unexpectedToken),
            ]
        testParser(testCases: testCases, errorCases: errorCases) { try $0.parseParenthesizedExpression() }
    }

}
