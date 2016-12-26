//
//  Evaluator+Structure.swift
//  Daft
//
//  Created by Adam Shin on 12/24/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    class func evaluateCodeBlock(_ block: ASTCodeBlock, environment: Environment, debugOutput: EvaluatorDebugOutput) throws -> ObjectValue? {
        let blockEnvironment = Environment(enclosedBy: environment)
        
        for statement in block.statements {
            if let returnValue = try evaluateStatement(statement, environment: blockEnvironment, debugOutput: debugOutput) {
                return returnValue
            }
        }
        return nil
    }
    
}
