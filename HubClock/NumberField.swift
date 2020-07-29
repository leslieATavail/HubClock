//
//  NumberField.swift
//  HubClock
//
//  Created by Leslie Schultz on 7/28/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI

struct IntegerField: View {
	let label: String
	@Binding var number: Int
	@State var string: String
	@State var lastInputValid: Bool
	
    var body: some View {
		TextField(
			label,
			text: Binding(
				get: {
					self.string
				},
				set: { newString in
					// Always accept the new string into the local model.
					self.string = newString
					self.lastInputValid = newString.allSatisfy {
						"0123456789".contains($0)
					}
					if (self.lastInputValid) {
						// Only write the numeric equivalent into the binding if
						// it's an integer.
						self.number = Int(newString)!
					}
				}
			)
		)
			.keyboardType(.numberPad)
    }
}

struct NumberField_Previews: PreviewProvider {
    static var previews: some View {
		IntegerField(
			label: "Number",
			number: .constant(0),
			string: "0"
		)
    }
}
