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
	static let precisionRange = 1...7 // Max can be bumped up here as long as text fits
	
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
	
	/// Get the value in 0...max nearest to the supplied integer value. This
	/// operation is applied to incoming values intended to be assigned to one
	/// of our time units. This means callers cannot do funny time calculations
	/// by setting excessively large or negative values.
	private func clamp(_ value: Int, _ max: Int) -> Int {
		return value < 0 ? 0 : (value > max ? max : value)
	}
	
	/// A tuple of Hub time components (slice, ticks, tickules).
	var timeComponents: (slice: Int, tick: Int, tickule: Int) {
		get {
			// Calculate the values of the various time components, since we
			// do not store the time in those terms.
			let (ticks, tickule) = currentTickule /% Self.tickulesPerTick
			let (slice, tick) = ticks /% Self.ticksPerSlice
			return (slice, tick, tickule)
		}
		set(components) {
			var (slice, tick, tickule) = components
			
			slice = self.clamp(slice, Self.slicesPerCycle - 1)
			tick = self.clamp(tick, Self.ticksPerSlice - 1)
			tickule = self.clamp(tickule, Self.tickulesPerTick - 1)
			
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
			timeComponents.slice
		}
		set(newSlice) {
			timeComponents = (
				clamp(newSlice, Self.slicesPerCycle - 1),
				timeComponents.tick,
				timeComponents.tickule
			)
		}
	}

	/// The current tick.
	var tick: Int {
		get {
			timeComponents.tick
		}
		set(newTick) {
			timeComponents = (
				timeComponents.slice,
				clamp(newTick, Self.ticksPerSlice - 1),
				timeComponents.tickule
			)
		}
	}

	/// The current tickule.
	var tickule: Int {
		get {
			timeComponents.tickule
		}
		set(newTickule) {
			timeComponents = (
				timeComponents.slice,
				timeComponents.tick,
				clamp(newTickule, Self.tickulesPerTick - 1)
			)
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
			if tickules < 0 {
				currentTickule = 0
			}
			else {
				// If the supplied tickule count is above the maximum value per
				// cycle, use the excess to determine how many extra cycles have
				// advanced. This only works this way because the clock only
				// runs forward.
				currentTickule = tickules % Self.tickulesPerCycle
				cycle += tickules / Self.tickulesPerCycle
			}
		}
	}
}
