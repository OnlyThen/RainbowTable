//
//  ViewController.swift
//  RainbowTable
//
//  Created by 张瑜 on 2018/5/4.
//  Copyright © 2018年 张瑜. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lengthOfChain: UITextField!
    
    @IBOutlet weak var numberOfChain: UITextField!
    
    @IBOutlet weak var numberOfString: UITextField!
    
    @IBOutlet weak var stringOfHash: UITextField!
    
    @IBOutlet weak var crackLength: UITextField!
    
    //var pickerData: [String] = [String]()
    
    //var score: Int = 0
    var pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view, typically from a nib.
        //tablePicker.dataSource = self
        //tablePicker.delegate = self
        
        
    }
    
    @IBAction func startGenerate(_ sender: Any) {
        
        let chains: Int = Int(numberOfChain.text!)!
        let length: Int = Int(lengthOfChain.text!)!
        let strings: Int = Int(numberOfString.text!)!
        
        for index in 0 ..< chains {
            let chain = Rainbow.shareInstance().generateChain(lengthOfChain: length, lengthOfString: strings, id: index)
            let insertSQL = "INSERT INTO 'RAINBOWTABLE' (ID, START, END) VALUES ('\(chain.id)', '\(chain.start)', '\(chain.end)');"
            if SQLiteManager.shareInstance().execSQL(SQL: insertSQL) == true {
                print("插入数据add成功")
            }
        }
        
        let ac = UIAlertController(title: "Well done!", message: "complete", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        present(ac, animated: true)
        
        let selectSQL1 = "SELECT END from 'RAINBOWTABLE' WHERE ID = 1;"
        let resultData = SQLiteManager.shareInstance().queryDataBase(querySQL: selectSQL1)
        print(resultData ?? "No" )
        let selectSQL2 = "SELECT END from 'RAINBOWTABLE' WHERE ID = 14;"
        let resultData2 = SQLiteManager.shareInstance().queryDataBase(querySQL: selectSQL2)
        print(resultData2 ?? "No" )
    }
    
    
    @IBAction func startCrack(_ sender: Any) {
        
        //let chains: Int = Int(numberOfChain.text!)!
        //let length: Int = Int(lengthOfChain.text!)!
        //let strings: Int = Int(numberOfString.text!)!
        
        let hash: String = stringOfHash.text!
        let length: Int = Int(crackLength.text!)!
       
        for firstStep in (0 ..< length).reversed() {
            var tempString: String = ""
            var tempHash: String = hash
            for step in firstStep ..< length {
                tempString = Rainbow.shareInstance().reduce(hash: tempHash, step: step, lengthOfString: 3, count: 36, seedOfReduce: 0)
                tempHash = tempString.md5()
            }
            let selectSQL = "SELECT START from 'RAINBOWTABLE' WHERE END = '\(tempString)';"
            if let resultData = SQLiteManager.shareInstance().queryDataBase(querySQL: selectSQL) {
                print(resultData)
                tempString = resultData
                
                for step in 0 ..< firstStep {
                    tempHash = tempString.md5()
                    tempString = Rainbow.shareInstance().reduce(hash: tempHash, step: step, lengthOfString: 3, count: 36, seedOfReduce: 0)
                    
                }
                
                if tempString.md5() == hash {
                    print("result: \(tempString)")
                    let ac = UIAlertController(title: "Result is", message: tempString, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                    present(ac, animated: true)
                    break
                }
            }
            /*
            print(resultData ?? "No" )
            
            tempString = resultData!
            
            for step in 0 ..< firstStep {
                tempHash = tempString.md5()
                tempString = Rainbow.shareInstance().reduce(hash: tempHash, step: step, lengthOfString: 3, count: 36, seedOfReduce: 0)
                
            }
            
            if tempString.md5() == hash {
                print("result: \(tempString )")
            }
            */
        }
        
        
        //var stuArr: [String] = []
        //for dict in (resultDataArr)! {
        
        //}
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

