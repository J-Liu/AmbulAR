// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import UIKit

final class MarkerView: UIView {

    private let circleView = UIView()
    private let label = UILabel()

    var markerType: MarkerType = .start {
        didSet {
            updateAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let size: CGFloat = 40

        circleView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        circleView.layer.cornerRadius = size / 2
        circleView.backgroundColor = .systemGreen
        circleView.layer.borderWidth = 3
        circleView.layer.borderColor = UIColor.white.cgColor
        addSubview(circleView)

        label.frame = CGRect(x: 0, y: size + 4, width: size, height: 20)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        addSubview(label)

        frame = CGRect(x: 0, y: 0, width: size, height: size + 24)
        updateAppearance()
    }

    private func updateAppearance() {
        circleView.backgroundColor = markerType.color
        label.text = markerType.label
    }
}

extension MarkerType {
    var label: String {
        switch self {
        case .start: return NSLocalizedString("Start Point", comment: "")
        case .pause: return NSLocalizedString("Pause Point", comment: "")
        case .resume: return NSLocalizedString("Resume Point", comment: "")
        case .finish: return NSLocalizedString("Finish Point", comment: "")
        }
    }
}