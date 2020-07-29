//
//  IntegerSliderView.swift
//
//  Created by Leslie Schultz on 7/28/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI

/// A generic integer-valued slider parameterized by an integer min and max.
struct IntegerSliderView: View {
	@Binding var value: Int
	var min: Int
	var max: Int
	
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
				in: Double(min)...Double(max),
				step: 1.0
			)
		}
    }
}

struct IntegerSliderView_Previews: PreviewProvider {
    static var previews: some View {
		IntegerSliderView(
			value: .constant(3),
			min: 1,
			max: 5
		)
    }
}
