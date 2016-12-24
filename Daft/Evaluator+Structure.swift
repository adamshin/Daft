//
//  Evaluator+Structure.swift
//  Daft
//
//  Created by Adam Shin on 12/24/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    class func evaluateCodeBlock(_ block: ASTCodeBlock, environment: Environment, debugOutput: EvaluatorDebugOutput) throws {
        let blockEnvironment = Environment(enclosingEnvironment: environment)
        
        try block.statements.forEach {
            try evaluateStatement($0, environment: blockEnvironment, debugOutput: debugOutput)
        }
    }
    
}
