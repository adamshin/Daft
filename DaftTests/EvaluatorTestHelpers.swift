//
//  EvaluatorTestHelpers.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

struct EvaluatorTestCase {
    let input: String
    let expected: Any
}

struct EvaluatorErrorCase {
    let input: String
    let error: EvaluatorError
}

//func testEvaluator(testCases: [EvaluatorTestCase], errorCases: [EvaluatorErrorCase], test: (Evaluator) throws -> Any) {
//    testCases.forEach {
//        let tokens = try! Lexer(input: LexerStringInput(string: $0.input)).allTokens()
//        let statements = try! Parser(input: ParserArrayInput(tokens: tokens)).allStatements()
//        let evaluator = Evaluator(input: EvaluatorArrayInput(statements: statements))
//        
//        do {
//            let result = try test(evaluator)
//            
//            let expected = String(describing: $0.expected)
//            let actual = String(describing: result)
//            
//            XCTAssertEqual(actual, expected)
//        }
//        catch let error {
//            XCTFail("Evaluator threw error on valid input: \(error)")
//        }
//    }
//    
//    errorCases.forEach {
//        let tokens = try! Lexer(input: LexerStringInput(string: $0.input)).allTokens()
//        let statements = try! Parser(input: ParserArrayInput(tokens: tokens)).allStatements()
//        let evaluator = Evaluator(input: EvaluatorArrayInput(statements: statements))
//        
//        do {
//            let _ = try test(evaluator)
//            XCTFail("Evaluator failed to throw error.")
//        }
//        catch let error as EvaluatorError {
//            XCTAssertEqual(error, $0.error, "Evaluator threw incorrect error.")
//        }
//        catch {
//            XCTFail("Evaluator threw unrecognized error.")
//        }
//    }
//}
