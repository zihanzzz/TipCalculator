//
//  SettingsTableViewController.swift
//  TipCalculator
//
//  Created by James Zhou on 9/22/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.navigationBar.titleTextAttributes = TipConstants.titleTextDict
        self.title = TipConstants.settingsString
        
        let leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(leftBarButtonItemClicked))
        leftBarButtonItem.setTitleTextAttributes(TipConstants.nagivationTextDict, for: .normal)
        
        let rightBarButtonItem = UIBarButtonItem(title: "v1.2", style: .plain, target: self, action: nil)
        
        rightBarButtonItem.setTitleTextAttributes(TipConstants.nagivationTextDict, for: .normal)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.view.backgroundColor = UIColor.white
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.tableFooterView = UIView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func leftBarButtonItemClicked() {
        _ = navigationController?.popViewController(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0) {
            return 3
        } else if (section == 1) {
            return 1
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        if (indexPath.section == 0) {
            
            let screenWidth = UIScreen.main.bounds.width
            
            let modeLabel = UILabel()
            cell.contentView.addSubview(modeLabel)
            modeLabel.snp.makeConstraints({ (make) -> Void in
                make.top.equalToSuperview()
                make.height.equalToSuperview()
                make.left.equalToSuperview()
                make.width.equalTo(screenWidth * 0.5)
            })
            
            modeLabel.font = UIFont.init(name: TipConstants.textFontName, size: 20)
            modeLabel.textAlignment = .center
            modeLabel.backgroundColor = UIColor.lightGray
            
            
            let textField = UITextField()
            cell.contentView.addSubview(textField)
            textField.snp.makeConstraints({ (make) -> Void in
                make.top.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(screenWidth * 0.5 - 25)
                make.left.equalTo(screenWidth * 0.5)
            })

            textField.placeholder = "%"
            textField.textAlignment = .right
            textField.keyboardType = .numberPad
            textField.keyboardAppearance = .dark
            textField.font = UIFont.init(name: TipConstants.textFontName, size: 25)
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textField.delegate = self
            
            let defaults = UserDefaults.standard
        
            
            switch indexPath.row {
            case 0:
                modeLabel.text = "Default"
                textField.text = String(format: "%d", defaults.integer(forKey: "default"))
                textField.tag = 0
                break
            case 1:
                modeLabel.text = "Minimum"
                textField.text = String(format: "%d", defaults.integer(forKey: "min"))
                textField.tag = 1
                break
            case 2:
                modeLabel.text = "Maximum"
                textField.text = String(format: "%d", defaults.integer(forKey: "max"))
                textField.tag = 2
                break
            default:
                break
            }
        } else if (indexPath.section == 1) {
            
            let screenWidth = UIScreen.main.bounds.width
            
            let enableLabel = UILabel()
            cell.contentView.addSubview(enableLabel)
            enableLabel.snp.makeConstraints({ (make) -> Void in
                make.top.equalToSuperview()
                make.height.equalToSuperview()
                make.left.equalToSuperview()
                make.width.equalTo(screenWidth * 0.5)
            })
            
            enableLabel.font = UIFont.init(name: TipConstants.textFontName, size: 20)
            enableLabel.textAlignment = .center
            enableLabel.backgroundColor = UIColor.lightGray
            enableLabel.text = "Enabled"
            
            let enableSwitch = UISwitch()
            enableSwitch.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
            cell.contentView.addSubview(enableSwitch)
            enableSwitch.snp.makeConstraints({ (make) -> Void in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview()
                make.width.equalTo(screenWidth * 0.2)
                make.right.equalToSuperview()
            })
            
            let defaults = UserDefaults.standard
            if (defaults.bool(forKey: "doubleTap")) {
                enableSwitch.setOn(true, animated: true)
            } else {
                enableSwitch.setOn(false, animated: true)
            }
            
        }

        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Tip Percentage"
        } else if (section == 1) {
            return "Double Tap to Round"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    // MARK: - UISwitch Methods
    func switchChanged(s: UISwitch) {
        let defaults = UserDefaults.standard
        defaults.set(s.isOn, forKey: "doubleTap")
        defaults.synchronize()
    }

    // MARK: - Text Methods
    func textFieldDidChange(_ textField: UITextField) {
        let newPercentage = Int(textField.text!) ?? 0
        if (newPercentage > 0 && newPercentage < 100) {
            let defaults = UserDefaults.standard
            switch textField.tag {
            case 0:
                defaults.set(newPercentage, forKey: "default")
                defaults.synchronize()
                break
            case 1:
                defaults.set(newPercentage, forKey: "min")
                defaults.synchronize()
                break
            case 2:
                defaults.set(newPercentage, forKey: "max")
                defaults.synchronize()
                break
            default:
                break
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = textField.text! + string
        let newPercentage = Int(newString) ?? 0
        
        if (newPercentage > 0 && newPercentage < 100) {
            return true
        }
        
        return false
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
