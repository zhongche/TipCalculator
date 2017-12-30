//
//  ViewController.swift
//  TipCalculator
//
//  Created by Paul Hong on 12/7/17.
//  Copyright © 2017 Paul Hong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipList: UISegmentedControl!
    @IBOutlet weak var percentageField: UITextField!
    @IBOutlet weak var customField: UITextField!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupSlider: UISlider!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var numPeopleLabel: UILabel!
    @IBOutlet weak var eachLabel: UILabel!
    @IBOutlet weak var eachLabel2: UILabel!
    
    var tipAmount = 0.00
    lazy var bill2 = Double(billField.text!) ?? 0
    lazy var total = 0.00
    let viewWin = UIView()
    lazy var tempSwitch = createSwitch
    var holder = 0.00
    
    let viewSett: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 96/255, green: 72/255, blue: 60/255, alpha: 1)
        return collectionView
    }()
    
    let someText: UITextField = {
        let labelText = UITextField(frame: CGRect(x: 10, y: 14, width: 150, height: 30))
        labelText.text = "Split Option"
        labelText.isEnabled = false
        return labelText
    }()
   
    let createSwitch: UISwitch = {
        let mySwitch = UISwitch(frame: CGRect(x: 250, y: 12, width: 0, height: 0))
        mySwitch.tintColor = UIColor(red: 75/255, green: 48/255, blue: 41/255, alpha: 1)
        mySwitch.onTintColor = UIColor(red: 150/255, green: 100/255, blue: 67/255, alpha: 1)
        mySwitch.thumbTintColor = UIColor(red: 252/255, green: 244/255, blue: 232/255, alpha: 1)
        mySwitch.addTarget(self, action: #selector(displaySplit), for: UIControlEvents.editingChanged)
        return mySwitch
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 144/255, green: 122/255, blue: 108/255, alpha: 1)
        groupLabel.isHidden = true
        groupSlider.isHidden = true
        hideLabels(hide: true)
        navBarButton()
    }
    
    func hideLabels(hide: Bool){
        peopleLabel.isHidden = hide
        numPeopleLabel.isHidden = hide
        eachLabel.isHidden = hide
        eachLabel2.isHidden = hide
    }
    
    func navBarButton() {
        let logo = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        let logoButton = UIBarButtonItem(image: logo, style: .plain, target: self, action: #selector(handlerLogo))
        
        let settingImage = UIImage(named: "Setting")?.withRenderingMode(.alwaysOriginal)
        let settingButton = UIBarButtonItem(image: settingImage, style: .plain, target: self, action: #selector(handlerSetting))
        
        navigationItem.rightBarButtonItems = [settingButton, logoButton]
    }
    
    @objc func handlerLogo() {
        billField.text = nil
        percentageField.text = nil
        customField.text = nil
        tipLabel.text = "$0.00"
        eachLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        total = 0.00
        holder = 0.00
        tipAmount = 0.00
        bill2 = 0.00
    }
    
    @objc func handlerSetting(){
        onTap((Any).self)
        if let appWin = UIApplication.shared.keyWindow {
            viewWin.backgroundColor = UIColor(white:0, alpha:0.5)
            viewWin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissWin)))
            appWin.addSubview(viewWin)
            appWin.addSubview(viewSett)
            let y = (self.navigationController?.navigationBar.frame.size.height)! + 18
            viewSett.frame = CGRect(x: 0, y: 0, width: appWin.frame.width, height: 60)
            viewWin.frame = appWin.frame
            viewWin.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.viewWin.alpha = 1
                self.viewSett.frame = CGRect(x: 0, y: y, width: self.viewSett.frame.width, height: self.viewSett.frame.height
                )
                self.viewSett.addSubview(self.someText)
                self.viewSett.addSubview(self.tempSwitch)
            }, completion: nil)
            
        }
    }
    
    @objc func dismissWin(){
        UIView.animate(withDuration: 0.5, animations: {self.viewWin.alpha = 0})
        if let appWin = UIApplication.shared.keyWindow {
            self.viewSett.frame = CGRect(x: 0, y: appWin.frame.height, width: self.viewSett.frame.width, height: self.viewSett.frame.height)
            self.displaySplit(sender: tempSwitch)
        }
    }
    
    @objc func displaySplit(sender: UISwitch){
        if sender.isOn {
            groupLabel.isHidden = false
            groupSlider.isHidden = false
        }
        
        else{
            groupLabel.isHidden = true
            groupSlider.isHidden = true
            hideLabels(hide: true)
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printLabels(){
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func onTapBill(_ sender: Any) {
        tipList.selectedSegmentIndex = 0
        calculateTip((Any).self)
    }
    
    
    @IBAction func calculateTip(_ sender: Any) {
        let tipArray = [0.10, 0.15, 0.18]
        let bill = Double(billField.text!) ?? 0
        bill2 = bill
        tipAmount = bill * tipArray[tipList.selectedSegmentIndex]
        total = bill + tipAmount
        printLabels()
        customField.text = ""
        percentageField.text = ""
        groupSlider((Any).self)
    }
    
    @IBAction func updateTip(_ sender: Any) {
        let percentages = Double(percentageField.text!) ?? 0
        tipAmount = Double(bill2 * percentages)/100
        total = bill2 + tipAmount
        printLabels()
        customField.text = ""
        tipList.selectedSegmentIndex = -1
        groupSlider((Any).self)
        holder = total
    }
    
    @IBAction func customTips(_ sender: Any) {
        tipAmount = Double(customField.text!) ?? 0
        total = bill2 + tipAmount
        printLabels()
        percentageField.text = ""
        tipList.selectedSegmentIndex = -1
        groupSlider((Any).self)
        holder = total
    }
    
    @IBAction func groupSlider(_ sender: Any) {
        
        let group = Int(groupSlider.value)
        
        if group != 1 {
            hideLabels(hide: false)
            peopleLabel.text = "\(group)"
            eachLabel.text = String(format: "$%.2f", total/Double(group))
        }
            
        else {
            hideLabels(hide: true)
        }
    }
    
}

