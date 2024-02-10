//
//  HaebitLoggerDemoApp.swift
//  HaebitLogger
//
//  Created by Seunghun on 1/31/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import HaebitLogger
import SwiftUI

@main
struct HaebitLoggerDemoApp: App {
    var body: some Scene {
        WindowGroup {
            HaebitLogListView(viewModel: HaebitLogListViewModel())
        }
    }
}
