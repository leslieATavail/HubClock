//
//  ContentView.swift
//  HubClock
//
//  Created by Leslie Schultz on 7/26/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
	var body: some View {
		ClockView()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(UserData())
	}
}
