//
//  ContentView.swift
//  CustomList
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI

class ListData<Value: Hashable>: ObservableObject {
    
    struct RowData: Hashable {
        internal init(_ id: UUID, _ value: Value, _ yPosition: CGFloat) {
            self.id = id
            self.value = value
            self.yPosition = yPosition
        }
        
        var id: UUID
        var value: Value
        var yPosition: CGFloat
    }
    
    @Published var list: [RowData] = []
    @Published var locationList: [RowData] = []
    var locationBackup: [RowData] = []
    var locationBackupVibration: [RowData] = []
    var onTapIndex: Int?
    
    let rowHeight: CGFloat = 50
    let padding: CGFloat = 5
    let save: ([Value]) -> Void
    
    var totalHeight: CGFloat {
        CGFloat(list.count) * (padding + rowHeight)
    }
    
    init(values: [Value], save: @escaping ([Value]) -> Void) {
        var tempLocationList: [RowData] = []
        var tempList: [(UUID, Value)] = []
        for index in 0..<values.count {
            let id = UUID()
            tempList.append((id, values[index]))
            tempLocationList.append(.init(id, values[index], CGFloat(index) * (rowHeight + padding)))
        }
        locationList = tempLocationList
        locationBackup = tempLocationList
        locationBackupVibration = tempLocationList
        list = tempLocationList
        self.save = save
    }
    
    var sortedValue: [Value] {
        list.sorted(by: {$0.yPosition < $1.yPosition}).map{$0.value}
    }
    
    func internalIDToValue(_ id: UUID) -> Value {
        locationList.first(where: {$0.id == id})!.value
    }
    
    func add(value: Value) {
        let id = UUID()
        locationList.append(.init(id, value, CGFloat(locationList.count) * (rowHeight + padding)))
        locationBackup = locationList
        locationBackupVibration = locationList
        list = locationList
    }
    func delete(id: UUID) {
        list.remove(at: list.firstIndex(where: {$0.id == id})!)
        for index in 0..<list.count {
            list[index].yPosition =  CGFloat(index) * (rowHeight + padding)
        }
        locationList = list
        locationBackup = locationList
        locationBackupVibration = locationList
    }
    func yPosition(id: UUID) -> CGFloat {
        locationList[locationIndex(id)].yPosition
    }
    
    func locationIndex(_ id: UUID) -> Int {
        locationList.firstIndex(where: {$0.id == id})!
    }
    
    func onTap(id: UUID) -> Bool {
        onTapIndex == locationIndex(id)
    }
    
    func getOffset(id: UUID) -> CGFloat {
        guard locationIndex(id) != onTapIndex, onTapIndex != nil else {
            return 0
        }
        let supposeReordered = locationList.sorted(by: {$0.yPosition < $1.yPosition})
        let newIndex = supposeReordered.firstIndex(where: {$0.id == id})!
        let currentIndex = locationBackup.sorted(by: {$0.yPosition < $1.yPosition}).firstIndex(where: {$0.id == id})!
        if currentIndex < newIndex {
            return rowHeight + padding
        } else if currentIndex > newIndex {
            return -(rowHeight + padding)
        }
        return 0
    }
    func rowDrag(id: UUID) -> some Gesture {
        DragGesture()
            .onChanged { dragData in
                if self.locationBackupVibration.sorted(by: {$0.yPosition < $1.yPosition})
                    .map({$0.id}) != self.locationList.sorted(by: {$0.yPosition < $1.yPosition}).map({$0.id}) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                self.locationBackupVibration = self.locationList
                self.locationList[self.locationIndex(id)].yPosition += dragData.location.y
                self.onTapIndex = self.locationIndex(id)
            }
            .onEnded { [self] _ in
                var tempList = locationList.sorted(by: {$0.yPosition < $1.yPosition})
                var temp: CGFloat = 0
                for index in tempList.indices {
                    tempList[index].yPosition = (rowHeight + padding) * temp
                    temp += 1
                }
                for index in locationList.indices {
                    locationList[index].yPosition
                        = tempList.first(where: {$0.id == locationList[index].id})!.yPosition
                }
                self.onTapIndex = nil
                locationBackup = locationList
                list = locationList
                save(sortedValue)
            }
    }
}

struct ReorderableList<Value: Hashable, Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme
    let view: (UUID) -> Content
    @ObservedObject var listData: ListData<Value>
    var maxHeight: CGFloat?
    @State var dragHeight: CGFloat = 0
    @State var scrollPosition: CGFloat = 0
    
    init(listData: ListData<Value>, maxHeight: CGFloat? = nil, view: @escaping (UUID) -> Content) {
        self.listData = listData
        self.view = view
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(listData.list, id: \.self) { listElement in
                    HStack(spacing: 0) {
                        view(listElement.id)
                        Spacer()
                        Image(systemName: "pause")
                            .rotationEffect(.degrees(-90))
                            .mainColor()
                            .font(.system(size: 25))
                            .gesture(
                                listData.rowDrag(id: listElement.id)
                            )
                    }
                    .frame(height: listData.rowHeight)
                    .padding(.bottom, listData.padding)
                    .background(
                        Rectangle()
                            .foregroundColor(colorScheme == .light ? .white : .black)
                    )
                    .compositingGroup()
                    .shadow(radius: listData.onTap(id: listElement.id) ? 2 : 0)
                    .position(x: geo.size.width/2, y: 30 + listData.yPosition(id: listElement.id))
                    .offset(y: listData.getOffset(id: listElement.id))
                    .zIndex(listData.onTap(id: listElement.id) ? 1 : 0)
                }
            }
            .offset(y: scrollPosition + dragHeight)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragHeight = (value.location.y - value.startLocation.y)/2
                    }
                    .onEnded { _ in
                        withAnimation {
                            dragHeight += scrollPosition
                            if -dragHeight > listData.totalHeight - (maxHeight ?? geo.size.height) {
                                dragHeight = (maxHeight ?? geo.size.height) - listData.totalHeight
                            }
                            if dragHeight > 0 {
                                dragHeight = 0
                            }
                            scrollPosition = dragHeight
                            dragHeight = 0
                        }
                    }
            )
        }
        .frame(height: maxHeight)
        .clipped()
    }
}
