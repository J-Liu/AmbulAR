// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import simd
import ARKit

final class SessionController {

    var state: TrackingState = .idle
    var totalDistance: Float { sensorFusion.fusedDistance }

    private let distanceTracker = DistanceTracker()
    private let sensorFusion = SensorFusion()
    private var pausedPosition: simd_float3?

    func startTracking() {
        sensorFusion.start()
    }

    func stopTracking() {
        sensorFusion.stop()
    }

    func handleAction() {
        switch state {
        case .idle:
            state = .tracking
            distanceTracker.reset()
            sensorFusion.reset()
            sensorFusion.start()
        case .tracking:
            state = .paused
        case .paused:
            state = .tracking
        case .finished:
            state = .idle
            distanceTracker.reset()
            sensorFusion.reset()
        }
    }

    func finish() {
        state = .finished
        sensorFusion.stop()
    }

    func update(with position: simd_float3, trackingState: ARCamera.TrackingState) {
        guard state == .tracking else { return }

        if pausedPosition != nil {
            distanceTracker.reset()
            distanceTracker.update(with: position)
            pausedPosition = nil
        } else {
            distanceTracker.update(with: position)
        }

        sensorFusion.updateARKitDistance(distanceTracker.currentDistance, trackingState: trackingState)
    }

    func setPausedPosition(_ position: simd_float3) {
        pausedPosition = position
    }
}