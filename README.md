# CreditsStepperCard

A tactile SwiftUI credits stepper with layered bevel strokes, spring animations, and adaptive iPad scaling.

https://github.com/user-attachments/assets/c372626f-1c6c-4760-ad6f-8cb2bf824f45

https://x.com/Vraj247/status/2047978624209580336?s=20

---

## Preview

<video src="assets/demo.mp4" autoplay loop muted playsinline width="100%"></video>

| iPhone | iPad |
|--------|------|
| 1× scale | 1.5× scale |

---

## Features

- **Layered bevel strokes** — Four gradient strokes (L→R, R→L, T→B, B→T) with blend modes create a physical button bezel
- **Spring press animation** — Shadow opacity, radius, and offset all animate to zero on press, simulating a real button touching the surface
- **Numeric text transitions** — Credits pill and price animate with `.numericText()` on every step
- **Adaptive iPad scaling** — Uses a custom `layoutScale` environment key to scale all dimensions and font sizes natively, avoiding bitmap blur
- **Credits clamped** — Range locked between `0k` and `10k` in steps of `1k`
- **Price derived** — Price updates automatically at `$0.015` per credit
- **Design token system** — All colors and metrics live in `Token` and `StepperMetrics` enums for easy tuning

---

## Structure

```
CreditsStepperCard/
├── CreditsStepperCardApp.swift   — @main entry point
└── CreditsStepperCard.swift      — full component
    ├── StepperMetrics            — all layout constants and business logic
    ├── LayoutScaleKey            — custom environment key for iPad scaling
    ├── Token                     — design token system (Surface, Label, Button, Bevel, Icon)
    ├── CreditsStepperCard        — root view, owns credits state
    ├── CardContainer             — scaled card shell
    ├── StepperButton             — tactile +/− button with bevel layers
    └── ValuePill                 — animated credit display
```

---

## Button Bevel — How It Works

The bevel effect stacks four `RoundedRectangle` strokes inside a `compositingGroup()`:

```
Stroke 1 — L→R gradient  .blendMode(.darken)   darkens left edge
Stroke 2 — R→L gradient  .blendMode(.darken)   darkens right edge
Stroke 3 — T→B gradient  .blendMode(.normal)   highlights top edge
Stroke 4 — B→T gradient  .blendMode(.normal)   highlights bottom edge
```

Each stroke uses `.inset(by: 1.5)` to sit inside the fill edge, and a separate outer stroke uses `.inset(by: -0.5)` to form the hard black bezel ring.

---

## Tuning

All adjustable values are in `StepperMetrics` and `Token.Bevel`:

```swift
// Credits range
static let creditMin: Int  = 0
static let creditMax: Int  = 10_000
static let creditStep: Int = 1_000

// Price
static let pricePerCredit: Double = 0.015

// Bevel gradient stops
static let midStop:      CGFloat = 0.9   // how far L→R and R→L travel
static let topEndStop:   CGFloat = 0.15  // how far T→B and B→T travel

// iPad scale
private var layoutScale: CGFloat { sizeClass == .regular ? 1.5 : 1.0 }
```

---

## Requirements

- iOS 17.0+
- Xcode 15+
- Swift 5.9+

---

## License

MIT
