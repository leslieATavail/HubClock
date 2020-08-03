//
//  QuotientAndRemainder.swift
//  HubClock
//
//  Created by Leslie Schultz on 8/2/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import Foundation

infix operator /% : AdditionPrecedence // though the result shouldn't participate in ANY math

extension Int {
	static func /% (dividend: Int, divisor: Int) -> (Int, Int) {
		return dividend.quotientAndRemainder(dividingBy: divisor)
	}
}
