//
//  EvaluatorInput.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

protocol EvaluatorInput {
    
    func nextStatement() -> ASTStatement?
    
}

class EvaluatorParserInput: EvaluatorInput {
    
    let parser: Parser
    
    init(parser: Parser) {
        self.parser = parser
    }
    
    func nextStatement() -> ASTStatement? {
        do {
            return try parser.nextStatement()
        }
        catch let error {
            NSLog("Error parsing input: \(error)")
            return nil
        }
    }
    
}