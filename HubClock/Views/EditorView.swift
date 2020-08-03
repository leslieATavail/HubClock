//
//  EditorView.swift
//  HubClock
//
//  Created by Leslie Schultz on 7/27/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI

/// The view for editing the current Hub time.
struct EditorView: View {
	// Required parameters
	@Binding var draftHubTime: HubTime
	@Binding var isEditing: Bool
	
	// Pre-initialized local state
	@State var cycleIsValid = true
	@State var sliceIsValid = true
	@State var tickIsValid = true
	@State var tickuleIsValid = true
	
	// Inherited/captured/injected
	@EnvironmentObject var userData: UserData
	
	/// Aggregate the view's validity from the individual validity of the fields
	/// with not-completely-locked-down input UIs.
	var isValid : Bool {
		cycleIsValid && sliceIsValid && tickIsValid && tickuleIsValid
	}
	
	var body: some View {
		VStack {
			HStack {
				Button("Cancel") {
					self.draftHubTime = self.userData.hubTime
					self.isEditing = false
				}
				
				Spacer()
				
				Button("Save") {
					self.userData.hubTime = self.draftHubTime
					self.isEditing = false
				}
					.disabled(!isValid)
			}
				.padding(.bottom, 50)
			
			HStack {
				Text("*")
				NonnegativeIntegerField(
					label: "Cycle",
					value: $draftHubTime.cycle,
					max: Int.max,
					isValid: $cycleIsValid
				)
					.truncationMode(.head)
			}
				.font(Font.custom("Digital-7Mono", size: 60))
			
			// I would love to be able to use a wheel picker here, but you
			// can't resize them!
			// https://developer.apple.com/forums/thread/123893
			Stepper(
				"Precision: \(draftHubTime.precision)",
				value: $draftHubTime.precision,
				in: HubTime.precisionRange
			)
				.padding(.bottom, 50)
			
			HStack {
				NonnegativeIntegerField(
					label: "Slice",
					value: $draftHubTime.slice,
					max: HubTime.slicesPerCycle - 1,
					isValid: $sliceIsValid
				)
				Text("′")
				NonnegativeIntegerField(
					label: "Tick",
					value: $draftHubTime.tick,
					max: HubTime.ticksPerSlice - 1,
					isValid: $tickIsValid
				)
				Text("″")
				NonnegativeIntegerField(
					label: "Tickule",
					value: $draftHubTime.tickule,
					max: HubTime.tickulesPerTick - 1,
					isValid: $tickuleIsValid
				)
			}
				.font(Font.custom("Digital-7Mono", size: 60))
			
			Spacer()
		}
			.padding()
	}
}

struct EditorView_Previews: PreviewProvider {
	static var previews: some View {
		EditorView(
			draftHubTime: .constant(HubTime()),
			isEditing: .constant(true)
		)
			.environmentObject(UserData())
	}
}
