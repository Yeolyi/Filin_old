//
//  NavigationView.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/10.
//

import SwiftUI

struct PaperNavigationView<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                    .zIndex(1)
                Image("paper")
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(0)
            }
            
        }
    }
}

struct PaperNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        PaperNavigationView {
            List {
                Text("Test")
            }
        }
    }
}
