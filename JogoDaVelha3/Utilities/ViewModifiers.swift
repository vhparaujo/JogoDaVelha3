//
//  ViewModifiers.swift
//  JogoDaVelha3
//
//  Created by Victor Hugo Pacheco Araujo on 25/10/23.
//

import SwiftUI

struct NavStackModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    if #available(iOS 16, *) {
      NavigationStack{
        content
      }
    } else {
      NavigationView{
        content
      }.navigationViewStyle(.stack)
    }
  }
  
}


extension View {
  public func inNavigationStack() -> some View {
    return self.modifier(NavStackModifier())
  }
  
}
