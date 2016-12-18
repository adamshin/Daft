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
        testParserCases(testCases) { try $0.parseBinarySeriesExpression() }
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
                        argumentList([])
                    ]
                )
            ),
            ParserTestCase(
                input: "c()()",
                expected: postfix(
                    identifier("c"),
                    [
                        argumentList([]),
                        argumentList([]),
                    ]
                )
            ),
        ]
        testParserCases(testCases) { try $0.parsePostfixExpression() }
    }
    
    func testParseArgumentList() {
        let testCases = [
            ParserTestCase(
                input: "()",
                expected: argumentList([])
            ),
            ParserTestCase(
                input: "(spam)",
                expected: argumentList([
                    binarySeries(postfix(identifier("spam")))
                ])
            ),
            ParserTestCase(
                input: "(ham, eggs)",
                expected: argumentList([
                    binarySeries(postfix(identifier("ham"))),
                    binarySeries(postfix(identifier("eggs"))),
                ])
            ),
            ParserTestCase(
                input: "(2, 4, 8)",
                expected: argumentList([
                    binarySeries(postfix(intLiteral("2"))),
                    binarySeries(postfix(intLiteral("4"))),
                    binarySeries(postfix(intLiteral("8"))),
                ])
            ),
        ]
        testParserCases(testCases) { try $0.parseArgumentList() }
    }
    
    // MARK: - Primary Expressions
    
    func testParsePrimaryExpression() {
        let testCases = [
            ParserTestCase(
                input: "5555",
                expected: intLiteral("5555")
            ),
            ParserTestCase(
                input: "\"hello world\"",
                expected: stringLiteral("hello world")
            ),
            ParserTestCase(
                input: "bacon",
                expected: identifier("bacon")
            ),
        ]
        testParserCases(testCases) { try $0.parsePrimaryExpression() }
    }
    
    func testParseParenthesizedExpression() {
        let testCases = [
            ParserTestCase(
                input: "(banana)",
                expected: parenthesized(
                    binarySeries(postfix(identifier("banana")))
                )
            ),
            ParserTestCase(
                input: "((8))",
                expected: parenthesized(
                    binarySeries(postfix(
                        parenthesized(
                            binarySeries(postfix(intLiteral("8")))
                        )
                    ))
                )
            ),
        ]
        testParserCases(testCases) { try $0.parseParenthesizedExpression() }
    }

}
