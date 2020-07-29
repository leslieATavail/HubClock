//
//  HubTime.swift
//  HubClock
//
//  Created by Leslie Schultz on 7/26/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI
import Combine

/// The HubTime struct holds the data required to represent time for the
/// fictional Elushae-universe world Hub.
///
/// Similarly to how we record time relative to a day number, hour, minute, and
/// second, Hub time is recorded as a "cycle" number, "slice", "tick", and
/// "tickule". The number of relative units of each are different (as shown
/// below) and there is no functional grouping higher than the cycle number; the
/// cycle just keeps incrementing forever. In this way, Hub datekeeping is
/// analagous to the Julian calendar.
///
/// In practice, the cycle number is overwhelmingly referenced using only some
/// limited number of trailing digits. This ambiguous value is called the
/// "splat" date, while the true, full-precision date is the "absolute" date.
/// This clock implementation allows the user to elide the leading cycle digits
/// and only display a splat date. If the clock is allowed to run up to and past
/// the precision specified, the date will *appear* to roll over, even if the
/// app knows the actual date with more precision.
struct HubTime {
	// Data and reference fields for the current cycle number.
	var cycle: Int = 0
	// The number of splat date digits the clock user "knows" and that we are
	// therefore allowed to show on the running clock. The user may change this
	// value, within the provided [min..max] range.
	var precision: Int = 3
	static let minPrecision = 1
	static let maxPrecision = 7 // Can be bumped up here as long as text fits
	
	// Data and reference fields for the current time.
	private var currentTickule: Int = 0
	// The ratios between various time groupings.
	static let slicesPerCycle = 16
	static let ticksPerSlice = 100
	static let tickulesPerTick = 100
	static let tickulesPerSlice = 10_000
	static let tickulesPerCycle = 160_000
	
	/// The single point of data that establishes the pace of Hub time passage
	/// relative to real-world common time. All other Hub time passage rates
	/// derive from this ratio.
	static let secondsPerTickule = 60.0 / 77.0
	
	/// The string that represents the current cycle, formatted to include the
	/// splat character and exactly as many digits as specified through the
	/// precision value.
	var cycleString: String {
		get {
			// Ex: If the internally-known cycle number is 12345,
			//     but the user's display precision is 3,
			//     display "*345"
			var formatted = String(format: "%0\(precision)d", cycle)
			let strLen = formatted.count
			if strLen > precision {
				formatted = String(formatted.dropFirst(strLen - precision))
			}
			return "*" + formatted
		}
	}
	
	/// A tuple of Hub time components (slice, ticks, tickules).
	var timeComponents: (Int, Int, Int) {
		get {
			// Calculate the values of the various time components, since we
			// do not store the time in those terms.
			let slice = currentTickule / Self.tickulesPerSlice
			let tick = (currentTickule / Self.tickulesPerTick)
				% Self.ticksPerSlice
			let tickule = currentTickule % Self.tickulesPerTick
			return (slice, tick, tickule)
		}
		set(components) {
			let (slice, tick, tickule) = components
			
			// Ensure data is well-formed; this should be enforced by inputs.
			assert(0 <= slice && slice < Self.slicesPerCycle)
			assert(0 <= tick && tick < Self.ticksPerSlice)
			assert(0 <= tickule && tickule < Self.tickulesPerTick)
			
			// Use the input to set the integer representations.
			currentTickule =
				slice * Self.tickulesPerSlice
				+ tick * Self.ticksPerSlice
				+ tickule
		}
	}
	
	/// The string that represents the current time, as a series of two-digit
	/// integers separated by custom separator characters.
	var timeString: String {
		get {
			// Ex: If the slice is 1, tick is 23, and tickule is 45,
			//     display "01′23″45"
			let (slice, tick, tickule) = timeComponents
			return String(format: "%02d′%02d″%02d", slice, tick, tickule)
		}
	}

	/// The current slice.
	var slice: Int {
		get {
			let (slice, _, _) = timeComponents
			return slice
		}
		set(newSlice) {
			// Ensure data is well-formed; this should be enforced elsewhere.
			assert(newSlice >= 0)
			
			let (_, tick, tickule) = timeComponents
			timeComponents = (newSlice, tick, tickule)
		}
	}

	/// The current tick.
	var tick: Int {
		get {
			let (_, tick, _) = timeComponents
			return tick
		}
		set(newTick) {
			// Ensure data is well-formed; this should be enforced elsewhere.
			assert(newTick >= 0)
			
			let (slice, _, tickule) = timeComponents
			timeComponents = (slice, newTick, tickule)
		}
	}

	/// The current tickule.
	var tickule: Int {
		get {
			let (_, _, tickule) = timeComponents
			return tickule
		}
		set(newTickule) {
			// Ensure data is well-formed; this should be enforced elsewhere.
			assert(newTickule >= 0)
			
			let (slice, tick, _) = timeComponents
			timeComponents = (slice, tick, newTickule)
		}
	}

	/// The current Hub time, measured in tickules from top of cycle (00′00″00).
	/// This variable is the only variable that can be set from outside the
	/// model with a value that exceeds its normal allowed bounds; this allows
	/// users to trigger overflow to a new cycle.
	var totalTickules: Int {
		get {
			currentTickule
		}
		set(tickules) {
			// Ensure data is well-formed; this should be enforced elsewhere.
			assert(tickules >= 0)
			if tickules >= Self.tickulesPerCycle {
				// When a supplied tickule count is above the maximum value per
				// cycle, truncate the excess and use it to update the cycle
				// number. This only works this way because the clock only runs
				// forward.
				currentTickule = tickules % Self.tickulesPerCycle
				cycle += tickules / Self.tickulesPerCycle
			}
			else {
				currentTickule = tickules
			}
		}
	}
}
