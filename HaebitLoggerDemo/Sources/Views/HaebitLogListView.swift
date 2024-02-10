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
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.logs, id: \.id) { log in
                        NavigationLink {
                            Text(log.memo)
                        } label: {
                            Text(log.date.description)
                        }
                    }
                }
                .navigationTitle("Logs")
                .toolbar {
                    Button(action: viewModel.didTapAddButton) {
                        Image(systemName: "plus")
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.isAddingNewLog) {
                NewLogView(viewModel: viewModel)
            }
            if viewModel.isLoading {
                LoadingIndicatorView()
            }
        }
        .onAppear(perform: viewModel.onAppear)
    }
}

#Preview {
    HaebitLogListView(viewModel: HaebitLogListViewModel())
}
