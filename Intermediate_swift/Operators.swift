//
//  Operators.swift
//  Intermediate_swift
//
//  Created by Vasileios  Gkreen on 15/11/21.
//

import Foundation



/**
 - returns: ComparisonResult
 - parameters: lhs
	- lhs: T: Comparable
	- rhs: T: Comparable
 
		Comparison Operator that returns a ComparisonResult
 */
infix operator <=>
func <=><T: Comparable>(lhs: T, rhs: T) -> ComparisonResult {
	if lhs < rhs { return .orderedAscending }
	if lhs < rhs { return .orderedDescending }
	return .orderedSame
}


let left = 5
let right = 6
let result = left <=> right
