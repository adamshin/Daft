//
//  LexerTests.swift
//  DaftTests
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

struct LexerTestCase {
    let input: String
    let expected: [Token]
}

class LexerTestInput: LexerInput {
    
    let string: String
    var location: String.Index
    
    init(string: String) {
        self.string = string
        location = string.startIndex
    }
    
    func nextChar() -> Character? {
        guard location < string.endIndex else { return nil }
        
        return string[location]
    }
    
    func consumeChar() {
        guard location < string.endIndex else { return }
        
        location = string.index(location, offsetBy: 1)
    }
    
}

let testCases = [
    LexerTestCase(
        input: "let foo = 42",
        expected: [
            .letKeyword,
            .identifier(value: "foo"),
            .assign,
            .intLiteral(value: "42"),
        ]
    ),
    LexerTestCase(
        input: "(123 + 45) - 6",
        expected: [
            .leftParen,
            .intLiteral(value: "123"),
            .binaryOperator(type: .addition),
            .intLiteral(value: "45"),
            .rightParen,
            .binaryOperator(type: .subtraction),
            .intLiteral(value: "6"),
        ]
    ),
    LexerTestCase(
        input: "func   asdf(a,b)\n\n {}",
        expected: [
            .funcKeyword,
            .identifier(value: "asdf"),
            .leftParen,
            .identifier(value: "a"),
            .comma,
            .identifier(value: "b"),
            .rightParen,
            .newline,
            .newline,
            .leftBrace,
            .rightBrace,
        ]
    ),
]

class LexerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testLexer() {
        testCases.forEach { testCase in
            let lexer = Lexer(input: LexerTestInput(string: testCase.input))
            testCase.expected.forEach {
                let token = try! lexer.nextToken()
                XCTAssertEqual($0, token)
            }
            XCTAssertNil(try! lexer.nextToken())
        }
    }
    
}
