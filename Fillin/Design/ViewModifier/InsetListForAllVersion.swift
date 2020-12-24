//
//  InsetListForAllVersion.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

extension List {
  @ViewBuilder
  func insetGroupedListStyle() -> some View {
    if #available(iOS 14.0, *) {
      self
        .listStyle(InsetGroupedListStyle())
    } else {
      self
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
  }
}
