//
//  HaebitNewLogView.swift
//  HaebitLogger
//
//  Created by Seunghun on 2/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitNewLogView: View {
    @StateObject var viewModel: HaebitNewLogViewModel
    
    var body: some View {
        NavigationView {
            List {
                DatePicker("Date", selection: $viewModel.date)
                HStack {
                    Text("ISO")
                    TextField(
                        "ISO",
                        text: .init(
                            get: { "\(viewModel.iso)" },
                            set: { viewModel.iso = UInt16($0) ?? .zero }
                        )
                    )
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                }
                HStack {
                    Text("SS: " + String(format: "%.1f", viewModel.shutterSpeed))
                    Spacer()
                    Slider(value: $viewModel.shutterSpeed, in: 1.0...8000)
                        .frame(width: 150)
                }
                HStack {
                    Text("Aperture: " + String(format: "%.1f", viewModel.aperture))
                    Spacer()
                    Slider(value: $viewModel.aperture, in: 1.0...22)
                        .frame(width: 150)
                }
                TextField("Memo", text: $viewModel.memo)
                    .multilineTextAlignment(.leading)
            }
            .navigationTitle("Add New Log")
            .toolbar {
                Button(action: viewModel.didTapAdd) {
                    Image(systemName: "plus")
                }
                Button(action: viewModel.didTapClose) {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

#Preview {
    HaebitNewLogView(viewModel: HaebitNewLogViewModel(addClosure: { _ in }, closeClosure: { }))
}
