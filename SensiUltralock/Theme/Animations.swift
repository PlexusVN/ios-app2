import SwiftUI

struct AppAnimations {
    static let press = Animation.easeOut(duration: 0.1)
    static let release = Animation.spring(response: 0.3, dampingFraction: 0.6)
    static let toggle = Animation.spring(response: 0.4, dampingFraction: 0.5)
    static let cardAppear = Animation.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)
    static let fadeIn = Animation.easeOut(duration: 0.4)
    static let slideUp = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let glowPulse = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    static let rotate = Animation.linear(duration: 3).repeatForever(autoreverses: false)
    static let particleDrift = Animation.easeInOut(duration: 4).repeatForever(autoreverses: true)
    static let shake = Animation.spring(response: 0.2, dampingFraction: 0.3)
    static let bounce = Animation.interpolatingSpring(mass: 1, stiffness: 100, damping: 10, initialVelocity: 5)
}

struct AnimationValues {
    var scale: CGFloat = 1
    var opacity: Double = 0
    var offsetY: CGFloat = 20
    var rotation: Double = 0
}
