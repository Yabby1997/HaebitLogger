//
//  HaebitLogListViewModel.swift
//  HaebitLoggerDemo
//
//  Created by Seunghun on 2/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitLogger

final class HaebitLogListViewModel: ObservableObject {
    private let logger = HaebitLogger(repository: DefaultHaebitLogRepository())
    
    @Published var isAddingNewLog = false
    @Published var logs: [HaebitLog] = []
    
    func onAppear() {
        Task {
            try? await reload()
        }
    }
    
    func didTapAddButton() {
        isAddingNewLog = true
    }
    
    func didSelectRemove(of index: Int) {
        Task {
            try? await logger.remove(log: logs[index].id)
            try? await reload()
        }
    }
    
    func newLogViewModel() -> HaebitNewLogViewModel {
        HaebitNewLogViewModel { [weak self] newLog in
            Task { [weak self] in
                try? await self?.logger.save(log: newLog)
                try? await self?.reload()
                Task { @MainActor [weak self] in
                    self?.isAddingNewLog = false
                }
            }
        } closeClosure: { [weak self] in
            self?.isAddingNewLog = false
        }
    }
    
    func existingLogViewModel(for log: HaebitLog) -> HaebitExistingLogViewModel {
        HaebitExistingLogViewModel(original: log) { [weak self] editedLog in
            Task { [weak self] in
                try? await self?.logger.save(log: editedLog)
                try? await self?.reload()
            }
        }
    }
    
    private func reload() async throws {
        let logs = (try? await logger.logs()) ?? []
        Task { @MainActor in
            self.logs = logs
        }
    }
}

extension HaebitCoordinate {
    static func random() -> Self {
        HaebitCoordinate(
            latitude: Double.random(in: -90.0...90.0),
            longitude: Double.random(in: -180.0...180.0)
        )
    }
}
