# AnimationProject

Interactive dot-matrix repulsion animation built with SwiftUI and SpriteKit. A grid of physics-driven dots reacts to touch input via a radial gravity field — dots scatter on touch and spring back to their anchor points.

## Preview

> Touch/drag anywhere on screen → dots within ~120pt radius are repelled → spring physics returns them smoothly when released.

<img width="580" height="1106" alt="ScreenRecording2026-09-02at2 53 01PM-ezgif com-video-to-gif-converter" src="https://github.com/user-attachments/assets/b87bc172-6e40-41a8-bc27-fabbb83c702a" />



## Features

- **Physics-based interaction** — `SKFieldNode` radial gravity field with negative strength for repulsion
- **Spring-anchored dots** — Each dot is a `SKPhysicsBody` connected to a static anchor via `SKPhysicsJointSpring`
- **Touch responsive** — `touchesBegan` / `touchesMoved` / `touchesEnded` moves the field in real-time
- **Adaptive layout** — Grid computed from view size (`spacing = 20pt`)
- **SwiftUI + SpriteKit bridge** — `SpriteView` hosted in `GeometryReader` with cached `SKScene`

## Tech Stack

| Layer | Technology |
|-------|------------|
| UI | SwiftUI (`ContentView.swift:10`) |
| Rendering / Physics | SpriteKit (`GridScene.swift:11`) |
| Scene Lifecycle | `ObservableObject` + `SKScene` cache (`SceneHolder.swift:11`) |
| Language | Swift 5.0 |
| Platform | iOS 26.5+, iPhone & iPad, Xcode 26.6+ |

## How It Works

### 1. Repulsion Field — `GridScene.swift:24-31`

```swift
fieldNode = SKFieldNode.radialGravityField()
fieldNode.strength = -6.0      // negative = repulsion
fieldNode.falloff = 1.0
fieldNode.region = SKRegion(radius: 120)
```

`SKFieldNode` is parked offscreen at `(-1000, -1000)` when idle and moved to the touch location on interaction.

### 2. Dot Matrix — `GridScene.swift:32-68`

For each cell in `cols = width / 20` × `rows = height / 20`:

1.  Visual dot: `SKShapeNode(circleOfRadius: 0.5...1.5)` — random radius, `systemCyan` fill.
2.  Dynamic body: `SKPhysicsBody(circleOfRadius: 1.5)` — `isDynamic = true`, `affectedByGravity = false`, `linearDamping = 3.8`.
3.  Anchor: invisible static `SKNode` with `SKPhysicsBody(circleOfRadius: 3)` — `isDynamic = false`.
4.  Spring joint: `SKPhysicsJointSpring` with `frequency = 1.5`, `damping = 0.5` ties dot to anchor.

Result: dots are displaced by the field force but elastically return.

### 3. Touch Handling — `GridScene.swift:70-84`

```swift
touchesBegan / touchesMoved -> fieldNode.position = touch.location(in: self)
touchesEnded               -> fieldNode.position = (-1000, -1000)
```

### 4. Scene Hosting — `ContentView.swift:13-18` + `SceneHolder.swift:14-27`

```swift
GeometryReader { proxy in
    SpriteView(scene: sceneHolder.getScene(size: proxy.size))
}
```

`SceneHolder` caches a single `GridScene` and updates its `size` on geometry changes with `scaleMode = .resizeFill`.

## Project Structure

```
AnimationProject/
├── AnimationProject/
│   ├── AnimationProjectApp.swift  # @main entry, WindowGroup -> ContentView
│   ├── ContentView.swift          # SwiftUI view hosting SpriteView
│   ├── GridScene.swift            # SKScene: field, dot matrix, touch logic
│   ├── SceneHolder.swift          # ObservableObject scene cache
│   └── Assets.xcassets/           # AppIcon, AccentColor
└── AnimationProject.xcodeproj/    # Xcode project (FileSystemSynchronized group)
```

## Getting Started

### Requirements

- Xcode 26.6+
- iOS 26.5+ deployment target (lower to `17.0`/`18.0` in project settings if needed)
- Swift 5.0

### Run

```bash
git clone <repo-url>
open AnimationProject.xcodeproj
# Select a simulator (iPhone / iPad) and press Cmd+R
```

No external dependencies — just `SwiftUI` + `SpriteKit`.

## Customization

All tunables are in `GridScene.swift`:

| Parameter | Location | Default | Effect |
|-----------|----------|---------|--------|
| `spacing` | `GridScene.swift:33` | `20` | Grid density — lower = more dots (performance cost) |
| `fieldNode.strength` | `GridScene.swift:26` | `-6.0` | Repulsion force — more negative = stronger push |
| `fieldNode.region` radius | `GridScene.swift:28` | `120` | Interaction radius |
| `dotRadius` | `GridScene.swift:41` | `0.5...1.5` | Visual size randomization |
| `linearDamping` | `GridScene.swift:50` | `3.8` | How quickly dots settle |
| `joint.frequency` | `GridScene.swift:63` | `1.5` | Spring stiffness |
| `joint.damping` | `GridScene.swift:64` | `0.5` | Spring oscillation damping |
| `dot.fillColor` | `GridScene.swift:43` | `.systemCyan` | Dot color |

Example — larger, softer repulsion:

```swift
fieldNode.strength = -3.0
fieldNode.region = SKRegion(radius: 180)
joint.frequency = 0.8
```
