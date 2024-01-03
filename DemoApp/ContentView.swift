//
//  ContentView.swift
//  DemoApp
//
//  Created by Tony Gorez on 21/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var upperText: String = ""

    let xpcClient: XPCClientProtocol

    var body: some View {
        VStack {
     
            TextField("Enter a text...", text: $inputText)
                .textFieldStyle(.plain)
                .font(.system(size: 50))
                .background(Color("Accent"))
                .multilineTextAlignment(.center)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                )
                .padding()
            HStack {
                Spacer()
                Button("Uppercase it!") {
                    xpcClient.uppercase(for: inputText) { result in
                        DispatchQueue.main.async {
                            upperText = result
                        }
                    }
                }
                .buttonStyle(.plain)
                .font(.system(size: 20))
                .padding()
                .background(.mint)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 1)
                        .foregroundColor(.red)
                )
                .padding()
                
                Spacer()

                if upperText.count > 0 {
                    HStack {
                        Label("Result:", systemImage: "bolt.fill")
                            .font(.system(size: 30))
                            .labelStyle(.iconOnly)
                        Text(upperText)
                            .font(.system(size: 30))
                            .padding()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mockedXPC = MockedXPCCLient()
        ContentView(xpcClient: mockedXPC)
    }
}
