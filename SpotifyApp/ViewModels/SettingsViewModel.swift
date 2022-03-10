//
//  SettingsViewModel.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation

final class SettingsViewModel {
    private(set) var sections = [Section]()
    weak var delegate: SettingsViewModelDelegate?
    
    init() {
        configureSections()
    }
    
    private func configureSections() {
        sections.append(Section(
            title: "Profile",
            options: [
                Option(title: "View Your Profile", handler: { [weak self] in
                    self?.delegate?.openUserProfile()
                })
            ]))
        sections.append(Section(
            title: "Account",
            options: [
                Option(title: "Sign Out", handler: { [weak self] in
                    
                    self?.delegate?.signOut()
                })
            ]))
    }
}
