//
//  LoadingIndicatorView.swift
//  HaebitLogger
//
//  Created by Seunghun on 2/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct LoadingIndicatorView: View {
    var body: some View {
        ZStack {
            Color(.black.withAlphaComponent(0.3))
            ProgressView()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingIndicatorView()
}
