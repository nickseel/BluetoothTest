//
//  TargetPeripheral.swift
//  BluetoothTest
//
//  Created by Nick Seel on 5/29/21.
//

import Foundation
import CoreBluetooth

class TargetPeripheral: NSObject {
    public static let serviceUUID           = CBUUID.init(string: "00112233-4455-6677-8899-aabbccddeeff")
    public static let characteristicUUID    = CBUUID.init(string: "00010203-0405-0607-0809-0a0b0c0d0e0f")
    //public static let serviceUUID           = CBUUID.init(string: "00112233445566778899aabbccddeeff")
    //public static let characteristicUUID    = CBUUID.init(string: "000102030405060708090a0b0c0d0e0f")
}
