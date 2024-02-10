//
//  HaebitLogListViewModel.swift
//  HaebitLoggerDemo
//
//  Created by Seunghun on 2/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitLogger

protocol NewLogViewModel: AnyObject, ObservableObject {
    var newDate: Date { get set }
    var newIso: UInt16 { get set }
    var newShutterSpeed: Float { get set }
    var newAperture: Float { get set }
    var newMemo: String { get set }
    
    func didTapClose()
    func didTapAdd()
}

final class HaebitLogListViewModel: ObservableObject, NewLogViewModel {
    private let logger = HaebitLogger(repository: DefaultHaebitLogRepository())
    
    @Published var isLoading = false
    @Published var isAddingNewLog = false
    @Published var logs: [HaebitLog] = []
    
    @Published var newDate = Date()
    @Published var newIso: UInt16 = .zero
    @Published var newShutterSpeed: Float = .zero
    @Published var newAperture: Float = .zero
    @Published var newMemo: String = ""
    
    func onAppear() {
        Task {
            try? await reload()
        }
    }
    
    func didTapAddButton() {
        isAddingNewLog = true
    }
    
    func didTapClose() {
        isAddingNewLog = false
    }
    
    func didTapAdd() {
        Task {
            try? await logger.save(
                log: HaebitLog(
                    date: newDate,
                    coordinate: .random(),
                    image: HaebitImage(photo: URL(string: "https://demo.com")!, video: nil),
                    iso: newIso,
                    shutterSpeed: newShutterSpeed,
                    aperture: newAperture,
                    memo: newMemo
                )
            )
            try? await reload()
            Task { @MainActor in
                isAddingNewLog = false
            }
        }
    }
    
    private func reload() async throws {
        Task { @MainActor in
            isLoading = true
        }
        do {
            let logs = try await logger.logs()
            Task { @MainActor in
                self.logs = logs
                self.isLoading = false
            }
        } catch {
            Task { @MainActor in
                self.isLoading = false
            }
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
