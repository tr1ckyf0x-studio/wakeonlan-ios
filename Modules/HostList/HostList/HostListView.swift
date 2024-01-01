//
//  HostListView.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 24.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import UIKit
import WOLResources
import WOLUIComponents

protocol HostListViewDelegate: AnyObject {
    func hostListViewDidPressAddButton(_ view: DisplaysHostList)
    func hostListViewDidPressAboutButton(_ view: DisplaysHostList)
    func hostListView(_ view: DisplaysHostList, didTapDeleteAt indexPath: IndexPath)
    func hostListView(_ view: DisplaysHostList, didTapInfoAt indexPath: IndexPath)
    func hostListView(_ view: DisplaysHostList, didTapCellAt indexPath: IndexPath)
    func hostListView(
        _ view: DisplaysHostList,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    )
}

protocol DisplaysHostList {
    func updateContentSnapshot(_ contentSnapshot: HostListSnapshot)
}

final class HostListView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let barButtonDimensions = 32.0
        static let barButtonSpacing: CGFloat = 16.0
    }

    // MARK: - Properties

    weak var delegate: HostListViewDelegate?

    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = HostListCollectionViewCell.Constants.verticalInset
        layout.sectionInset = UIEdgeInsets(
            top: HostListCollectionViewCell.Constants.verticalInset,
            left: HostListCollectionViewCell.Constants.horizontalInset,
            bottom: HostListCollectionViewCell.Constants.verticalInset,
            right: HostListCollectionViewCell.Constants.horizontalInset
        )
        layout.minimumLineSpacing = HostListCollectionViewCell.Constants.verticalInset
        layout.scrollDirection = .vertical
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionLayout
        )
        collectionView.backgroundColor = Asset.Colors.primary.color
        collectionView.dragInteractionEnabled = true

        return collectionView
    }()

    private lazy var collectionManager: ManagesHostListCollection = {
        let collectionManager = HostListCollectionManager(
            collectionView: collectionView,
            cellProvider: HostListCollectionCellProvider(hostCellDelegate: self)
        )
        collectionManager.delegate = self
        collectionView.delegate = collectionManager
        return collectionManager
    }()

    lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        let viewModel = StateableViewModel(
            title: L10n.HostList.Screen.emptyViewMessage,
            image: Asset.Assets.owl.image,
            backgroundColor: Asset.Colors.primary.color
        )
        emptyView.configure(with: viewModel)

        return emptyView
    }()

    lazy var aboutButton: UIBarButtonItem = {
        let aboutButton: SoftUIView = {
            let button = SoftUIView(circleShape: true)
            let image = UIImage(sfSymbol: ButtonIcon.questionmark, withConfiguration: .init(weight: .semibold))
            let imageView = UIImageView(image: image)
            imageView.tintColor = Asset.Colors.secondary.color
            button.configure(with: SoftUIViewModel(contentView: imageView))
            button.addTarget(self, action: #selector(didTapAboutButton(_:)), for: .touchUpInside)
            imageView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }

            return button
        }()

        let barButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: aboutButton)
            button.customView?.snp.makeConstraints {
                $0.size.equalTo(Constants.barButtonDimensions)
            }

            return button
        }()

        return barButton
    }()

    lazy var barButtonSpacer: UIBarButtonItem = {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = Constants.barButtonSpacing
        return spacer
    }()

    lazy var addItemButton: UIBarButtonItem = {
        let addButton: SoftUIView = {
            let button = SoftUIView(circleShape: true)
            let image = UIImage(sfSymbol: ButtonIcon.plus, withConfiguration: .init(weight: .semibold))
            let imageView = UIImageView(image: image)
            imageView.tintColor = WOLResources.Asset.Colors.secondary.color
            button.configure(with: SoftUIViewModel(contentView: imageView))
            button.addTarget(self, action: #selector(didTapAddButton(_:)), for: .touchUpInside)
            imageView.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(6)
            }

            return button
        }()

        let barButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: addButton)
            button.customView?.snp.makeConstraints {
                $0.size.equalTo(Constants.barButtonDimensions)
            }

            return button
        }()

        return barButton
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        makeAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionLayout()
    }
}

// MARK: - Private

private extension HostListView {

    func addSubviews() {
        addSubview(collectionView)
    }

    func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    func makeAppearance() {
        backgroundColor = Asset.Colors.primary.color
    }

    @objc func didTapAddButton(_ sender: UIButton) {
        delegate?.hostListViewDidPressAddButton(self)
    }

    @objc func didTapAboutButton(_ sender: UIButton) {
        delegate?.hostListViewDidPressAboutButton(self)
    }

    func updateCollectionLayout() {
        collectionLayout.itemSize = CGSize(
            width: collectionView.bounds.width - HostListCollectionViewCell.Constants.horizontalInset * 2,
            height: HostListCollectionViewCell.Constants.cellHeight
        )
    }
}

// MARK: - ContentStateView

extension HostListView: StateableView {

    func view(for state: ViewState) -> DisplaysStateView? {
        switch state {
        case .default, .error, .waiting:
            return nil

        case .empty:
            return emptyView
        }
    }
}

// MARK: - DisplaysHostList

extension HostListView: DisplaysHostList {
    func updateContentSnapshot(_ contentSnapshot: HostListSnapshot) {
        collectionManager.apply(contentSnapshot)
    }
}

// MARK: - HostListTableViewCellDelegate

extension HostListView: HostListCollectionViewCellDelegate {
    func hostListCellDidTap(_ cell: HostListCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        delegate?.hostListView(self, didTapCellAt: indexPath)
    }

    func hostListCellDidTapDelete(_ cell: HostListCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        delegate?.hostListView(self, didTapDeleteAt: indexPath)
    }

    func hostListCellDidTapInfo(_ cell: HostListCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        delegate?.hostListView(self, didTapInfoAt: indexPath)
    }
}

// MARK: - HostListCollectionManagerDelegate

extension HostListView: HostListCollectionManagerDelegate {
    func hostListCollectionManager(
        _ hostListCollectionManager: ManagesHostListCollection,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        delegate?.hostListView(
            self,
            moveRowAt: sourceIndexPath,
            to: destinationIndexPath
        )
    }
}
