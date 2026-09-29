// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import simd

final class SessionController {

    var state: TrackingState = .idle
    var totalDistance: Float { distanceTracker.currentDistance }

    private let distanceTracker = DistanceTracker()
    private var pausedPosition: simd_float3?

    func handleAction() {
        switch state {
        case .idle:
            state = .tracking
            distanceTracker.reset()
        case .tracking:
            state = .paused
        case .paused:
            state = .tracking
        case .finished:
            state = .idle
            distanceTracker.reset()
        }
    }

    func finish() {
        state = .finished
    }

    func update(with position: simd_float3) {
        guard state == .tracking else { return }

        if pausedPosition != nil {
            distanceTracker.reset()
            distanceTracker.update(with: position)
            pausedPosition = nil
        } else {
            distanceTracker.update(with: position)
        }
    }

    func setPausedPosition(_ position: simd_float3) {
        pausedPosition = position
    }
}