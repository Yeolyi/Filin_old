//
//  ContentView.swift
//  CustomList
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI

struct ReorderableList<Value: Hashable, Content: View>: View {
    struct RowData: Hashable {
        var id = UUID()
        var name: Value
        var yPosition: CGFloat
        init(_ name: Value, _ yPosition: CGFloat) {
            self.name = name
            self.yPosition = yPosition
        }
    }
    @State var list: [Value]
    @State var locationList: [RowData] = []
    @State var locationBackup: [RowData] = []
    @State var locationBackupVibration: [RowData] = []
    @State var onTapIndex: Int?
    let rowHeight: CGFloat = 30
    let padding: CGFloat = 30
    let save: ([Value]) -> Void
    let view: (Value) -> Content
    init(value: [Value], save: @escaping ([Value]) -> Void, view: @escaping (Value) -> Content) {
        var tempLocationList: [RowData] = []
        self.save = save
        self.view = view
        _list = State(initialValue: value)
        for index in 0..<list.count {
            tempLocationList.append(.init(list[index], CGFloat(index) * (rowHeight + padding)))
        }
        _locationList = State(initialValue: tempLocationList)
        _locationBackup = State(initialValue: tempLocationList)
    }
    func getOffset(index: Int) -> CGFloat {
        guard index != onTapIndex, onTapIndex != nil else {
            return 0
        }
        let supposeReordered = locationList.sorted(by: {$0.yPosition < $1.yPosition})
        let newIndex = supposeReordered.firstIndex(where: {$0.id == locationList[index].id})!
        let currentIndex = locationBackup.sorted(by: {$0.yPosition < $1.yPosition}).firstIndex(where: {$0.id == locationList[index].id})!
        if currentIndex < newIndex {
            return rowHeight + padding
        } else if currentIndex > newIndex {
            return -(rowHeight + padding)
        }
        return 0
    }
    func rowDrag(index: Int) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if locationBackupVibration.sorted(by: {$0.yPosition < $1.yPosition}).map{$0.id} != locationList.sorted(by: {$0.yPosition < $1.yPosition}).map{$0.id} {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                locationBackupVibration = locationList
                self.locationList[index].yPosition += value.location.y
                self.onTapIndex = index
            }
            .onEnded { _ in
                var tempList = locationList.sorted(by: {$0.yPosition < $1.yPosition})
                var temp: CGFloat = 0
                for index in tempList.indices {
                    tempList[index].yPosition = (rowHeight + 20) * temp
                    temp += 1
                }
                for index in locationList.indices {
                    locationList[index].yPosition
                        = tempList.first(where: {$0.id == locationList[index].id})!.yPosition
                }
                self.onTapIndex = nil
                locationBackup = locationList
                list = locationList.map {$0.name}
                save(locationList.sorted(by: {$0.yPosition < $1.yPosition}).map {$0.name})
            }
    }
    var body: some View {
        if locationList.isEmpty {
            EmptyView()
        } else {
            GeometryReader { geo in
                ZStack {
                    ForEach(0...locationList.count-1, id: \.self) { index in
                        HStack {
                            view(locationList[index].name)
                            Spacer()
                            Image(systemName: "circle")
                                .font(.system(size: 20))
                                .gesture(
                                    rowDrag(index: index)
                                )
                        }
                        .rowBackground()
                        .contentShape(Rectangle())
                        .background(Color.white.shadow(radius: onTapIndex == index ? 3 : 0))
                        .zIndex(onTapIndex == index ? 1 : 0)
                        .frame(height: rowHeight)
                        .position(x: geo.size.width/2, y: 30 + locationList[index].yPosition)
                        .offset(y: getOffset(index: index))
                    }
                }
            }
        }
    }
}
