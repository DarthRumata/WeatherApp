//
//  UIViewController+Embed.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import UIKit

public extension UIViewController {
    /// Adds a child view controller to the specified content view.
    /// - Parameters:
    ///   - viewController: The child view controller to add.
    ///   - contentView: The content view to which the child view controller will be added. If not provided, the `view` of the current view controller will be used.
    func add(
        childViewController viewController: UIViewController,
        to contentView: UIView? = nil
    ) {
        let contentView: UIView = contentView ?? view
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewController.view.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor
            ),
            viewController.view.bottomAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.bottomAnchor
            )
        ])
        viewController.didMove(toParent: self)
    }
}
