//
//  ButtonStyle.swift
//  JogoDaVelha3
//
//  Created by Victor Hugo Pacheco Araujo on 25/10/23.
//

import SwiftUI

struct PlayerButtonStyle: ButtonStyle {
  let isCurrent: Bool
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(8)
      .background(RoundedRectangle(cornerRadius: 10)
        .fill(isCurrent ? Color.green : Color.gray)
      )
      .foregroundStyle(.white)
  }
  
}
