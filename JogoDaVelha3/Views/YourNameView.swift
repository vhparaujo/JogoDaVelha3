//
//  YourNameView.swift
//  JogoDaVelha3
//
//  Created by Victor Hugo Pacheco Araujo on 25/10/23.
//

import SwiftUI

struct YourNameView: View {
  @AppStorage("yourName") var yourName = ""
  @State private var userName = ""
    var body: some View {
      VStack {
        Text(String(localized: "labelNameDevice"))
        TextField(String(localized: "nameDeviceKey"), text: $userName)
          .textFieldStyle(.roundedBorder)
        Button(String(localized: "setDeviceNameButtonLabel")) {
          yourName = userName
        }
        .buttonStyle(.borderedProminent)
        .disabled(userName.isEmpty)
        
        Image("LaunchScreen")
        Spacer()
        
      }.padding()
        .navigationTitle("tictactoe3Key")
        .inNavigationStack()
        .onTapGesture {
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
      
    }
}

#Preview {
    YourNameView()
}
