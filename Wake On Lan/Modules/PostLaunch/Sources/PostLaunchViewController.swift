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

    public override func loadView() {
        view = postLaunchView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad(self)
    }
}
