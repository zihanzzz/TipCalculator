//
//  TipViewController.swift
//  TipCalculator
//
//  Created by James Zhou on 9/21/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit
import SnapKit

class TipViewController: UIViewController, UITextFieldDelegate {
    
    let billingAndPercentageView = UIView()
    
    var billingAmountTextField = UITextField()
    
    var tipPercentageLabel = UILabel()
    
    var billAmount:Double = 0
    
    var tipPercentage:Double = 0
    
    var tipAmount:Double = 0
    
    var totalAmount:Double = 0
    
    let calculationView = UIView()
    
    let transparentView = UIView()
    
    let plusSignLabel = UILabel()
    
    let equalSignLabel = UILabel()
    
    let tipAmountLabel = UILabel()
    
    let totalAmountLabel = UILabel()
    
    var keyboardTopY:CGFloat = 0
    
    var navBottomHeight: CGFloat = 0
    
    var calculationState = false
    
    var startingPercentage:Int = 0
    
    override func viewDidAppear(_ animated: Bool) {
        billingAmountTextField.becomeFirstResponder()
        if (calculationState) {
            setUpCalculation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.calculationView)
        self.view.addSubview(self.transparentView)
        self.calculationView.addSubview(self.plusSignLabel)
        self.calculationView.addSubview(self.equalSignLabel)
        self.calculationView.addSubview(self.tipAmountLabel)
        self.calculationView.addSubview(self.totalAmountLabel)
        
        // gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer()
        self.transparentView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(self, action: #selector(amountSwiped))
        
        // Keyboard observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:.UIKeyboardWillShow, object: nil)
        
        // Exit observer
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = TipConstants.greenColor
        
        self.navigationController?.navigationBar.titleTextAttributes = TipConstants.titleTextDict
        self.title = TipConstants.titleString
        
        let rightBarButtonItem = UIBarButtonItem(title: TipConstants.settingsString, style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        
        rightBarButtonItem.setTitleTextAttributes(TipConstants.nagivationTextDict, for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        self.view.backgroundColor = UIColor.white
        
        navBottomHeight = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height
        
        // billingAndPercentageView
        self.view.addSubview(billingAndPercentageView)
        
        self.billingAndPercentageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(navBottomHeight)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        // billingAmountTextField
        self.view.addSubview(billingAmountTextField)
        
        let screenWidth = UIScreen.main.bounds.width
        self.billingAmountTextField.frame = CGRect(x: 25, y: navBottomHeight, width: screenWidth - 50, height: 250)
        self.billingAmountTextField.adjustsFontSizeToFitWidth = true
        self.billingAmountTextField.textAlignment = NSTextAlignment.right
        self.billingAmountTextField.textColor = UIColor.black
        self.billingAmountTextField.tintColor = UIColor.gray
        self.billingAmountTextField.font = UIFont.init(name: TipConstants.textFontName, size: 60)
        self.billingAmountTextField.placeholder = TipConstants.getCurrencyString(string: "0.00")
        self.billingAmountTextField.keyboardType = UIKeyboardType.decimalPad
        self.billingAmountTextField.keyboardAppearance = UIKeyboardAppearance.dark
        self.billingAmountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.billingAmountTextField.delegate = self
        
        // date
        let defaults = UserDefaults.standard
        self.keyboardTopY = CGFloat(defaults.float(forKey: "keyboardHeight"))
        if let oldDate = defaults.object(forKey: "lastDate") {
            let currentDate = Date()
            let elapsedTime = currentDate.timeIntervalSince(oldDate as! Date)
            if (elapsedTime <= 6000) {
                let lastAmount = defaults.double(forKey: "lastAmount")
                if (lastAmount > 0) {
                    setUpCalculation()
                    self.billAmount = lastAmount
                    self.tipPercentage = defaults.double(forKey: "lastPercentage")
                    self.tipAmount = self.billAmount * self.tipPercentage
                    self.totalAmount = self.billAmount + self.tipAmount
                    refreshAmountLabels(tipAmount: self.tipAmount, totalAmount: self.totalAmount)
                    self.billingAmountTextField.text = String(format: "%.2f", lastAmount)
                }
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func rightBarButtonItemClicked() {
        let settingsTVC = SettingsTableViewController()
        navigationController?.pushViewController(settingsTVC, animated: true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardTopY = frame.origin.y
        let defaults = UserDefaults.standard
        defaults.set(self.keyboardTopY, forKey: "keyboardHeight")
        defaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Text Methods
    func textFieldDidChange(_ textField: UITextField) {
        
        let currentText = textField.text!
        if (calculationState && currentText.characters.count == 0) {
            restoreCalculation()
        }
        
        if (!calculationState && currentText.characters.count > 0) {
            setUpCalculation()
        }
        
        self.billAmount = Double(currentText) ?? 0
        self.tipAmount = self.billAmount * self.tipPercentage
        self.totalAmount = self.billAmount + self.tipAmount
        
        refreshAmountLabels(tipAmount: self.tipAmount, totalAmount: self.totalAmount)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = textField.text! + string
        let newBillAmount = Double(newString) ?? 0
        
        if (newString.characters.count >= 12) {
            return false
        }
        
        if (newBillAmount == 0) {
            return false
        } else {
            self.billAmount = newBillAmount
            return true
        }
    }
    
    // MARK: - UI Manipulations
    func restoreCalculation() {
        calculationState = false
        
        var percentageFrame = self.billingAndPercentageView.frame
        percentageFrame.size.height = 300
        self.billingAndPercentageView.frame = percentageFrame
        self.billingAndPercentageView.backgroundColor = UIColor.white
        
        var textFrame = self.billingAmountTextField.frame
        let newHeight_t = CGFloat(250)
        textFrame.size.height = newHeight_t
        self.billingAmountTextField.frame = textFrame
        
        self.tipPercentageLabel.removeFromSuperview()
        self.calculationView.isHidden = true
        self.transparentView.isHidden = true
    }
    
    func setUpCalculation() {
        calculationState = true
        
        // Tip Percentage
        let defaults = UserDefaults.standard
        self.tipPercentage = Double(defaults.integer(forKey: "default")) / 100
        
        var percentageFrame = self.billingAndPercentageView.frame
        let newHeight_p = CGFloat((self.keyboardTopY - self.navBottomHeight) * 0.6)
        percentageFrame.size.height = newHeight_p
        self.billingAndPercentageView.frame = percentageFrame
        self.billingAndPercentageView.backgroundColor = TipConstants.blueColor
        
        var textFrame = self.billingAmountTextField.frame
        let newHeight_t = CGFloat(newHeight_p * 0.5)
        textFrame.size.height = newHeight_t
        self.billingAmountTextField.frame = textFrame
        
        let screenWidth = UIScreen.main.bounds.width
        self.billingAndPercentageView.addSubview(self.tipPercentageLabel)
        self.tipPercentageLabel.frame = CGRect(x: screenWidth * 0.7, y: newHeight_t, width: screenWidth * 0.3, height: newHeight_t)
        
        self.tipPercentageLabel.text = String(format: "%.0f", self.tipPercentage * 100) + "%"
        self.tipPercentageLabel.font = UIFont.init(name: TipConstants.textFontName, size: 35)
        self.tipPercentageLabel.textAlignment = .center
        self.tipPercentageLabel.textColor = UIColor.gray
        
        
        self.calculationView.isHidden = false
        self.calculationView.frame = CGRect(x: 0, y: self.navBottomHeight + newHeight_p, width: screenWidth, height: (self.keyboardTopY - self.navBottomHeight) * 0.4)
        self.calculationView.backgroundColor = UIColor.yellow
        
        self.transparentView.isHidden = false
        self.transparentView.frame = CGRect(x: 0, y: self.navBottomHeight + newHeight_p, width: screenWidth, height: (self.keyboardTopY - self.navBottomHeight) * 0.4)
        self.transparentView.backgroundColor = UIColor.clear
        
        
        self.plusSignLabel.isHidden = false
        self.plusSignLabel.frame = CGRect(x: screenWidth * 0.0, y: 0, width: screenWidth * 0.20, height: screenWidth * 0.20)
        self.plusSignLabel.text = "+"
        self.plusSignLabel.textAlignment = .center
        self.plusSignLabel.textColor = UIColor.gray
        self.plusSignLabel.font = UIFont.init(name: TipConstants.textFontName, size: 50)
        
        self.equalSignLabel.isHidden = false
        self.equalSignLabel.frame = CGRect(x: screenWidth * 0.0, y: self.calculationView.frame.height * 0.5, width: screenWidth * 0.2, height: screenWidth * 0.2)
        self.equalSignLabel.text = "="
        self.equalSignLabel.textAlignment = .center
        self.equalSignLabel.textColor = UIColor.gray
        self.equalSignLabel.font = UIFont.init(name: TipConstants.textFontName, size: 50)
        
        self.tipAmountLabel.isHidden = false
        self.tipAmountLabel.frame = CGRect(x: screenWidth * 0.2, y: 0, width: screenWidth * 0.7, height: self.calculationView.frame.height * 0.5)
        self.tipAmountLabel.textAlignment = .right
        self.tipAmountLabel.textColor = UIColor.gray
        self.tipAmountLabel.font = UIFont.init(name: TipConstants.textFontName, size: 40)
        self.tipAmountLabel.adjustsFontSizeToFitWidth = true
        
        self.totalAmountLabel.isHidden = false
        self.totalAmountLabel.frame = CGRect(x: screenWidth * 0.2, y: self.calculationView.frame.height * 0.5, width: screenWidth * 0.7, height: self.calculationView.frame.height * 0.5)
        self.totalAmountLabel.textAlignment = .right
        self.totalAmountLabel.textColor = UIColor.gray
        self.totalAmountLabel.font = UIFont.init(name: TipConstants.textFontName, size: 40)
        self.totalAmountLabel.adjustsFontSizeToFitWidth = true
    }
    
    func amountSwiped(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.transparentView)
        
        let defaults = UserDefaults.standard
        //        let defaultValue = defaults.integer(forKey: "default")
        let minValue = defaults.integer(forKey: "min")
        let maxValue = defaults.integer(forKey: "max")
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            self.startingPercentage = Int(self.tipPercentage * 100)
            break
        case UIGestureRecognizerState.changed:
            var newP = self.startingPercentage + Int(translation.x / 20)
            
            if (newP > maxValue) {
                newP = maxValue
            } else if (newP < minValue) {
                newP = minValue
            }
            
            updateCalculation(percentage: newP)
            
            break
        default:
            break
        }
    }
    
    func updateCalculation(percentage: Int) {
        self.tipPercentageLabel.text = String(format: "%d", percentage) + "%"
        let bill = Double(self.billingAmountTextField.text!) ?? 0
        let tip = bill * Double(percentage) / 100
        let total = bill + tip
        refreshAmountLabels(tipAmount: tip, totalAmount: total)
        self.tipPercentage = Double(percentage) / 100
    }
    
    func refreshAmountLabels(tipAmount:Double, totalAmount:Double) {
        self.tipAmountLabel.text = TipConstants.getCurrencyString(string: String(tipAmount))
        self.totalAmountLabel.text = TipConstants.getCurrencyString(string: String(totalAmount))
    }
    
    func appMovedToBackground() {
        if (self.billAmount > 0) {
            let defaults = UserDefaults.standard
            defaults.set(self.billAmount, forKey: "lastAmount")
            defaults.set(self.tipPercentage, forKey: "lastPercentage")
            let currentDate = Date()
            defaults.set(currentDate, forKey: "lastDate")
            defaults.synchronize()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
