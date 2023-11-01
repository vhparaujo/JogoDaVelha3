//
//  JogoDaVelha3App.swift
//  JogoDaVelha3
//
//  Created by Victor Hugo Pacheco Araujo on 24/10/23.
//

import SwiftUI

@main
struct JogoDaVelha3App: App {
  @AppStorage("yourName") var yourName = ""
  @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
          if yourName.isEmpty {
            YourNameView()
          } else {
            StartView(yourName: yourName)
              .environmentObject(game)
          }
          
        }
    }
}
