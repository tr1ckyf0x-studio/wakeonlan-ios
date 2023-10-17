//
//  SpinnerView.swift
//  
//
//  Created by Vladislav Lisianskii on 28.04.2023.
//

import SnapKit
import UIKit
import WOLResources

public final class SpinnerView: UIView {

    private(set) var isAnimating = false

    private lazy var outerCircle: SoftUIView = { view in
        view.isSelected = true
        view.type = .normal
        return view
    }(SoftUIView(circleShape: true))

    private lazy var innerCircle: SoftUIView = { view in
        view.type = .normal
        return view
    }(SoftUIView(circleShape: true))

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = Asset.Colors.secondary.color.resolved
        layer.fillColor = nil
        layer.lineWidth = Constants.progressStrokeWidth
        layer.lineCap = .round
        return layer
    }()

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
        startAnimating()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.frame = bounds
        updatePath()
    }

    public func startAnimating() {
        isAnimating = true
        setupAnimations()
    }

    public func stopAnimating() {
        guard isAnimating else { return }

        progressLayer.removeAnimation(forKey: Constants.ringStrokeAnimationKey)
        progressLayer.removeAnimation(forKey: Constants.ringRotationAnimationKey)

        isAnimating = false
    }
}

// MARK: - Private
extension SpinnerView {
    private func setupView() {
        addSubview(outerCircle)
        addSubview(innerCircle)

        layer.addSublayer(progressLayer)

        outerCircle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(Constants.outerCircleWidth)
        }

        innerCircle.snp.makeConstraints { make in
            make.center.equalTo(outerCircle)
            make.size.equalTo(Constants.innerCircleWidth)
        }
    }

    private func setupAnimations() {
        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = Constants.animationDuration / 0.375
        animation.fromValue = 0.0
        animation.toValue = 2.0 * Double.pi
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: Constants.ringRotationAnimationKey)

        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.duration = Constants.animationDuration / 1.5
        headAnimation.fromValue = 0.0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = timingFunction

        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.duration = Constants.animationDuration / 1.5
        tailAnimation.fromValue = 0.0
        tailAnimation.toValue = 1.0
        tailAnimation.timingFunction = timingFunction

        let endHeadAnimation = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnimation.duration = Constants.animationDuration / 3.0
        endHeadAnimation.beginTime = Constants.animationDuration / 1.5
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = timingFunction

        let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnimation.duration = Constants.animationDuration / 3.0
        endTailAnimation.beginTime = Constants.animationDuration / 1.5
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = timingFunction

        let animations = CAAnimationGroup()
        animations.duration = Constants.animationDuration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = .infinity
        animations.isRemovedOnCompletion = false
        progressLayer.add(animations, forKey: Constants.ringStrokeAnimationKey)
    }

    private func updatePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath(
            arcCenter: center,
            radius: Constants.strokeRadius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0.5
    }
}

// MARK: - Constants
extension SpinnerView {
    private enum Constants {
        static let outerCircleWidth: CGFloat = 60
        static let innerCircleWidth: CGFloat = 30
        static let circlesSpacing: CGFloat = (outerCircleWidth - innerCircleWidth) / 2
        static let progressStrokeWidth: CGFloat = circlesSpacing / 2
        static let strokeRadius = (outerCircleWidth - circlesSpacing) / 2

        static let animationDuration: TimeInterval = 1.5

        static let ringRotationAnimationKey = "ringRotationAnimationKey"
        static let ringStrokeAnimationKey = "ringStrokeAnimationKey"
    }
}
