//
//  HaebitNewLogViewModel.swift
//  HaebitLoggerDemo
//
//  Created by Seunghun on 2/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitLogger

final class HaebitNewLogViewModel: ObservableObject {
    @Published var date = Date()
    @Published var focalLength: UInt16 = .zero
    @Published var iso: UInt16 = .zero
    @Published var shutterSpeed: Float = .zero
    @Published var aperture: Float = .zero
    @Published var memo: String = ""
    let addClosure: (HaebitLog) -> Void
    let closeClosure: () -> Void
    
    init(
        addClosure: @escaping (HaebitLog) -> Void,
        closeClosure: @escaping () -> Void
    ) {
        self.addClosure = addClosure
        self.closeClosure = closeClosure
    }
    
    func didTapAdd() {
        addClosure(
            HaebitLog(
                date: date,
                coordinate: .random(),
                image: HaebitImage(photo: URL(string: "https://demo.com")!, video: nil),
                focalLength: focalLength,
                iso: iso,
                shutterSpeed: shutterSpeed,
                aperture: aperture,
                memo: memo
            )
        )
    }
    
    func didTapClose() {
        closeClosure()
    }
}
