//
//  PrecisionSliderView.swift
//
//  Created by Leslie Schultz on 7/28/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI

/// A view for setting the precision value utilizing the custom
/// IntegerSliderView.
struct PrecisionSliderView: View {
	@Binding var hubTime: HubTime
	
	var body: some View {
		VStack {
			HStack {
				Text("Precision:").bold()
				Text(String(Int(hubTime.precision)))
			}
			IntegerSliderView(
				value: $hubTime.precision,
				min: HubTime.minPrecision,
				max: HubTime.maxPrecision
			)
		}
	}
}

struct PrecisionSliderView_Previews: PreviewProvider {
	static var previews: some View {
		return PrecisionSliderView(
			hubTime: .constant(HubTime())
		)
	}
}
