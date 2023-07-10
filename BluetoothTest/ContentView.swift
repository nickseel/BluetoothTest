//
//  ContentView.swift
//  BluetoothTest
//
//  Created by Nick Seel on 5/29/21.
//

import SwiftUI

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}

struct ContentView: View {
    @ObservedObject var bleManager = BLEManager()
    
    @State var slider1 = 0.0
    @State var slider2 = 0.0
    @State var slider3 = 0.0
    @State var slider4 = 0.0
    @State var slider5 = 0.0
    @State var message = Data([0,0,0,0,0])
    
    @State var sendMessageOnChange = false
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Slider(value: Binding(get: {
                    slider1
                }, set: { (newVal) in
                    slider1 = newVal
                    messageChanged()
                }),
                in: 0...99,
                step: 1)
                Text("\(Int(slider1)), 0x\(String(format:"%02X", Int(slider1)))")
            }
            VStack {
                Slider(value: Binding(get: {
                    slider2
                }, set: { (newVal) in
                    slider2 = newVal
                    messageChanged()
                }),
                in: 0...99,
                step: 1)
                Text("\(Int(slider2)), 0x\(String(format:"%02X", Int(slider2)))")
            }
            VStack {
                Slider(value: Binding(get: {
                    slider3
                }, set: { (newVal) in
                    slider3 = newVal
                    messageChanged()
                }),
                in: 0...99,
                step: 1)
                Text("\(Int(slider3)), 0x\(String(format:"%02X", Int(slider3)))")
            }
            VStack {
                Slider(value: Binding(get: {
                    slider4
                }, set: { (newVal) in
                    slider4 = newVal
                    messageChanged()
                }),
                in: 0...99,
                step: 1)
                Text("\(Int(slider4)), 0x\(String(format:"%02X", Int(slider4)))")
            }
            VStack {
                Slider(value: Binding(get: {
                    slider5
                }, set: { (newVal) in
                    slider5 = newVal
                    messageChanged()
                }),
                in: 0...99,
                step: 1)
                Text("\(Int(slider5)), 0x\(String(format:"%02X", Int(slider5)))")
            }
            Spacer()
            Button(action: {sendMessageOnChange = !sendMessageOnChange}){
               HStack{
                  Image(systemName: sendMessageOnChange ? "checkmark.square" : "square")
                  Text("Send message on slider change")
               }
            }
            .padding(20)
            if !bleManager.bleEnabled {
                Text("Bluetooth is not enabled")
                    .foregroundColor(.red)
            }
            else {
                if !bleManager.connected {
                    Text("Scanning for device...")
                        .foregroundColor(.blue)
                }
                else {
                    Button {
                        bleManager.write(value: message)
                    } label: {
                        Text("Write \"0x\(message.hexEncodedString())\"")
                    }
                    .contentShape(Rectangle())
                    .padding(20)
                }
            }
            Spacer()
        }.padding()
    }
    
    func messageChanged() {
        message = Data([UInt8(slider1), UInt8(slider2), UInt8(slider3), UInt8(slider4), UInt8(slider5)])
        
        if(sendMessageOnChange) {
            bleManager.write(value: message)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

