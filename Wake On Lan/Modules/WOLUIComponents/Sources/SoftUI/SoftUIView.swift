//
//  SoftUIView.swift
//

import SharedExtensions
import UIKit
import WOLResources

public protocol ConfigurableSoftUIView: UIControl {
    func configure(with model: DescribesSoftUIViewModel)
}

public class SoftUIView: UIControl {

    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        var mainColor: CGColor { WOLResources.Asset.Colors.soft.color.resolved }
        var darkShadowColor: CGColor { WOLResources.Asset.Colors.darkSoftShadow.color.resolved }
        var lightShadowColor: CGColor { WOLResources.Asset.Colors.lightSoftShadow.color.resolved }

        var darkShadowOpacity: Float {
            guard #available(iOS 13.0, *) else { return 1 }
            return UITraitCollection.current.userInterfaceStyle == .dark ? 0.6 : 1
        }

        var lightShadowOpacity: Float {
            guard #available(iOS 13.0, *) else { return 1 }
            return UITraitCollection.current.userInterfaceStyle == .dark ? 0.2 : 1
        }

        let shadowOffset = CGSize(width: 2, height: 2)
        let shadowRadius = CGFloat(2)
        let cornerRadius = CGFloat(15)
    }

    // MARK: - Properties

    open var type: SoftUIViewType = .pushButton {
        didSet { updateShadowLayers() }
    }

    lazy var mainColor = appearance.mainColor {
        didSet {
            backgroundLayer.backgroundColor = mainColor
            darkOuterShadowLayer.fillColor = mainColor
            lightOuterShadowLayer.fillColor = mainColor
            darkInnerShadowLayer.fillColor = mainColor
            lightInnerShadowLayer.fillColor = mainColor
        }
    }

    lazy var darkShadowColor = appearance.darkShadowColor {
        didSet {
            darkOuterShadowLayer.shadowColor = darkShadowColor
            darkInnerShadowLayer.shadowColor = darkShadowColor
        }
    }

    lazy var lightShadowColor = appearance.lightShadowColor {
        didSet {
            lightOuterShadowLayer.shadowColor = lightShadowColor
            lightInnerShadowLayer.shadowColor = lightShadowColor
        }
    }

    lazy var lightShadowOpacity: Float = appearance.lightShadowOpacity {
        didSet { updateShadowOpacity() }
    }

    lazy var darkShadowOpacity: Float = appearance.darkShadowOpacity {
        didSet { updateShadowOpacity() }
    }

    lazy var shadowOffset = appearance.shadowOffset {
        didSet {
            darkOuterShadowLayer.shadowOffset = shadowOffset
            lightOuterShadowLayer.shadowOffset = shadowOffset.inverse
            darkInnerShadowLayer.shadowOffset = shadowOffset
            lightInnerShadowLayer.shadowOffset = shadowOffset.inverse
        }
    }

    lazy var cornerRadius: CGFloat = appearance.cornerRadius {
        didSet { updateSublayersShape() }
    }

    lazy var shadowRadius = appearance.shadowRadius {
        didSet {
            darkOuterShadowLayer.shadowRadius = shadowRadius
            lightOuterShadowLayer.shadowRadius = shadowRadius
            darkInnerShadowLayer.shadowRadius = shadowRadius
            lightInnerShadowLayer.shadowRadius = shadowRadius
        }
    }

    private var circleShape = false

    // MARK: - Layers

    private lazy var backgroundLayer: CALayer = {
        let layer = CALayer()
        layer.frame = bounds
        layer.cornerRadius = cornerRadius
        layer.backgroundColor = mainColor

        return layer
    }()

    private lazy var darkOuterShadowLayer: CAShapeLayer = {
        makeOuterShadowLayer(shadowColor: darkShadowColor, shadowOffset: shadowOffset)
    }()

    private lazy var lightOuterShadowLayer: CAShapeLayer = {
        makeOuterShadowLayer(shadowColor: lightShadowColor, shadowOffset: shadowOffset.inverse)
    }()

    private lazy var darkInnerShadowLayer: CAShapeLayer = {
        let layer = makeInnerShadowLayer(shadowColor: darkShadowColor, shadowOffset: shadowOffset)
        layer.isHidden = true
        return layer
    }()

    private lazy var lightInnerShadowLayer: CAShapeLayer = {
        let layer = makeInnerShadowLayer(shadowColor: lightShadowColor, shadowOffset: shadowOffset.inverse)
        layer.isHidden = true
        return layer
    }()

    private var contentView: UIView?
    private var selectedContentView: UIView?
    private var selectedTransform: CGAffineTransform?

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSublayers()
        updateSublayersShape()
        updateShadowOpacity()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init(circleShape: Bool) {
        self.init(frame: .zero)
        self.circleShape = circleShape
    }

    // MARK: - Override

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if
            #available(iOS 13, *),
            traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
        }
    }

    override public var bounds: CGRect {
        didSet { updateSublayersShape() }
    }

    override public var isSelected: Bool {
        didSet {
            updateShadowLayers()
            updateContentView()
        }
    }

    override public var backgroundColor: UIColor? {
        get { .clear }
        set { super.backgroundColor = newValue }
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .pushButton:
            isSelected = true

        case .toggleButton:
            isSelected.toggle()

        case .normal:
            break
        }
        super.touchesBegan(touches, with: event)
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if case .pushButton = type { isSelected = isTracking }
        super.touchesMoved(touches, with: event)
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if case .pushButton = type { isSelected = false }
        super.touchesEnded(touches, with: event)
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if case .pushButton = type { isSelected = false }
        super.touchesCancelled(touches, with: event)
    }

    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if circleShape { cornerRadius = bounds.height / 2 }
    }

}

// MARK: - ConfigurableSoftUIView

extension SoftUIView: ConfigurableSoftUIView {

    public func configure(with model: DescribesSoftUIViewModel) {
        contentView.map { $0.transform = model.selectedTransform ?? .identity }
        [contentView, selectedContentView].compactMap { $0 }.forEach {
            $0.removeFromSuperview()
        }

        [model.contentView, model.selectedContentView].compactMap { $0 }.forEach {
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }

        contentView = model.contentView
        selectedContentView = model.selectedContentView
        selectedTransform = model.selectedTransform

        updateContentView()
    }

}

// MARK: - Private

private extension SoftUIView {

    func addSublayers() {
        layer.addSublayer(lightOuterShadowLayer)
        layer.addSublayer(darkOuterShadowLayer)
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(darkInnerShadowLayer)
        layer.addSublayer(lightInnerShadowLayer)
    }

    func makeOuterShadowLayer(shadowColor: CGColor, shadowOffset: CGSize) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = mainColor
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.backgroundColor = UIColor.clear.cgColor

        return layer
    }

    func makeInnerShadowLayer(shadowColor: CGColor, shadowOffset: CGSize) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = mainColor
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillRule = .evenOdd

        return layer
    }

    func makeOuterShadowPath() -> CGPath {
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }

    func makeInnerShadowPath() -> CGPath {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: -100, dy: -100), cornerRadius: cornerRadius)
        path.append(.init(roundedRect: bounds, cornerRadius: cornerRadius))
        return path.cgPath
    }

    func makeInnerShadowMask() -> CALayer {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        return layer
    }

    func updateSublayersShape() {
        backgroundLayer.frame = bounds
        backgroundLayer.cornerRadius = cornerRadius

        darkOuterShadowLayer.path = makeOuterShadowPath()
        lightOuterShadowLayer.path = makeOuterShadowPath()

        darkInnerShadowLayer.path = makeInnerShadowPath()
        darkInnerShadowLayer.mask = makeInnerShadowMask()

        lightInnerShadowLayer.path = makeInnerShadowPath()
        lightInnerShadowLayer.mask = makeInnerShadowMask()
    }

    func updateAppearance() {
        mainColor = appearance.mainColor

        shadowOffset = appearance.shadowOffset
        shadowRadius = appearance.shadowRadius
        cornerRadius = appearance.cornerRadius

        darkShadowColor = appearance.darkShadowColor
        lightShadowColor = appearance.lightShadowColor
        darkShadowOpacity = appearance.darkShadowOpacity
        lightShadowOpacity = appearance.lightShadowOpacity
    }

    func updateContentView() {
        if isSelected, selectedContentView != nil {
            contentView?.isHidden = true
            contentView?.transform = .identity
            selectedContentView?.isHidden = false
        } else if isSelected, selectedTransform != nil {
            contentView?.isHidden = false
            selectedTransform.map { contentView?.transform = $0 }
            selectedContentView?.isHidden = true
        } else {
            contentView?.isHidden = false
            contentView?.transform = .identity
            selectedContentView?.isHidden = true
        }
    }

    func updateShadowOpacity() {
        [darkOuterShadowLayer, darkInnerShadowLayer].forEach { $0.shadowOpacity = darkShadowOpacity }
        [lightOuterShadowLayer, lightInnerShadowLayer].forEach { $0.shadowOpacity = lightShadowOpacity }
    }

    func updateShadowLayers() {
        [darkOuterShadowLayer, lightOuterShadowLayer].forEach { $0.isHidden = isSelected }
        [darkInnerShadowLayer, lightInnerShadowLayer].forEach { $0.isHidden = !isSelected }
    }

}
