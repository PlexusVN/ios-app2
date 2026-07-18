import SwiftUI

extension View {
    func safeTopPadding() -> some View {
        GeometryReader { geo in
            self.padding(.top, geo.safeAreaInsets.top)
        }
    }

    func safeBottomPadding() -> some View {
        GeometryReader { geo in
            self.padding(.bottom, geo.safeAreaInsets.bottom)
        }
    }

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geo.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }

    func readSafeArea(onChange: @escaping (CGFloat, CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        onChange(geo.safeAreaInsets.top, geo.safeAreaInsets.bottom)
                    }
            }
        )
    }

    func placeholder<Content: View>(when shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
        overlay(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
        }
    }

    func shimmer(config: ShimmerConfig = ShimmerConfig()) -> some View {
        modifier(ShimmerEffect(config: config))
    }

    func toast(isPresented: Binding<Bool>, message: String, icon: String = "checkmark.circle.fill", color: Color = AppColors.success) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, icon: icon, color: color))
    }

    func alertPopup(isPresented: Binding<Bool>, title: String, message: String, buttonText: String = "OK", buttonColor: Color = AppColors.primaryRed, action: (() -> Void)? = nil) -> some View {
        modifier(AlertPopupModifier(isPresented: isPresented, title: title, message: message, buttonText: buttonText, buttonColor: buttonColor, action: action))
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { value = nextValue() }
}

struct ShimmerConfig {
    var tint: Color = AppColors.glassLight
    var highlight: Color = AppColors.glassBorder
    var blur: CGFloat = 5
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 2
}

struct ShimmerEffect: ViewModifier {
    let config: ShimmerConfig
    @State private var moveTo: CGFloat = -0.7

    func body(content: Content) -> some View {
        content
            .overlay {
                Rectangle()
                    .fill(.linearGradient(
                        colors: [config.tint, config.highlight, config.tint],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .opacity(config.highlightOpacity)
                    .blur(radius: config.blur)
                    .offset(x: moveTo)
                    .mask(content)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: config.speed).repeatForever(autoreverses: false)) {
                    moveTo = 0.7
                }
            }
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let icon: String
    let color: Color
    @State private var offsetY: CGFloat = -100

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isPresented {
                    HStack(spacing: 10) {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(color)
                        Text(message)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(AppColors.cardSecondary)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.glassBorder, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: color.opacity(0.3), radius: 20, x: 0, y: 4)
                    .offset(y: offsetY)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            offsetY = 60
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                offsetY = -100
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isPresented = false
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
    }
}

struct AlertPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let buttonText: String
    let buttonColor: Color
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ZStack {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()
                            .onTapGesture { isPresented = false }

                        VStack(spacing: 20) {
                            Text(title)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)

                            Text(message)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)

                            Button {
                                isPresented = false
                                action?()
                            } label: {
                                Text(buttonText)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(buttonColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(24)
                        .background(AppColors.card)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppColors.borderDim, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: AppColors.shadow, radius: 30)
                        .padding(.horizontal, 40)
                        .transition(.scale.combined(with: .opacity))
                    }
                    .transition(.opacity)
                    .zIndex(100)
                }
            }
    }
}
