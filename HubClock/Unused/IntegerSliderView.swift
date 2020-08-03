//
//  IntegerSliderView.swift
//
//  Created by Leslie Schultz on 7/28/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI

/// A generic integer-valued slider parameterized by an integer range.
struct IntegerSliderView: View {
	@Binding var value: Int
	var range: ClosedRange<Int>
	
	var body: some View {
		VStack {
			Slider(
				value: Binding(
					get: {
						Double(self.value)
					},
					set: { newValue in
						self.value = Int(newValue)
					}
				),
				in: Double(range.lowerBound)...Double(range.upperBound),
				step: 1.0
			)
		}
	}
}

struct IntegerSliderView_Previews: PreviewProvider {
	static var previews: some View {
		IntegerSliderView(value: .constant(3), range: 1...5)
	}
}
