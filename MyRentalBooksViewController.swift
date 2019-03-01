//
//  MyRentalBooksViewController.swift
//  BookMyBook
//
//  Created by Mac on 21/09/18.
//  Copyright © 2018 Mansionly Macbook 1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyRentalBooksViewController: UIViewController {
    
    @IBOutlet var tableViewRentalBooks: UITableView!
    
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCart: UIButton!
    @IBOutlet var btnNotification: UIButton!
    
    var userRentedBookList : [UserRentedBookList]! = []
    var arrRentedBookList : [UserRentedBookList]! = []
    var msgStr : String! = ""
    
    var strOffset:String = OFFSET_ZERO
    var AllDataFetch:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewRentalBooks.register(UINib(nibName: "MyRentalBooksTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        if currentReachabilityStatus != .notReachable {
            getRentedBooksList()
        } else {
            alert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- Actions
    
    @IBAction func btnMenuClk(_ sender: Any) {
        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction func btnCartClk(_ sender: Any) {
        self.navigationController?.pushViewController(MyCartViewController(), animated: true)
    }
    
    @IBAction func btnNotificationClk(_ sender: Any) {
    }
    
    @objc func btnReturnClk(sender:UIButton){
        let bookId = arrRentedBookList[sender.tag].rentedBookId
        if currentReachabilityStatus != .notReachable {
            self.returnRentedBook(bookId!)
        } else {
            alert()
        }
    }
    
    @objc func btnReIssueClk(sender:UIButton){
        let bookId = arrRentedBookList[sender.tag].rentedBookId
        if currentReachabilityStatus != .notReachable {
            self.reIssueRentedBook(bookId!)
        } else {
            alert()
        }
    }
    
    // MARK:- Webservice
    
    func getRentedBooksList() {
        showHud("Loading")
        let webServiceURL = URL(string: STAGING_URL + COMMON_URL + WS_URL_RENTED_BOOK_LIST)  // http://52.41.183.204/JB085/web-app/ws-products/ws-product-list.php
        
        let customerID:String = UserDefaults.standard.value(forKey: USER_DEFAULT_KEY_CUSTOMER_ID) as! String
        let userAuth:String = UserDefaults.standard.value(forKey: USER_DEFAULT_KEY_USER_AUTH) as! String
        
        let parameters : Parameters = [ WS_PARAM_USER_ID : customerID,
                                    ]
        let headers: HTTPHeaders = [
            HEADER_USER_AUTH: userAuth,
           // "Accept": "application/json"
        ]
        
        Alamofire.request(webServiceURL!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                if response.result.isSuccess
                {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let json = jsonResponse["result"]
                    self.msgStr = json["msg"].stringValue
                    
                    if let responseCode = self.msgStr{
                        if responseCode == "0" {
                            let alert = UIAlertController(title: nil, message: json["msg_string"].stringValue, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                self.hideHUD()
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == "1"{
                            
                           
                            if self.strOffset == "" {
                                self.arrRentedBookList.removeAll()
                            }
//                            self.userRentedBookList = [UserRentedBookList]()
                            
                            let userRentedBookListArray = json["userRentedBookList"].arrayValue
                            
                            if userRentedBookListArray.count == 0{
                                self.AllDataFetch = true
                                self.hideHUD()
                            } else {
                                for userRentedBookListJson in userRentedBookListArray{
                                    let value = UserRentedBookList(fromJson: userRentedBookListJson)
                                    self.arrRentedBookList.append(value)
                                }
                                
                                let offset = json["offset"].intValue
                                self.strOffset = "\(offset)"
                                
                                self.tableViewRentalBooks.reloadData()
                                self.hideHUD()
                            }
                        }
                    }
                }
                else if response.result.isFailure {
                    print("Response Error")
                    self.showAlertController("Check internet connection")
                    self.hideHUD()
                }
        }
        
    }
    
    func returnRentedBook(_ bookId : String) {
        showHud("Loading")
        let webServiceURL = URL(string: STAGING_URL + COMMON_URL + WS_URL_RETURN_RENTED_BOOK)  // http://52.41.183.204/JB085/web-app/ws-products/ws-product-list.php
        
        let customerID:String = UserDefaults.standard.value(forKey: USER_DEFAULT_KEY_CUSTOMER_ID) as! String
        let userAuth:String = UserDefaults.standard.value(forKey: USER_DEFAULT_KEY_USER_AUTH) as! String
        
        let parameters : Parameters = [ WS_PARAM_USER_ID : customerID,
                                        WS_PARAM_RENTED_BOOK_ID : bookId
                                        ]
        let headers: HTTPHeaders = [
            HEADER_USER_AUTH: userAuth,
            ]
        
        Alamofire.request(webServiceURL!, method: .post, parameters: parameters, encoding: URLEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                if response.result.isSuccess
                {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let json = jsonResponse["result"]
                    self.msgStr = json["msg"].stringValue
                    
                    if let responseCode = self.msgStr{
                        if responseCode == "0" {
                            let alert = UIAlertController(title: nil, message: json["msg_string"].stringValue, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                self.hideHUD()
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == "1"{
                            if self.currentReachabilityStatus != .notReachable {
                                    self.getRentedBooksList()
                            }else {
                                self.alert()
                            }
                                self.tableViewRentalBooks.reloadData()
                                self.hideHUD()
                        }
                    }
                }
                else if response.result.isFailure {
                    print("Response Error")
                    self.showAlertController("Check internet connection")
                    self.hideHUD()
                }
        }
        
    }
    
    func reIssueRentedBook(_ bookId : String) {
        showHud("Loading")
        let webServiceURL = URL(string: STAGING_URL + COMMON_URL + WS_URL_REISSUE_RENTED_BOOK)  // http://52.41.183.204/JB085/web-app/ws-products/ws-product-list.php
        
        let customerID:String = UserDefaults.standard.value(forKey: USER_DEFAULT_KEY_CUSTOMER_ID) as! String
        let userAuth:String = UserDefaults.standard.value(forKey: USER_DEFAULT_KEY_USER_AUTH) as! String
        
        let parameters : Parameters = [ WS_PARAM_USER_ID : customerID,
                                        WS_PARAM_RENTED_BOOK_ID : bookId
        ]
        let headers: HTTPHeaders = [
            HEADER_USER_AUTH: userAuth,
            ]
        
        Alamofire.request(webServiceURL!, method: .post, parameters: parameters, encoding: URLEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                if response.result.isSuccess
                {
                    
                    let jsonResponse = JSON(response.result.value!)
                    let json = jsonResponse["result"]
                    self.msgStr = json["msg"].stringValue
                    
                    if let responseCode = self.msgStr{
                        if responseCode == "0" {
                            let alert = UIAlertController(title: nil, message: json["msg_string"].stringValue, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                self.hideHUD()
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if responseCode == "1"{
                            if self.currentReachabilityStatus != .notReachable {
                                self.getRentedBooksList()
                            }else {
                                self.alert()
                            }
                            self.tableViewRentalBooks.reloadData()
                            self.hideHUD()
                        }
                    }
                }
                else if response.result.isFailure {
                    print("Response Error")
                    self.showAlertController("Check internet connection")
                    self.hideHUD()
                }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - MyRentalBooksViewController DataSource and Delegate
//
extension MyRentalBooksViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrRentedBookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewRentalBooks.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! MyRentalBooksTableViewCell
        
        cell.viewCell.layer.cornerRadius = 5
        
        cell.setupCellContents(arrRentedBookList[indexPath.section])
        
        cell.btnReturn.tag = indexPath.section
        cell.btnReIssue.tag = indexPath.section
        cell.btnReturn.addTarget(self,action:#selector(btnReturnClk(sender:)), for: .touchUpInside)
        cell.btnReIssue.addTarget(self,action:#selector(btnReIssueClk(sender:)), for: .touchUpInside)
        
        if indexPath.row == arrRentedBookList.count - 3 {
            if currentReachabilityStatus != .notReachable {
                if self.AllDataFetch == false {
                    self.getRentedBooksList()
                }
            } else {
                alert()
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 159
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }
}

