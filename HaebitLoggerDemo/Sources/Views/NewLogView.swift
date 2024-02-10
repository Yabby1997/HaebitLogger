//
//  NewLogView.swift
//  HaebitLogger
//
//  Created by Seunghun on 2/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct NewLogView<ViewModel>: View where ViewModel: NewLogViewModel {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                DatePicker("Date", selection: $viewModel.newDate)
                HStack {
                    Text("ISO")
                    TextField(
                        "ISO",
                        text: .init(
                            get: { "\(viewModel.newIso)" },
                            set: { viewModel.newIso = UInt16($0) ?? .zero }
                        )
                    )
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                }
                HStack {
                    Text("SS")
                    TextField(
                        "SS",
                        text: .init(
                            get: { String(format: "%.2f", viewModel.newShutterSpeed) },
                            set: { viewModel.newShutterSpeed = Float($0) ?? .zero }
                        )
                    )
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numbersAndPunctuation)
                }
                HStack {
                    Text("Aperture")
                    TextField(
                        "Aperture",
                        text: .init(
                            get: { String(format: "%.2f", viewModel.newShutterSpeed) },
                            set: { viewModel.newShutterSpeed = Float($0) ?? .zero }
                        )
                    )
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numbersAndPunctuation)
                }
                TextField("Memo", text: $viewModel.newMemo)
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
    NewLogView(viewModel: HaebitLogListViewModel())
}
