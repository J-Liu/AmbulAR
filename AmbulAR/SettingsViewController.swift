// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright © 2026 Jia Liu

import UIKit

final class SettingsViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let languages = AppLanguage.allCases
    private let units = DistanceUnit.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        title = NSLocalizedString("Settings", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = false

        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        let okButton = UIButton(type: .system)
        okButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        okButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        okButton.backgroundColor = .systemBlue
        okButton.setTitleColor(.white, for: .normal)
        okButton.layer.cornerRadius = 12
        okButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(okButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            okButton.widthAnchor.constraint(equalToConstant: 150),
            okButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func dismissTapped() {
        dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? NSLocalizedString("Language", comment: "") : NSLocalizedString("Display Unit", comment: "")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? languages.count : units.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")

        if indexPath.section == 0 {
            let language = languages[indexPath.row]
            cell.textLabel?.text = language.displayName
            cell.accessoryType = LanguageManager.shared.currentLanguage == language ? .checkmark : .none
        } else {
            let unit = units[indexPath.row]
            cell.textLabel?.text = unit.localizedName
            cell.accessoryType = UserDefaults.standard.string(forKey: "SelectedUnit") == unit.rawValue ? .checkmark : .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            let selectedLanguage = languages[indexPath.row]
            LanguageManager.shared.currentLanguage = selectedLanguage
        } else {
            let selectedUnit = units[indexPath.row]
            UserDefaults.standard.set(selectedUnit.rawValue, forKey: "SelectedUnit")
            NotificationCenter.default.post(name: .unitChanged, object: nil)
        }

        tableView.reloadData()
    }
}

extension Notification.Name {
    static let unitChanged = Notification.Name("UnitChangedNotification")
}