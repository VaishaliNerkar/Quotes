//
//  QuotesViewController.swift
//  CustomerApp
//
//  Created by Prassana  on 27/12/17.
//  Copyright © 2017 Essensys-09. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class QuotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var viewNavigation: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnQuestion: UIButton!
    
    @IBOutlet weak var viewDropBox: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblLeadID: UILabel!
    @IBOutlet weak var btnDropDown: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet var viewNoImg: UIView!
    @IBOutlet var btnContactUs: UIButton!
    
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var tblViewList: UITableView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var lblSelectAddress: UILabel!
    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var heightTable: NSLayoutConstraint!

    var listTblView = UITableView()
    
    var closeBtn : UIButton!
    
    var tapGesture = UITapGestureRecognizer()
    
    var arrQuotes = [arrResponseQoutes]()
    var arrQuotesList = [arrResponseQoutesList]()
    
    var arrIndex = [String]()
    var selectedIndex : IndexPath! = IndexPath(row: 0, section: 0)
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
        btnContactUs.layer.cornerRadius = btnContactUs.frame.size.height / 2

        viewDropBox.layer.cornerRadius = 10
        viewDropBox.layer.shadowColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        viewDropBox.layer.shadowOpacity = 1.0
        viewDropBox.layer.shadowRadius = 1
        viewDropBox.layer.shadowOffset = CGSize(width: 1, height: 7)
        
        viewNavigation.layer.shadowColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        viewNavigation.layer.shadowOpacity = 1.0
        viewNavigation.layer.shadowRadius = 1
        viewNavigation.layer.shadowOffset = CGSize(width: 1, height: 3)
    
        
        tblView.dataSource = self
        tblView.delegate = self
        tblViewList.dataSource = self
        tblViewList.delegate = self
        
        listTblView.delegate = self
        listTblView.dataSource = self
        
        tblView.register(UINib(nibName: "QuotesTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        tblViewList.register(UINib(nibName: "QuotesAddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "CellList")
        
        tblViewList.layer.cornerRadius = 10
        
        // TAP Gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(QuotesViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewDropBox.addGestureRecognizer(tapGesture)
        viewDropBox.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.viewPopUp.isHidden = true
        
        self.navigationController?.isNavigationBarHidden = true
        
//        arrIndex = ["0","0","0","0","0","0","0","0"]
        
            if currentReachabilityStatus != .notReachable
            {
                self.QoutesList()
            } else {
                print("Internet connection FAILED")
                alert()
            }
        tblViewList.reloadData()
    }

    override func viewWillLayoutSubviews() {
        
        viewTitle.roundCorners([.topLeft, .topRight], radius: 10)
        viewClose.roundCorners([.bottomRight, .bottomLeft], radius: 10)

        let arrCount : CGFloat = CGFloat(arrQuotes.count)
        self.tblViewList.frame.size.height = self.tblViewList.rowHeight * arrCount
        print(self.tblViewList.frame.size.height)
        self.heightTable.constant = self.arrQuotes.count > 6 ? 480.0 : self.tblViewList.frame.size.height + 10
        self.tblViewList.frame.size.height = self.heightTable.constant
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        self.viewPopUp.isHidden = false
    }
    
    // MARK:- Webservice Call
    func QoutesList()
    {
        showHud("Loading")
    
//        let parameter : Parameters = ["sessionCustomerId": "540"]
//
//        let url = URL(string: "http://54.255.247.3/selfserve/webapp/customer-app/ws-quotes/ws-get-customer-quotes-list.php")
//        Alamofire.request(url!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//
//            if((response.result.value) != nil) {
//                let swiftyJsonVar = JSON(response.result.value!)
//                print(swiftyJsonVar)
//            }
//        }
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        let customerID:String = UserDefaults.standard.value(forKey: "customerID") as! String //540
        let param : [String:String] = ["sessionCustomerId": customerID
                                        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"http://54.255.247.3/selfserve/webapp/customer-app/ws-quotes/ws-get-customer-quotes-list.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    
                    if response.result.isSuccess
                    {
                        if let resJson = response.result.value as? NSDictionary
                        {
                            if let resultJson = resJson.value(forKey: "result") as? NSDictionary
                            {
                                if let responseCode = resultJson.value(forKey: "msg") as? String
                                {
                                    if responseCode == "0" {
                                        self.hideHUD()
                                    }
                                    else if responseCode == "1"
                                    {
                                        self.arrQuotes.removeAll()
                                        self.arrQuotesList.removeAll()
                                        
                                        if let resValue = resultJson.value(forKey:  "arrCustomerQuotesList") as? [AnyObject]
                                        {
                                            if resValue.count == 0 {
                                                self.tblView.isHidden = true
                                                self.viewDropBox.isHidden = true
                                                self.viewNoImg.isHidden = false
                                            } else {
                                                self.tblView.isHidden = false
                                                self.viewDropBox.isHidden = false
                                                self.viewNoImg.isHidden = true
                                            }
                                            
                                            for arrData in resValue {
                                                
                                                let lead_id = arrData["lead_id"] as? String
                                                let unique_lead_id = arrData["unique_lead_id"] as? String
                                                let lead_address = arrData["lead_address"] as? String
                                                
                                                if (resultJson.value(forKey:  "arrLeadQuotesList") as? [AnyObject]) != nil
                                                {
                                                    for arrDataList in resValue {
                                                         let quote_id = arrDataList["qoute_id"] as? String
                                                        let order_id = arrDataList["order_id"] as? String
                                                        let quote_status = arrDataList["quote_status"] as? String
                                                        let quote_sent_to_customer = arrDataList["quote_sent_to_customer"] as? String
                                                        let on_datetime = arrDataList["on_datetime"] as? String
                                                    
                                                        let list = arrResponseQoutesList(qoute_id: quote_id!, order_id: order_id!, quote_status: quote_status!, quote_sent_to_customer: quote_sent_to_customer!, on_datetime: on_datetime!)
                                                        self.arrQuotesList.append(list)
                                                    }
                                                }
                                                
                                                let s = arrResponseQoutes(lead_id:lead_id!, unique_lead_id:unique_lead_id!, lead_address:lead_address!, arrLeadQuotesList:self.arrQuotesList)
                                                self.arrQuotes.append(s)
                                                self.arrIndex.append("0")
                                                
                                                self.lblAddress.text = self.arrQuotes[0].lead_address
                                                self.lblLeadID.text = self.arrQuotes[0].unique_lead_id
                                            }
                                            DispatchQueue.main.async(execute: {
                                                
                                                let arrCount : CGFloat = CGFloat(self.arrQuotes.count)
                                                self.tblViewList.frame.size.height = self.tblViewList.rowHeight * arrCount
                                                print(self.tblViewList.frame.size.height)
                                                self.heightTable.constant = self.arrQuotes.count > 6 ? 480.0 : self.tblViewList.frame.size.height + 10
                                                self.tblViewList.frame.size.height = self.heightTable.constant
                                                
                                                self.tblView.reloadData()
                                                self.tblViewList.reloadData()
                                                self.hideHUD()
                                            })
                                        }
                                        self.hideHUD()
                                    }
                                }
                            }
                        }
                    }
                    else if response.result.isFailure
                    {
                        print("Response Error")
                        self.hideHUD()
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
//    func getQuotesList()
//    {
//
//        let newString: String = "http://54.255.247.3/selfserve/webapp/customer-app/ws-quotes/ws-get-customer-quotes-list.php".replacingOccurrences(of: " ", with: "%20")
//
//        let url : URLConvertible = URL(string: newString)!
//
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//            print("RESPONSE>>>>>>\(response)")
//
//            if response.result.isSuccess
//            {
//                if let resJson = response.result.value as? NSDictionary
//                {
//                    if let resultJson = resJson.value(forKey: "result") as? NSDictionary
//                    {
//                        print("RESULT>>>>>>\(resultJson)")
//                        if let responseCode = resultJson.value(forKey: "msg") as? String
//                        {
//                            if responseCode == "0"
//                            {
//                            }
//                            else if responseCode == "1"
//                            {
//                                if let resValue = resultJson.value(forKey:  "arrCustomerQuotesList") as? NSArray
//                                {
//                                    for i in resValue
//                                    {
//                                        if let dict = i as? NSDictionary
//                                        {
//                                        }
//
//
//                                    }
//
//                                }
//
//                            }
//
//                        }
//                    }
//                }
//            }
//            else if response.result.isFailure
//            {
//                print("Response Error")
//            }
//        }
//    }
    
    //MARK:- Actions
    @IBAction func btnBackClk(_ sender: Any) {
        
        let revealController: SWRevealViewController? = revealViewController()
        let homeVC = HomeViewController()
        
        let navigationController = UINavigationController(rootViewController: homeVC)
        
        revealController?.pushFrontViewController(navigationController, animated: true)
    }
    
    @IBAction func btnQuestionClk(_ sender: Any) {
    }
    
    @IBAction func btnDropDownClk(_ sender: Any) {
        self.viewPopUp.isHidden = false
    }
    
    @IBAction func btnCloseClk(_ sender: Any) {
        
        self.viewPopUp.isHidden = true
    }
    
    @IBAction func btnContctUsClk(_ sender: Any) {
        let contactUs = ContactUsViewController()
        self.navigationController?.pushViewController(contactUs, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewList
        {
            return arrQuotes.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblViewList
        {
            return 1
        } else {
            return arrQuotesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblViewList
        {
            let cell = tblViewList.dequeueReusableCell(withIdentifier: "CellList", for: indexPath as IndexPath) as! QuotesAddressListTableViewCell
            
            cell.btnRedio.tag = indexPath.row
            
            cell.btnRedio.addTarget(self,action:#selector(btnRedioClk(sender:)), for: .touchUpInside)
            
            if (selectedIndex == indexPath) {
                cell.btnRedio.setImage(UIImage(named: "radio_active"), for: UIControlState.normal)
            } else {
                cell.btnRedio.setImage(UIImage(named: "radio_normal"), for: UIControlState.normal)
            }
            
            cell.lblAddress.text = arrQuotes[indexPath.row].lead_address
            cell.lblLeadID.text = arrQuotes[indexPath.row].unique_lead_id
            
//            if arrIndex[indexPath.row] == "1"
//            {
//                cell.btnRedio.setImage(UIImage(named: "radio_active"), for: UIControlState.normal)
//
//                arrIndex[indexPath.row] = "0"
//            }
//            else
//            {
//                cell.btnRedio.setImage(UIImage(named: "radio_normal"), for: UIControlState.normal)
//            }
            
//            let cell = listTblView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as! QuotesAddressListTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! QuotesTableViewCell
            
            cell.viewCell.layer.shadowColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
            cell.viewCell.layer.shadowOpacity = 1.0
            cell.viewCell.layer.shadowRadius = 1
            cell.viewCell.layer.shadowOffset = CGSize(width: 1, height: 5)
            
            let strDate = arrQuotesList[indexPath.section].on_datetime
            cell.lblReceivedData.text = "Received on:\(strDate!)"
            
            cell.btnDownload.tag = indexPath.row
            
            cell.btnDownload.addTarget(self,action:#selector(btnDownloadClk(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func btnRedioClk(sender:UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
//        let cell = tblView.cellForRow(at: indexPath) as! QuotesAddressListTableViewCell
        tblViewList.deselectRow(at: indexPath, animated: true)
        //        let row = indexPath.row
        //        println(countryArray[row])
        selectedIndex = indexPath
        tblViewList.reloadData()
        
        self.lblAddress.text = self.arrQuotes[sender.tag].lead_address
        self.lblLeadID.text = self.arrQuotes[sender.tag].unique_lead_id
        
        arrQuotesList = arrQuotes[sender.tag].arrLeadQuotesList as! [arrResponseQoutesList]
        
        self.viewPopUp.isHidden = true

        //        if cell.btnCheck.currentImage == UIImage(named: "un_check")
        //        {
        //            cell.btnCheck.setImage(UIImage(named: "checked"), for: UIControlState.normal)
        //        }
        //        else
        //        {
        //            cell.btnCheck.setImage(UIImage(named: "un_check"), for: UIControlState.normal)
        //        }
//        self.selectedIndex = sender.tag
//        self.arrIndex[sender.tag] = "1"
//
//        tblViewList.reloadData()
    }
    
    @objc func btnDownloadClk(sender:UIButton)
    {
        let url = URL(string: "http://publications.gbdirect.co.uk/c_book/thecbook.pdf")!
        downloadTask = backgroundSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
    }
    
    //MARK: URLSessionDownloadDelegate
    // 1
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/file.pdf"))
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            showFileWithPath(path: destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                showFileWithPath(path: destinationURLForFile.path)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
    }
    // 2
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
//        progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    //MARK: URLSessionTaskDelegate
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        downloadTask = nil
//        progressView.setProgress(0.0, animated: true)
        if (error != nil) {
            print(error!.localizedDescription)
        }else{
            print("The task finished transferring data successfully")
        }
    }
    
    //MARK: UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblViewList
        {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedIndex = indexPath
            tblViewList.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblView {
            return 50
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == tblViewList {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class arrResponseQoutes
{
    var lead_id:String?
    var unique_lead_id:String?
    var lead_address:String?
    var arrLeadQuotesList:Array<Any>?
    
    init(lead_id:String, unique_lead_id:String, lead_address:String, arrLeadQuotesList:Array<Any>)
    {
        self.lead_id = lead_id
        self.unique_lead_id = unique_lead_id
        self.lead_address = lead_address
        self.arrLeadQuotesList = arrLeadQuotesList
    }
}

class arrResponseQoutesList
{
    var quote_id:String?
    var order_id:String?
    var quote_status:String?
    var quote_sent_to_customer:String?
    var on_datetime:String?
    
    init(qoute_id:String, order_id:String, quote_status:String, quote_sent_to_customer:String, on_datetime:String) {
        self.quote_id = qoute_id
        self.order_id = order_id
        self.quote_status = quote_status
        self.quote_sent_to_customer = quote_sent_to_customer
        self.on_datetime = on_datetime
    }
}

