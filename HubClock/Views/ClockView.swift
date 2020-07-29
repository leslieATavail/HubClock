//
//  ClockView.swift
//  HubClock
//
//  Created by Leslie Schultz on 7/28/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI

/// The main view for the clock app.
struct ClockView: View {
	// (No required parameters)
	
	// Pre-initialized local state
	@State var isRunning = false
	@State var isEditing = false
	@State var draftHubTime = HubTime()
	
	// Inherited/captured/injected
	@EnvironmentObject var userData: UserData
	
	// Get a timer publisher that publishes an event every time a tickule has
	// elapsed, and start it running.
	let timer = Timer.publish(
		every: HubTime.secondsPerTickule,
		on: .main,
		in: .common
	).autoconnect()
	
	// Custom color for UI elements that blends with the background image.
	let duskyPurple = Color(hue: 0.65, saturation: 0.5, brightness: 0.5)
	
	var body: some View {

		VStack {
			
			// Show an edit button at the top right, and only enable it when the
			// clock is stopped.
			HStack {
				Spacer()
				Button(action: { self.isEditing = true }) {
					Text("Edit")
						.foregroundColor(self.isRunning ? .gray : .white)
				}
				.disabled(self.isRunning)
			}
			.padding()
			
			Spacer()
			
			// Display the formatted cycle string.
			Text(userData.hubTime.cycleString)
				.foregroundColor(.white)
				.font(Font.custom("Digital-7Mono", size: 60))
				.padding(.bottom, 40)
				.padding(.trailing, 30) // Push left so the * is deemphasized
			
			// Display the formatted time string, and set up timer publications
			// to trigger time incrementing.
			Text(userData.hubTime.timeString)
				.foregroundColor(.white)
				.font(Font.custom("Digital-7Mono", size: 80))
				.padding(.bottom, 40)
			
			// Create and style the pause/play button, and bind it to the flag
			// that tells the event handler whether to increment.
			Button(action: { self.isRunning.toggle() }) {
				Image(systemName: isRunning ? "pause" : "play")
					.resizable()
					.frame(width: 20, height: 20)
					.padding()
					.background(Color.white)
					.foregroundColor(duskyPurple)
					.clipShape(Circle())
					.accessibility(label: Text(isRunning ? "Pause" : "Play"))
				
			}
				.buttonStyle(PlainButtonStyle()) // Suppress recoloring
			
			Spacer()
		}
			// Register an action to be triggered whenever the timer publishes,
			// which will be every time a tickule has elapsed. Note that when
			// the time surpasses the maximum representable value, it will roll
			// over and the cycle number will increment.
			.onReceive(timer) { _ in
				// Only increment while the run flag is on. This is probably not
				// the best way to do this...
				if self.isRunning {
					self.userData.hubTime.totalTickules += 1
					// An amount of time less than a single tickule can be
					// lost every time the timer is started and then stopped
					// again because sub-tickule elapsed time is not carried
					// over when the timer starts again. So don't use this
					// as a stopwatch!
				}
			}
			// Set the background image.
			.background(
				Image("medium background")
					.rotationEffect(Angle(degrees: 90.0))
					// Adjust the frame and impose a background color that
					// extends beyond the safe area in order to hide background
					// image resizing quirks/flaws at the edge.
					.frame(maxHeight: .infinity)
					.background(duskyPurple)
					.edgesIgnoringSafeArea(.all)
			)
			// Add the editor view as a modal.
			.sheet(isPresented: $isEditing) {
				EditorView(
					draftHubTime: self.$draftHubTime,
					isEditing: self.$isEditing
				)
					// Because the EditorView is used as a sheet, it isn't a
					// child View that will inherit the userData environment
					// object. So inject it, because we need access.
					.environmentObject(self.userData)
					.onAppear {
						self.draftHubTime = self.userData.hubTime
					}
			}
	}
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView()
			.environmentObject(UserData())
    }
}
