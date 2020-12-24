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
    @State var isAnimation = false
    init(_ ringDataTuples: [(progress: Double, color: Color)?], @ViewBuilder content: @escaping () -> Content) {
        var tempRingDatas: [RingData] = []
        for ringDataTuple in ringDataTuples {
            if ringDataTuple == nil {
                tempRingDatas.append(.init(progress: 1, color: .clear))
                continue
            }
            tempRingDatas.append(.init(progress: ringDataTuple!.progress, color: ringDataTuple!.color))
        }
        self.ringDatas = tempRingDatas
        self.content = content()
    }
    func index(_ ringData: RingData) -> Int {
        ringDatas.firstIndex(where: {$0.id == ringData.id}) ?? 0
    }
    var body: some View {
        VStack {
            if ringDatas.count > 1 {
                content
                    .padding(.bottom, 2)
            }
            ZStack {
                if !ringDatas.isEmpty {
                    ForEach(0...ringDatas.count-1, id: \.self) { index in
                        Circle()
                            .foregroundColor(.clear)
                            .overlay(
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(ringDatas[index].progress))
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                                    .foregroundColor(ringDatas[index].color)
                                    .rotationEffect(Angle(degrees: 270.0))
                                    .if(isAnimation) {
                                        $0.animation(.linear)
                                    }
                            )
                            .frame(width: 40 - CGFloat(index * 12), height: 40 - CGFloat(index * 12))
                    }
                    .zIndex(0)
                }
                if ringDatas.count <= 1 {
                    content
                }
            }
            .frame(width: 40, height: 40)
        }
        .onAppear {
            isAnimation = true
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
