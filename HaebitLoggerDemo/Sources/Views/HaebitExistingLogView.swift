//
//  HaebitExistingLogView.swift
//  HaebitLoggerDemo
//
//  Created by Seunghun on 2/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitLogger

struct HaebitExistingLogView: View {
    @StateObject var viewModel: HaebitExistingLogViewModel
    
    var body: some View {
        List {
            DatePicker("Date", selection: $viewModel.date)
            HStack {
                Text("FocalLength")
                TextField(
                    "FocalLength",
                    text: .init(
                        get: { "\(viewModel.focalLength)" },
                        set: { viewModel.focalLength = UInt16($0) ?? .zero }
                    )
                )
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
            }
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
        .disabled(!viewModel.isEditingMode)
        .onDisappear(perform: viewModel.onDismiss)
        .navigationTitle("Existing Log")
        .toolbar {
            Button(action: viewModel.didTapEditButton) {
                Image(systemName: viewModel.isEditingMode ? "pencil.line" : "pencil")
            }
        }
    }
}

#Preview {
    HaebitExistingLogView(
        viewModel: HaebitExistingLogViewModel(
            original: HaebitLog(
                id: UUID(),
                date: Date(),
                coordinate: .random(),
                image: HaebitLivePhoto(imagePath: "Test/TestImage.jpeg", videoPath: nil),
                focalLength: .zero,
                iso: .zero,
                shutterSpeed: .zero,
                aperture: .zero,
                memo: ""
            ),
            dismissClosure: { _ in }
        )
    )
}
