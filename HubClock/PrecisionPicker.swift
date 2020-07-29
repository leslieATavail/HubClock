//
//  PrecisionPicker.swift
//  HubClock
//
//  Created by Leslie Schultz on 7/28/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI

struct PrecisionSlider: View {
	@Binding var hubTime: HubTime
	
    var body: some View {
		VStack {
			HStack {
				Text("Precision").bold()
				Divider()
				Text(String(Int(hubTime.precision)))
			}
			IntegerSlider(
				value: $hubTime.precision,
				min: HubTime.minPrecision,
				max: HubTime.maxPrecision
			)
		}
    }
}

/// A generic integer-valued slider parameterized by an integer min and max.
struct IntegerSlider: View {
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
					set: { value in
						self.value = Int(value)
					}
				),
				in: Double(min)...Double(max),
				step: 1.0
			)
		}
    }
}

struct PrecisionPicker_Previews: PreviewProvider {
    static var previews: some View {
		return PrecisionSlider(
			hubTime: .constant(HubTime())
		)
    }
}
