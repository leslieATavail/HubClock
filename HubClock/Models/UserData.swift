//
//  UserData.swift
//  HubClock
//
//  Created by Leslie Schultz on 7/26/20.
//  Copyright © 2020 Leslie Schultz. All rights reserved.
//

import SwiftUI

final class UserData: ObservableObject {
	@Published var hubTime: HubTime = HubTime()
}
