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
    
    // MARK: - Postfix Expressions
    
    func testParsePostfixExpression() {
        let testCases = [
            ParserTestCase(
                input: "5555",
                expected: postfix(intLiteral("5555"), [])
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
                    singlePrimary(identifier("banana"))
                )
            ),
            ParserTestCase(
                input: "((8))",
                expected: parenthesized(
                    singlePrimary(
                        parenthesized(
                            singlePrimary(intLiteral("8"))
                        )
                    )
                )
            ),
        ]
        testParserCases(testCases) { try $0.parseParenthesizedExpression() }
    }

}
