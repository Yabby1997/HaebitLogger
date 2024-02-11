//
//  HaebitExistingLogViewModel.swift
//  HaebitLoggerDemo
//
//  Created by Seunghun on 2/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitLogger

final class HaebitExistingLogViewModel: ObservableObject {
    @Published var isEditingMode = false
    @Published var date: Date
    @Published var focalLength: UInt16
    @Published var iso: UInt16
    @Published var shutterSpeed: Float
    @Published var aperture: Float
    @Published var memo: String
    let original: HaebitLog
    let dismissClosure: (HaebitLog) -> Void
    
    init(original: HaebitLog, dismissClosure: @escaping (HaebitLog) -> Void) {
        self.original = original
        self.date = original.date
        self.focalLength = original.focalLength
        self.iso = original.iso
        self.shutterSpeed = original.shutterSpeed
        self.aperture = original.aperture
        self.memo = original.memo
        self.dismissClosure = dismissClosure
    }
    
    func didTapEditButton() {
        isEditingMode.toggle()
    }
    
    func onDismiss() {
        dismissClosure(
            HaebitLog(
                id: original.id,
                date: date,
                coordinate: original.coordinate,
                image: original.image,
                focalLength: focalLength,
                iso: iso,
                shutterSpeed: shutterSpeed,
                aperture: aperture,
                memo: memo
            )
        )
    }
}
