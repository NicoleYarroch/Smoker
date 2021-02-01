//
//  UINavigationController+Appearance.swift
//  Smoker
//
//  Created by Nicole on 1/4/21.
//

import SwiftUI

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        let defaultBackgroundColor = UIColor.systemBackground
        let defaultTextColor = UIColor.label
        let titleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: defaultTextColor]
        let largeTitleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: defaultTextColor]

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = defaultBackgroundColor
        standardAppearance.titleTextAttributes = titleTextAttributes
        standardAppearance.largeTitleTextAttributes = largeTitleTextAttributes

        // Landscape
        let compactAppearance = UINavigationBarAppearance()
        compactAppearance.backgroundColor = defaultBackgroundColor
        compactAppearance.titleTextAttributes = titleTextAttributes

        // Navigation bar with a display mode of "large"
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = defaultBackgroundColor
        scrollEdgeAppearance.largeTitleTextAttributes = largeTitleTextAttributes

        navigationBar.standardAppearance = standardAppearance
        navigationBar.compactAppearance = compactAppearance
        navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        navigationBar.barTintColor = UIColor.systemPurple
    }
}
