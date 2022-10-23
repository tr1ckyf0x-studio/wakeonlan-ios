//
//  PostLaunchViewController.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import UIKit

public final class PostLaunchViewController: UIViewController, PostLaunchViewInput {

    // MARK: - Properties

    var postLaunchView = PostLaunchView()
    var presenter: PostLaunchViewOutput?

    // MARK: - Lifecycle

    override public func loadView() {
        view = postLaunchView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad(self)
    }
}
