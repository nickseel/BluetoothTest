//
//  BLEManager.swift
//  BluetoothTest
//
//  Created by Nick Seel on 5/29/21.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    
    @Published var bleEnabled = false
    @Published var connected = false
    
    var char: CBCharacteristic?
    
    override init() {
        super.init()

        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
        print(CBAdvertisementDataServiceUUIDsKey)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            bleEnabled = false
        } else {
            //print("Central scanning for", TargetPeripheral.serviceUUID);
            bleEnabled = true
            centralManager.scanForPeripherals(withServices: nil,
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //if RSSI.decimalValue < -70 || RSSI.decimalValue == 127 { return }
        
        print("Discovered peripheral: \(peripheral.name ?? "Unnamed") RSSI=\(RSSI.decimalValue)")
        
        if peripheral.name != nil && peripheral.name == "RN4871-70E8" {
            //for (key, value) in advertisementData {
              //  print("    " + key)
                //if(key == TargetPeripheral.serviceUUID.uuidString) {
            print("Discovered target peripheral: \(peripheral.name ?? "Unnamed")")
                    
                    self.centralManager.stopScan()

                    self.peripheral = peripheral
                    self.peripheral.delegate = self
                    
                    self.centralManager.connect(self.peripheral, options: nil)
                //}
            //}
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to peripheral")
            peripheral.discoverServices([TargetPeripheral.serviceUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let e = error {
            print("ERROR: \(e)")
        }
        if peripheral == self.peripheral {
            connected = false
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let e = error {
            print("ERROR: \(e)")
        }
        if let services = peripheral.services {
            for service in services {
                if service.uuid == TargetPeripheral.serviceUUID {
                    print("Service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([TargetPeripheral.characteristicUUID], for: service)
                    return
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let e = error {
            print("ERROR: \(e)")
        }
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Discovered characteristic: \(characteristic.uuid)")
                if characteristic.uuid == TargetPeripheral.characteristicUUID {
                    //print("Discovered target characteristic")
                    char = characteristic
                    connected = true
                    //fun()
                }
            }
        }
    }
    
    func write(value: Data) {
        if let characteristic = char {
            print("Writing value 0x\(value.hexEncodedString())")
            peripheral.writeValue(value, for: characteristic, type: .withResponse)
        }
    }
    
    func fun() {
        for i in 0...15 {
            let c = UInt8(i*17)
            write(value: Data([c,c,c,c,c]))
        }
    }
}
