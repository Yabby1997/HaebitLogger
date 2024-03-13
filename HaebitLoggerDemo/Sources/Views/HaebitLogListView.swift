//
//  HaebitLogListView.swift
//  HaebitLoggerDemo
//
//  Created by Seunghun on 2/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitLogListView: View {
    @StateObject var viewModel: HaebitLogListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.logs, id: \.id) { log in
                    NavigationLink {
                        HaebitExistingLogView(viewModel: viewModel.existingLogViewModel(for: log))
                    } label: {
                        Text(log.date.description)
                    }
                }
                .onDelete { indexSet in
                    guard let index = indexSet.first else { return }
                    viewModel.didSelectRemove(of: index)
                }
            }
            .navigationTitle("Logs")
            .toolbar {
                Button(action: viewModel.didTapAddButton) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            for i in 0...100 {
                viewModel.onAppear()
                print(#function, i)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isAddingNewLog) {
            HaebitNewLogView(viewModel: viewModel.newLogViewModel())
        }
    }
}

#Preview {
    HaebitLogListView(viewModel: HaebitLogListViewModel())
}
