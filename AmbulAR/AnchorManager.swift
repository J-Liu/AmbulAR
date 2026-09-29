// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import ARKit
import simd

final class AnchorManager {

    private(set) var anchors: [(anchor: ARAnchor, type: MarkerType, view: MarkerView)] = []

    @discardableResult
    func createAnchor(at position: simd_float3, type: MarkerType, in session: ARSession) -> ARAnchor {
        let anchor = ARAnchor(transform: matrix_identity_float4x4)
        session.add(anchor: anchor)
        let view = MarkerView()
        view.markerType = type
        anchors.append((anchor, type, view))
        return anchor
    }

    func updateMarkerPositions(for frame: ARFrame, in view: UIView) {
        for (anchor, _, markerView) in anchors {
            let worldPosition = simd_float3(
                anchor.transform.columns.3.x,
                anchor.transform.columns.3.y,
                anchor.transform.columns.3.z
            )

            let projectedPoint = frame.camera.projectPoint(
                worldPosition,
                viewRotationAngle: 0,
                viewportSize: view.bounds.size
            )

            let cameraPosition = frame.camera.transform.columns.3
            let toAnchor = worldPosition - simd_float3(cameraPosition.x, cameraPosition.y, cameraPosition.z)

            let isInFront = toAnchor.z > 0
            let isInBounds = view.bounds.contains(CGPoint(x: projectedPoint.x, y: projectedPoint.y))

            if isInFront && isInBounds {
                markerView.center = CGPoint(x: projectedPoint.x, y: projectedPoint.y)
                markerView.isHidden = false
            } else {
                markerView.isHidden = true
            }
        }
    }

    func attachMarkers(to view: UIView) {
        for (_, _, markerView) in anchors {
            if markerView.superview == nil {
                view.addSubview(markerView)
            }
        }
    }

    func clearAll() {
        for (_, _, markerView) in anchors {
            markerView.removeFromSuperview()
        }
        anchors.removeAll()
    }
}