//
//  CircleProgress.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct CircleProgress<Content: View>: View {
    
    struct RingData: Identifiable {
        var id = UUID()
        let progress: Double
        let color: Color
    }
    
    let ringDatas: [RingData]
    let content: Content
    let shouldExpand: Bool
    @State var isAnimation = false
    
    var isRingEmpty: Bool {
        shouldExpand && ringDatas.filter{$0.color != .clear}.isEmpty
    }
    
    init(_ ringDataTuples: [(progress: Double, color: Color)?], @ViewBuilder content: @escaping () -> Content) {
        if ringDataTuples.count != 3 {
            assertionFailure()
        }
        if ringDataTuples[0] != nil && ringDataTuples[1] == nil && ringDataTuples[2] == nil {
            shouldExpand = false
        } else {
            shouldExpand = true
        }
        var tempRingDatas: [RingData] = []
        for ringDataTuple in ringDataTuples {
            if ringDataTuple == nil {
                tempRingDatas.append(.init(progress: 0, color: .clear))
            } else {
                tempRingDatas.append(.init(progress: ringDataTuple!.progress, color: ringDataTuple!.color))
            }
        }
        self.ringDatas = tempRingDatas
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if shouldExpand {
                content
                    .padding(.bottom, 5)
                    .padding(.top, 8)
            }
            ZStack {
                if !ringDatas.isEmpty {
                    ForEach(0...ringDatas.count-1, id: \.self) { index in
                        Circle()
                            .trim(from: 0.0, to: CGFloat(ringDatas[index].progress))
                            .stroke(style: StrokeStyle(lineWidth: 5.0 - CGFloat(index) * 0.5, lineCap: .square, lineJoin: .bevel))
                            .foregroundColor(ringDatas[index].color)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(isAnimation ? .linear : nil)
                            .frame(width: 40 - CGFloat(index * 12), height: 40 - CGFloat(index * 12))
                    }
                    .zIndex(0)
                }
                if !shouldExpand {
                    content
                }
                if isRingEmpty {
                    Circle()
                        .subColor()
                        .opacity(0.3)
                        .frame(width: 16, height: 16)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isAnimation = true
            }
        }
    }
}

struct CircleProgress_Previews: PreviewProvider {
    @Environment(\.colorScheme) var colorScheme
    static var previews: some View {
        CircleProgress([(0.314, .blue)]) {
            Text("15")
        }
    }
}
