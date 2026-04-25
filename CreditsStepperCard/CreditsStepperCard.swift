import SwiftUI

// MARK: - Constants
private enum StepperMetrics {
    // Base card
    static let cardWidth: CGFloat = 364
    static let cardHeight: CGFloat = 190
    static let cardCornerRadius: CGFloat = 27

    // Header
    static let headerTopPadding: CGFloat = 25
    static let headerHorizontalPadding: CGFloat = 26

    // Stepper container
    static let stepperTopSpacing: CGFloat = 23
    static let stepperCornerRadius: CGFloat = 20
    static let stepperPadding: CGFloat = 4
    static let stepperGap: CGFloat = 6

    // Stepper elements
    static let buttonWidth: CGFloat = 100
    static let buttonHeight: CGFloat = 79
    static let elementCornerRadius: CGFloat = 20
    static let pillWidth: CGFloat = 92
    static let pillHeight: CGFloat = 79

    // Business logic
    static let creditStep: Int = 1000
    static let pricePerCredit: Double = 0.015
}

private enum PreviewRuntime {
    static var isRunning: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

// MARK: - Design Tokens
private enum Token {
    enum Surface {
        static let canvas  = Color(red: 0.82, green: 0.82, blue: 0.84)           // preview/app background
        static let card    = Color(red: 0.949, green: 0.949, blue: 0.949)         // #F2F2F2
        static let stepper = Color(red: 237/255, green: 237/255, blue: 237/255)   // #ededed
        static let pill    = Color(red: 236/255, green: 236/255, blue: 236/255)   // #ececec
        static let border  = Color(red: 229/255, green: 229/255, blue: 229/255)   // #e5e5e5
    }

    enum Label {
        static let primary   = Color(red:   4/255, green:   4/255, blue:   4/255) // #040404
        static let secondary = Color(red: 183/255, green: 183/255, blue: 183/255) // #b7b7b7
    }

    enum Button {
        static let fill        = Color(red: 0.85, green: 0.85, blue: 0.85)
        static let outerStroke = Color.black
    }

    enum Bevel {
        // L→R and R→L colors
        static let start = Color(red: 0.94, green: 0.95, blue: 0.93).opacity(0) // transparent edge
        static let mid   = Color(red: 0.75, green: 0.75, blue: 0.74)
        static let end   = Color(red: 0.37, green: 0.37, blue: 0.37)            // dark edge

        // L→R and R→L stop positions
        static let startStop: CGFloat = 0.0
        static let midStop:   CGFloat = 0.9
        static let endStop:   CGFloat = 1.0

        // T→B and B→T colors
        static let topStart = Color(red: 0.867, green: 0.867, blue: 0.859)      // #DDDDDB
        static let topEnd   = Color(red: 0.4,   green: 0.4,   blue: 0.4).opacity(0) // #666666 · 0%

        // T→B and B→T stop positions — tight, close to edge
        static let topStartStop: CGFloat = 0.0
        static let topEndStop:   CGFloat = 0.15
    }

    enum Icon {
        static let fill      = Color(red: 0.58, green: 0.58, blue: 0.58)
        static let highlight = Color(red: 0.95, green: 0.95, blue: 0.95)
    }
}

// MARK: - CreditsStepperCard
struct CreditsStepperCard: View {
    @State private var credits: Int = 0
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var cardScale: CGFloat { sizeClass == .regular ? 1.5 : 1.0 }

    private var price: Double { Double(credits) * StepperMetrics.pricePerCredit }

    var body: some View {
        ZStack {
            Token.Surface.canvas.opacity(0.7).ignoresSafeArea()

            CardContainer(scale: cardScale) {
                VStack(spacing: 0) {
                    header
                        .padding(.top, StepperMetrics.headerTopPadding)
                        .padding(.horizontal, StepperMetrics.headerHorizontalPadding)

                    stepperRow
                        .padding(.top, StepperMetrics.stepperTopSpacing)
                        .padding(.horizontal, StepperMetrics.headerHorizontalPadding)

                    Spacer(minLength: 0)
                }
            }
            .padding(.horizontal, 22)
        }
        .accessibilityHidden(PreviewRuntime.isRunning)
    }

    // MARK: Header
    private var header: some View {
        HStack {
            Text("Credits")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(Token.Label.secondary)
                .tracking(-0.84)

            Spacer()

            Text(price, format: .currency(code: "USD"))
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(credits == 0 ? Token.Label.secondary : Token.Label.primary)
                .tracking(-1.96)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.25, dampingFraction: 0.5), value: price)
        }
    }

    // MARK: Stepper Row
    private var stepperRow: some View {
        HStack(spacing: StepperMetrics.stepperGap) {
            StepperButton(symbol: "minus") {
                credits = max(0, credits - StepperMetrics.creditStep)
            }

            ValuePill(text: compactCredits(credits), isEmpty: credits == 0)

            StepperButton(symbol: "plus") {
                credits += StepperMetrics.creditStep
            }
        }
        .padding(StepperMetrics.stepperPadding)
        .frame(height: StepperMetrics.buttonHeight + (StepperMetrics.stepperPadding * 2))
        .background(
            RoundedRectangle(cornerRadius: StepperMetrics.stepperCornerRadius, style: .continuous)
                .fill(Token.Surface.stepper)
                .overlay(
                    RoundedRectangle(cornerRadius: StepperMetrics.stepperCornerRadius, style: .continuous)
                        .stroke(Token.Surface.border, lineWidth: 1)
                )
        )
        .buttonStyle(.plain)
    }

    private func compactCredits(_ value: Int) -> String {
        "\(value / 1000)k"
    }
}

// MARK: - Card Container
private struct CardContainer<Content: View>: View {
    let scale: CGFloat
    let content: Content

    init(scale: CGFloat = 1.0, @ViewBuilder content: () -> Content) {
        self.scale = scale
        self.content = content()
    }

    var body: some View {
        content
            .frame(width: StepperMetrics.cardWidth, height: StepperMetrics.cardHeight)
            .background(Token.Surface.card)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 1)
            )
            .scaleEffect(scale)
    }
}

// MARK: - Stepper Button
private struct StepperButton: View {
    let symbol: String
    let action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                // Layer 1: gradient fill + outer bezel stroke
                RoundedRectangle(cornerRadius: StepperMetrics.elementCornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Token.Button.fill, location: 0.0),
                                .init(color: Token.Button.fill, location: 1.0)
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: StepperMetrics.elementCornerRadius, style: .continuous)
                            .inset(by: -0.5)
                            .stroke(Token.Button.outerStroke, lineWidth: 1)
                    )

                // Layer 2: inner bevel — two opposing gradients with blend mode
                ZStack {
                    RoundedRectangle(cornerRadius: StepperMetrics.elementCornerRadius, style: .continuous)
                        .inset(by: 1.5)
                        .stroke(
                            LinearGradient(
                                stops: [
                                    .init(color: Token.Bevel.start, location: Token.Bevel.startStop),
                                    .init(color: Token.Bevel.mid,   location: Token.Bevel.midStop),
                                    .init(color: Token.Bevel.end,   location: Token.Bevel.endStop)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 3
                        )
                        .blendMode(.darken)

                    RoundedRectangle(cornerRadius: StepperMetrics.elementCornerRadius, style: .continuous)
                        .inset(by: 1.5)
                        .stroke(
                            LinearGradient(
                                stops: [
                                    .init(color: Token.Bevel.start, location: Token.Bevel.startStop),
                                    .init(color: Token.Bevel.mid,   location: Token.Bevel.midStop),
                                    .init(color: Token.Bevel.end,   location: Token.Bevel.endStop)
                                ],
                                startPoint: .trailing,
                                endPoint: .leading
                            ),
                            lineWidth: 3
                        )
                        .blendMode(.darken)

                    // Stroke 3 — top → bottom
                    RoundedRectangle(cornerRadius: StepperMetrics.elementCornerRadius, style: .continuous)
                        .inset(by: 1.5)
                        .stroke(
                            LinearGradient(
                                stops: [
                                    .init(color: Token.Bevel.topStart, location: Token.Bevel.topStartStop),
                                    .init(color: Token.Bevel.topEnd,   location: Token.Bevel.topEndStop)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 3
                        )
                        .blendMode(.normal)

                    // Stroke 4 — bottom → top
                    RoundedRectangle(cornerRadius: StepperMetrics.elementCornerRadius, style: .continuous)
                        .inset(by: 1.5)
                        .stroke(
                            LinearGradient(
                                stops: [
                                    .init(color: Token.Bevel.topStart, location: Token.Bevel.topStartStop),
                                    .init(color: Token.Bevel.topEnd,   location: Token.Bevel.topEndStop)
                                ],
                                startPoint: .bottom,
                                endPoint: .top
                            ),
                            lineWidth: 3
                        )
                        .blendMode(.normal)
                }
                .compositingGroup()

                // Icon
                if symbol == "minus" {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 32, height: 4)
                        .background(Token.Icon.fill)
                        .cornerRadius(30)
                        .shadow(color: Token.Icon.highlight, radius: 0, x: 0, y: 0.5)
                } else {
                    ZStack {
                        Rectangle()
                            .frame(width: 25, height: 3)
                            .cornerRadius(30)
                        Rectangle()
                            .frame(width: 25, height: 3)
                            .cornerRadius(30)
                            .rotationEffect(.degrees(90))
                    }
                    .foregroundColor(Token.Icon.fill)
                    .compositingGroup()
                    .shadow(color: Token.Icon.highlight, radius: 0, x: 0, y: 0.5)
                }
            }
            .frame(width: StepperMetrics.buttonWidth, height: StepperMetrics.buttonHeight)
            .shadow(
                color: .black.opacity(pressed ? 0 : 0.20),
                radius: pressed ? 0 : 14,
                x: 0,
                y: pressed ? 0 : 14
            )
            .scaleEffect(pressed ? 0.98 : 1)
            .animation(.spring(response: 0.20, dampingFraction: 0.75), value: pressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: 24,
            pressing: { isPressing in
                if PreviewRuntime.isRunning { return }
                withAnimation(.spring(response: 0.20, dampingFraction: 0.75)) {
                    pressed = isPressing
                }
            },
            perform: {}
        )
        .accessibilityLabel(symbol == "plus" ? "Increase credits" : "Decrease credits")
    }
}

// MARK: - Value Pill
private struct ValuePill: View {
    let text: String
    let isEmpty: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: StepperMetrics.elementCornerRadius, style: .continuous)
                .fill(Token.Surface.pill)
                .overlay(
                    RoundedRectangle(cornerRadius: StepperMetrics.elementCornerRadius, style: .continuous)
                        .stroke(Token.Surface.border, lineWidth: 1)
                )

            Text(text)
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(isEmpty ? Token.Label.secondary : Token.Label.primary)
                .tracking(-1.96)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.25, dampingFraction: 0.5), value: text)
        }
        .frame(width: StepperMetrics.pillWidth, height: StepperMetrics.pillHeight)
        .accessibilityLabel("Credits \(text)")
    }
}

#Preview("Credits stepper card") {
    ZStack {
        Token.Surface.canvas.opacity(0.7).ignoresSafeArea()
        CreditsStepperCard()
    }
    .preferredColorScheme(.light)
}

#Preview("Plus button") {
    ZStack {
        Token.Surface.canvas.opacity(0.7).ignoresSafeArea()
        StepperButton(symbol: "plus") {}
    }
    .accessibilityHidden(true)
    .preferredColorScheme(.light)
}
