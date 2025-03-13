import UIKit

final class ShimmerView: UIView {
    // MARK: - Fields
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    private let baseColor: UIColor = .systemGray6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradient()
        backgroundColor = baseColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func configureGradient() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        layer.addSublayer(gradientLayer)
        
        let colors = [
            UIColor.systemGray5.cgColor,
            UIColor.white.withAlphaComponent(1).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor,
            UIColor.systemGray5.cgColor
        ]
        
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 0.3, 0.4, 1.0]
        
    }
    
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.4, -0.3, 0.0]
        animation.toValue = [1.0, 1.3, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.2
        gradientLayer.add(animation, forKey: "shimmer")
    }
    
    func stopAnimating() {
        gradientLayer.removeAllAnimations()
    }
}
