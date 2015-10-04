//
//  BlueNinjaSensor.swift
//
//  Created by yoshihiko on 2015/10/03.
//  Copyright © 2015年 goodmix. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BlueNinjaSensorDelegate: class {
    func update()
    func updateGyro(data:Dictionary<String,Double>)
    func updateAcceleration(data:Dictionary<String,Double>)
    func updateMagnetic(data:Dictionary<String,Double>)
    func updateAirPressure(data:Dictionary<String,Double>)
}

class BlueNinjaSensor: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    //デバイス名
    let DEVICE_NAME = "CDP-TZ01B"
    //BlueNinja Example Service
    let UUID_SERVICE_BNEXAM = CBUUID(string: "D43A0200-0E5F-4A80-9182-5F82FF67E8F8");
    //ジャイロセンサー
    let UUID_CHARACTERISTIC_GYRO = CBUUID(string: "D43A0201-0E5F-4A80-9182-5F82FF67E8F8");
    //加速度センサー
    let UUID_CHARACTERISTIC_ACCEL = CBUUID(string: "D43A0202-0E5F-4A80-9182-5F82FF67E8F8");
    //地磁気センサー
    let UUID_CHARACTERISTIC_MAGM = CBUUID(string: "D43A0203-0E5F-4A80-9182-5F82FF67E8F8");
    //気圧センサー
    let UUID_CHARACTERISTIC_AIRP = CBUUID(string: "D43A0212-0E5F-4A80-9182-5F82FF67E8F8");
    
    //Data
    var gyro = Dictionary<String,Double>()
    var acceleration = Dictionary<String,Double>()
    var magnetic = Dictionary<String,Double>()
    var airpressure = Dictionary<String,Double>()

    //CoreBluetooth
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var services: NSArray!
    
    //Delegate
    weak var delegate: BlueNinjaSensorDelegate? = nil
    
    //flag
    var printLog = false
    
    
    // MARK: - Class
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        
        printLog = false
    }
    
    func connect(){
        self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func disconnect(){
        self.centralManager.cancelPeripheralConnection(self.peripheral)
    }
    
    // MARK: - CoreBluetoothDelegate
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if printLog == true {
            print("BlueNinjaSensoer state: \(central.state)\n")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        //print("peripheral: \(peripheral)")
        
        if peripheral.name == self.DEVICE_NAME {
            if printLog == true {
                print("BlueNinjaSensoer discover: \(peripheral.name)\n")
            }
            
            self.peripheral = peripheral;
            
            self.centralManager.connectPeripheral(self.peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        if printLog == true {
            print("BlueNinjaSensoer connected\n")
        }
        
        self.peripheral.delegate = self
        self.peripheral.discoverServices(nil)
        
        self.centralManager.stopScan()
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        if printLog == true {
            print("BlueNinjaSensoer fail to connect\n")
        }
    }
    
    // MARK: - CBPeripheralDelegate
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error != nil {
            print("error: \(error)\n")
            return
        }
        
        //print("found \(peripheral.services!.count) services :\(peripheral.services)\n")
        
        for service in peripheral.services! {
            if service.UUID == UUID_SERVICE_BNEXAM {
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if error != nil {
            print("error: \(error)\n")
            return
        }
        
        //print("found \(service.characteristics!.count) characteristics! : \(service.characteristics)\n")
        
        for characteristic in service.characteristics! {
            peripheral.setNotifyValue(true, forCharacteristic: characteristic)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil {
            print("error: \(error)\n")
            return
        }
        
        //print("succeeded! service uuid: \(characteristic.service.UUID), characteristic uuid: \(characteristic.UUID), value: \(characteristic.value)")
        
        var valueString:String = ""
        
        switch characteristic.UUID{
        case UUID_CHARACTERISTIC_GYRO:
            //ジャイロセンサー
            valueString = String(data: characteristic.value!, encoding: NSUTF8StringEncoding)!
            //print(valueString)
            
            valueString = valueString.stringByReplacingOccurrencesOfString("{", withString: "")
            valueString = valueString.stringByReplacingOccurrencesOfString("}", withString: "")
            
            let gyroArray = valueString.componentsSeparatedByString(",")
            for gyroData in gyroArray{
                let gyroKeyValueArray = gyroData.componentsSeparatedByString(":")
                let gyroKey:String = gyroKeyValueArray[0]
                let gyroValue:Double = atof(gyroKeyValueArray[1])
                gyro[gyroKey] = gyroValue
            }
            
            delegate?.updateGyro(gyro)
            delegate?.update()
            
            break;
        case UUID_CHARACTERISTIC_ACCEL:
            //加速度センサー
            valueString = String(data: characteristic.value!, encoding: NSUTF8StringEncoding)!
            //print(valueString)
            
            valueString = valueString.stringByReplacingOccurrencesOfString("{", withString: "")
            valueString = valueString.stringByReplacingOccurrencesOfString("}", withString: "")
            
            let accelArray = valueString.componentsSeparatedByString(",")
            for accelData in accelArray{
                let accelKeyValueArray = accelData.componentsSeparatedByString(":")
                let accelKey:String = accelKeyValueArray[0]
                let accelValue:Double = atof(accelKeyValueArray[1])
                acceleration[accelKey] = accelValue
            }
            
            delegate?.updateAcceleration(acceleration)
            delegate?.update()
            
            break;
        case UUID_CHARACTERISTIC_MAGM:
            //地磁気センサー
            valueString = String(data: characteristic.value!, encoding: NSUTF8StringEncoding)!
            //print(valueString)
            
            valueString = valueString.stringByReplacingOccurrencesOfString("{", withString: "")
            valueString = valueString.stringByReplacingOccurrencesOfString("}", withString: "")
            
            let magmArray = valueString.componentsSeparatedByString(",")
            for magmData in magmArray{
                let magmKeyValueArray = magmData.componentsSeparatedByString(":")
                let magmKey:String = magmKeyValueArray[0]
                let magmValue:Double = atof(magmKeyValueArray[1])
                magnetic[magmKey] = magmValue
            }
            
            delegate?.updateMagnetic(magnetic)
            delegate?.update()
            
            break;
        case UUID_CHARACTERISTIC_AIRP:
            //気圧センサー
            valueString = String(data: characteristic.value!, encoding: NSUTF8StringEncoding)!
            //print(valueString)
            
            valueString = valueString.stringByReplacingOccurrencesOfString("{", withString: "")
            valueString = valueString.stringByReplacingOccurrencesOfString("}", withString: "")
            
            let airpArray = valueString.componentsSeparatedByString(",")
            for airpData in airpArray{
                let airpKeyValueArray = airpData.componentsSeparatedByString(":")
                let airpKey:String = airpKeyValueArray[0]
                let airpValue:Double = atof(airpKeyValueArray[1])
                airpressure[airpKey] = airpValue
            }
            
            delegate?.updateAirPressure(airpressure)
            delegate?.update()
            
            break;
        default:
            break;
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil {
            print("error: \(error)\n")
            return
        }
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        if error != nil {
            print("error: \(error)\n")
            return
        }
        
        if printLog == true {
            print("BlueNinjaSensoer disconnect\n")
        }
    }
}