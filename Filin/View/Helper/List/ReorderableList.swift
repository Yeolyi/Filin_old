//
//  ContentView.swift
//  CustomList
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI

struct ReorderableList<Value: Hashable, Content: View>: View {
    
    let view: (UUID) -> Content
    @ObservedObject var listData: ListData<Value>
    var maxHeight: CGFloat?
    
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
                            .subColor()
                            .font(.system(size: 24, weight: .semibold))
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
            .onAppear {
                listData.contentHeight = maxHeight ?? geo.size.height
            }
            .offset(y: listData.scrollPosition + listData.dragHeight)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        listData.dragHeight = (value.location.y - value.startLocation.y)/2
                    }
                    .onEnded { _ in
                        withAnimation {
                            listData.dragHeight += listData.scrollPosition
                            if -listData.dragHeight > listData.totalHeight - (maxHeight ?? geo.size.height) {
                                listData.dragHeight = (maxHeight ?? geo.size.height) - listData.totalHeight
                            }
                            if listData.dragHeight > 0 {
                                listData.dragHeight = 0
                            }
                            listData.scrollPosition = listData.dragHeight
                            listData.dragHeight = 0
                        }
                    }
            )
        }
        .frame(height: maxHeight)
        .clipped()
    }
    
    @Environment(\.colorScheme) var colorScheme
    
}
