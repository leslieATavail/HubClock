//
//  Exponentiative.swift
//
//  Created by Leslie Schultz on 7/26/20.
//  Using: https://forums.swift.org/t/exponents-in-swift/18337/8 (corrected)
//

import Foundation

// Define a new precedence group to use when declaring an exponentiation
// operator, and specify it has higher precedence than the math operations
// likely to be used near it.
precedencegroup ExponentiationPrecedence {
	associativity: right // This was incorrectly suggested as "left"
	higherThan: MultiplicationPrecedence
}

// Create a new infix operator for exponentiation.
infix operator ** : ExponentiationPrecedence

// Define the behavior of exponentiation as operating on, and returning,
// BinaryInteger protocol values. Define the actual calculation logic.
public func ** <N: BinaryInteger>(base: N, power: N) -> N {
	return N.self( pow(Double(base), Double(power)) )
}
