import SwiftUI

struct SystemCard: View {
    let title: String
    let value: String
    var icon: String
    var color: Color = AppColors.glowRed
    var progress: Float? = nil

    @State private var animateIcon = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 38, height: 38)
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
                .scaleEffect(animateIcon ? 1.1 : 1)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)

                Text(value)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            if let progress = progress {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.card)
                        .frame(width: 60, height: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(AppColors.borderDim, lineWidth: 0.5)
                        )

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 60 * CGFloat(progress), height: 8)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(AppColors.cardSecondary)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.borderDim, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(Double.random(in: 0...0.3))) {
                animateIcon = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    animateIcon = false
                }
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var icon: String? = nil
    var valueColor: Color = .white
    var showCopy: Bool = false
    var onCopy: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 10) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.glowRed)
                    .frame(width: 28, height: 28)
                    .background(AppColors.glowRed.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 7))
            }

            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(valueColor)

            if showCopy {
                Button(action: { onCopy?() }) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.glowRed)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}
