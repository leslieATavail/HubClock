//
//  IntegerField.swift
//  HubClock
//
//  Created by Leslie Schultz on 7/28/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI

/// Customized field view for integers that validates the current value is
/// composed only of digit characters and represents an integer value less than
/// or equal to the supplied maximum. When the value is invalid, text is
/// displayed in red; otherwise, it is displayed in a color appropriate for the
/// current color scheme. The parent view must pass in a binding in which the
/// validity of the field's current value will be stored; this allows the parent
/// to calculate their total validity without actively interrogating children.
struct IntegerField: View {
	// Required parameters
	let label: String
	@Binding var value: Int
	let max: Int
	@Binding private var isValid: Bool
	
	// Pre-initialized local state
	@State private var userInput: String = ""
	
	// Inherited/captured/injected
    @Environment(\.colorScheme) var colorScheme
	
	init(label: String, value: Binding<Int>, max: Int, isValid: Binding<Bool>) {
		self.label = label
		self._value = value
		self.max = max
		self._isValid = isValid
	}
	
	private func updateState(_ text: String) {
		// Always accept the new string into the local model.
		self.userInput = text
		
		// Set the integer value and validity flag based on conformance.
		if text == "" {
			self.value = 0
			self.isValid = true
		} else if text.allSatisfy({ "0123456789".contains($0) }),
			let intValue = Int(text),
			intValue <= self.max
		{
			self.value = intValue
			self.isValid = true
		} else {
			// View is initialized from a nonempty Int binding, so since
			// self.value is never unset, it always has an Int.
			self.isValid = false
		}
	}
	
    var body: some View {
		TextField(
			label,
			text: Binding(
				get: {
					self.userInput
				},
				set: { newString in
					self.updateState(newString)
				}
			)
		)
			.keyboardType(.numberPad)
			.textFieldStyle(RoundedBorderTextFieldStyle())
			.foregroundColor(!self.isValid ? .red :
				(colorScheme == .dark ? .white : .black))
			.multilineTextAlignment(.trailing)
			.onAppear {
				// On view mount, force-populate the state variables with
				// initial values based on the binding. These fields will be
				// updated later when the user changes the input value.
				self.updateState(String(self.value))
			}
    }
}

struct NumberField_Previews: PreviewProvider {
    static var previews: some View {
		IntegerField(
			label: "Number",
			value: .constant(0),
			max: 100,
			isValid: .constant(true)
		)
    }
}
