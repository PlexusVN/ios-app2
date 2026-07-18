import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            AppColors.background

            RadialGradient(
                colors: [
                    AppColors.primaryRed.opacity(0.08),
                    AppColors.primaryRed.opacity(0.03),
                    .clear
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 400
            )
            .blur(radius: 60)
            .offset(x: animate ? -30 : 30, y: animate ? -20 : 20)

            RadialGradient(
                colors: [
                    AppColors.secondaryRed.opacity(0.06),
                    .clear
                ],
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 500
            )
            .blur(radius: 80)
            .offset(x: animate ? 40 : -40, y: animate ? 30 : -30)

            RadialGradient(
                colors: [
                    AppColors.glowRed.opacity(0.04),
                    .clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 300
            )
            .blur(radius: 50)
            .offset(x: animate ? -20 : 20, y: animate ? 10 : -10)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)
            ) {
                animate = true
            }
        }
    }
}

struct ParticlesView: View {
    @State private var particles: [Particle] = []
    let count: Int

    init(count: Int = 25) {
        self.count = count
    }

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(AppColors.glowRed.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .blur(radius: particle.blur)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animateParticles()
        }
    }

    private func setupParticlesArray() -> [Particle] {
        (0..<count).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                opacity: Double.random(in: 0.05...0.2),
                size: CGFloat.random(in: 2...5),
                blur: CGFloat.random(in: 0...3),
                speed: CGFloat.random(in: 0.5...2)
            )
        }
    }

    private func animateParticles() {
        particles = setupParticlesArray()

        for index in particles.indices {
            let originalY = particles[index].position.y
            let drift = CGFloat.random(in: 20...80)
            let duration = Double.random(in: 3...6)

            withAnimation(
                Animation.easeInOut(duration: duration).repeatForever(autoreverses: true)
            ) {
                particles[index].position.y = originalY - drift
                particles[index].opacity = Double.random(in: 0.02...0.15)
            }
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var opacity: Double
    var size: CGFloat
    var blur: CGFloat
    var speed: CGFloat
}

struct LoadingView: View {
    var message: String = "Loading..."
    var color: Color = AppColors.glowRed

    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(color.opacity(0.2), lineWidth: 3)
                        .frame(width: 40 + CGFloat(i * 12), height: 40 + CGFloat(i * 12))
                }

                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(color, lineWidth: 3)
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(rotation))
                    .shadow(color: color.opacity(0.5), radius: 8)
            }

            Text(message)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}
