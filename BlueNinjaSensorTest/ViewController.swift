//
//  ViewController.swift
//  BlueNinjaSensorTest
//
//  Created by yoshihiko on 2015/10/03.
//  Copyright © 2015年 goodmix. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BlueNinjaSensorDelegate{
    
    @IBOutlet weak var startScanButton: UIButton!
    @IBOutlet weak var stopScanButton: UIButton!
    
    @IBOutlet weak var gx: UILabel!
    @IBOutlet weak var gy: UILabel!
    @IBOutlet weak var gz: UILabel!
    @IBOutlet weak var ax: UILabel!
    @IBOutlet weak var ay: UILabel!
    @IBOutlet weak var az: UILabel!
    @IBOutlet weak var mx: UILabel!
    @IBOutlet weak var my: UILabel!
    @IBOutlet weak var mz: UILabel!
    @IBOutlet weak var ap: UILabel!
    
    var bns = BlueNinjaSensor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bns.delegate = self
        bns.printLog = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    @IBAction func touchStartButton(){
        bns.connect()
    }
    
    @IBAction func touchDisconnect(){
        bns.disconnect()
    }
    
    // MARK: - BlueNinjaSensorDelegate
    func update() {
        
    }
    func updateGyro(data: Dictionary<String, Double>) {
        //print(data)
        let gxValue:Double = data["gx"]!
        let gyValue:Double = data["gy"]!
        let gzValue:Double = data["gz"]!
        gx.text = String("\(gyValue)")
        gy.text = String("\(gxValue)")
        gz.text = String("\(gzValue)")
    }
    
    func updateAcceleration(data: Dictionary<String, Double>) {
        //print(data)
        let axValue:Double = data["ax"]!
        let ayValue:Double = data["ay"]!
        let azValue:Double = data["az"]!
        ax.text = String("\(ayValue)")
        ay.text = String("\(axValue)")
        az.text = String("\(azValue)")
    }
    
    func updateMagnetic(data: Dictionary<String, Double>) {
        //print(data)
        let mxValue:Double = data["mx"]!
        let myValue:Double = data["my"]!
        let mzValue:Double = data["mz"]!
        mx.text = String("\(myValue)")
        my.text = String("\(mxValue)")
        mz.text = String("\(mzValue)")
    }
    
    func updateAirPressure(data: Dictionary<String, Double>) {
        //print(data)
        let apValue:Double = data["ap"]!
        ap.text = String("\(apValue)")
    }
}

