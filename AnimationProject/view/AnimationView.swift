//
//  AnimationView.swift
//  AnimationProject
//
//  Created by iPHTech 40 on 15/09/26.
//
import SwiftUI

struct AnimationView: View, CustomAnimations {
    
    @State var progress: CGFloat = 0.0
    @State var stage2Progress:CGFloat = 0.0
    @State var outerSlideWidth: CGFloat = 0
    @State var outerSlideHeight: CGFloat = 0
    @State var startSlideWidth: CGFloat = 20.0
    @State var startSlideHeight: CGFloat = 180.0
    @State var bottomCircleWidth: CGFloat = 10.0
    @State var bottomCircleHeight: CGFloat = 10.0
    @State private var isRotating1 = false
    @State private var isRotating2 = false
    @State private var showOuterCircle = true
    @State private var showInnerCircle = false
    @State var showCircle: Bool = false
    @State var stage: Int = 0
    
    var body: some View {
        
        sideSlideView
        
        LampView(previousProgress: $progress, stage2Progress: $stage2Progress,  stage: $stage)
        
        VStack(spacing: 0) {
            
            Rectangle()
                .fill(Color("DarkBrown"))
                .frame(width: lerp(from: 240, to: 240), height: lerp(from: 16, to: 15))
                .offset(y: lerp(from: 0, to: 198))
                .zIndex(progress > 0.5 ? 0 : 1)
            
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.red.opacity(0.8))
                    .frame(
                        width: lerp(from: 80, to: 120),
                        height: lerp(from: 50, to: 320)
                    )
                
                Rectangle()
                    .fill(Color.red)
                    .frame(
                        width: lerp(from: 80, to: 120),
                        height: lerp(from: 50, to: 320)
                    )
            }
            .frame(width: 160, height: 50)
            .overlay {
                HStack(spacing: lerp(from: 0, to: 25)) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: lerp(from: 10, to: 15), height: lerp(from: 10, to: 15))
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: lerp(from: 10, to: 15), height: lerp(from: 10, to: 15))
                        .opacity(progress)
                }
            }
            
            HStack(spacing: lerp(from: 120, to: 215)) {
                Rectangle()
                    .fill(Color("DarkBrown"))
                    .frame(
                        width: lerp(from: 10, to: 12),
                        height: lerp(from: 80, to: 30)
                    )
                
                Rectangle()
                    .fill(Color("DarkBrown"))
                    .frame(
                        width: lerp(from: 10, to: 12),
                        height: lerp(from: 80, to: 30)
                    )
            }
            .offset(
                y: lerp(from: 0, to: 148)
            )
        }
        .scaleEffect(stage == 2 ? (1.0 - stage2Progress) : 1.0)
        .rotationEffect(
            stage == 2 ? .degrees(Double(stage2Progress * -45)) : .degrees(0)
        )
        .onAppear {
            withAnimation(.spring(response: 1.8, dampingFraction: 0.75)
                .delay(0.5)
            ) {
                progress = progress == 0.0 ? 1.0 : 0.0
            }
        }
    }
    
    @ViewBuilder
    private var sideSlideView: some View {
        if stage == 0 || stage == 1 {
            HStack(spacing: 300) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(
                            width: lerp(from: startSlideWidth, to: outerSlideWidth),
                            height: lerp(from: startSlideHeight, to: outerSlideHeight)
                        )
                        .rotationEffect(stage == 1 ? .degrees(lerp(from: 30, to: -12)) : .degrees(0.0), anchor: .topLeading)
                        .overlay {
                            Rectangle()
                                .fill(Color.white)
                                .frame(
                                    width: lerp(from: startSlideWidth, to: outerSlideWidth),
                                    height: lerp(from: startSlideHeight, to: outerSlideHeight)
                                )
                                .rotationEffect(.degrees(lerp(from: 30, to: -30)), anchor: .topLeading)
                                .offset(x: -22, y: -5)
                                .opacity(stage == 1 ? 1 : 0)
                                .overlay {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(
                                            width: lerp(from: startSlideWidth, to: outerSlideWidth),
                                            height: lerp(from: startSlideHeight, to: outerSlideHeight)
                                        )
                                        .rotationEffect(.degrees(lerp(from: 30, to: -50)), anchor: .topLeading)
                                        .offset(x: -30, y: 10)
                                        .opacity(stage == 1 ? 1 : 0)
                                }
                        }
                    
                    Circle()
                        .fill(.white)
                        .frame(width: lerp(from: 0, to: bottomCircleWidth), height: lerp(from: 0, to: bottomCircleHeight))
                        .opacity(showCircle ? 1.0 : 0.0)
                }
                
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(
                            width: lerp(from: startSlideWidth, to: outerSlideWidth),
                            height: lerp(from: startSlideHeight, to: outerSlideHeight)
                        )
                        .rotationEffect(stage == 1 ? .degrees(lerp(from: -30, to: 12)) : .degrees(0.0), anchor: .topTrailing)
                        .overlay {
                            Rectangle()
                                .fill(Color.white)
                                .frame(
                                    width: lerp(from: startSlideWidth, to: outerSlideWidth),
                                    height: lerp(from: startSlideHeight, to: outerSlideHeight)
                                )
                                .rotationEffect(.degrees(lerp(from: -30, to: 30)), anchor: .topTrailing)
                                .offset(x: 22, y: -5)
                                .opacity(stage == 1 ? 1 : 0)
                                .overlay {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(
                                            width: lerp(from: startSlideWidth, to: outerSlideWidth),
                                            height: lerp(from: startSlideHeight, to: outerSlideHeight)
                                        )
                                        .rotationEffect(.degrees(lerp(from: -30, to: 50)), anchor: .topTrailing)
                                        .offset(x: 30, y: 10)
                                        .opacity(stage == 1 ? 1 : 0)
                                }
                        }
                    
                    Circle()
                        .fill(.white)
                        .frame(width: lerp(from: 0, to: bottomCircleWidth), height: lerp(from: 0, to: bottomCircleHeight))
                        .opacity(showCircle ? 1.0 : 0.0)
                }
            }
            .opacity(progress)
            .offset(y: lerp(from: 0, to: 240))
            .onChange(of: progress) { _, newValue in
                guard newValue == 1.0 else { return }
                
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(0.8))
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        showCircle = true
                    }
                    
                    try? await Task.sleep(for: .seconds(0.6))
                    withAnimation(.easeInOut(duration: 0.25)) {
                        stage = 1
                        outerSlideWidth = 4.0
                        outerSlideHeight = 18.5
                        showCircle = false
                    }
                    
                    try? await Task.sleep(for: .seconds(0.5))
                    
                    stage = 2
                    stage2Progress = 0.0
                    withAnimation(.easeOut(duration: 0.2)) {
                        stage2Progress = 1.0
                        outerSlideWidth = 0.0
                        outerSlideHeight = 0.0
                    }
                    
                    try? await Task.sleep(for: .milliseconds(350))
                    
                    withAnimation(.easeOut(duration: 1.5)) {
                        showOuterCircle = false
                        showInnerCircle = false
                        isRotating1 = false
                        isRotating2 = false
                    }
                    
                }
            }
        } else {
            loadingBorderView
                .frame(width: 260, height: 320)
                .transition(.opacity)
        }
    }
    
    private var loadingBorderView: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.7)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 350, height: 350)
                .rotationEffect(.degrees(isRotating1 ? 360 : 0))
                .opacity(showOuterCircle ? 1.0 : 0.0)
                
            Circle()
                .trim(from: 0.0, to: 0.5)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(isRotating2 ? 720 : 0))
                .opacity(showInnerCircle ? 1.0 : 0.0)
        }
        .onAppear {
            Task {@MainActor in
                await startSequentialRotation()
            }
        }
        .onDisappear {
            resetRotationStates()
        }
    }

    private func resetRotationStates() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            showOuterCircle = true
            showInnerCircle = false
            isRotating1 = false
            isRotating2 = false
        }
    }
    
    @MainActor
    private func startSequentialRotation() async {
        resetRotationStates()
        
        try? await Task.sleep(for: .milliseconds(50))
        
        withAnimation(.linear(duration: 0.35)) {
            isRotating1 = true
        }
        
        try? await Task.sleep(for: .milliseconds(150))
        
        var swapTransaction = Transaction()
        swapTransaction.disablesAnimations = true
        withTransaction(swapTransaction) {
            showOuterCircle = false
            showInnerCircle = true
        }
        
        withAnimation(.linear(duration: 0.35)) {
            isRotating2 = true
        }
    }
}

#Preview {
    ZStack {
        Color.yellow
            .ignoresSafeArea()
        AnimationView()
    }
}
