//
//  DesignGalleryViewController.swift
//  CustomerApp
//
//  Created by Essensys-09 on 26/02/18.
//  Copyright © 2018 Essensys-09. All rights reserved.
//

import UIKit
import Cartography
import Alamofire

class DesignGalleryViewController: UIViewController, LoginViewControllerDelegate {
    
    func myVCDidFinishLogin(_ controller: LoginViewController, Id: String) {
        UserDefaults.standard.set(Id, forKey: "customerID")

        if UserDefaults.standard.value(forKey: "customerID") != nil
        {
            viewNoImg.isHidden = true
            if currentReachabilityStatus != .notReachable {
                getDesignGallery(sohId: "", offset: "0")
            } else {
                alert()
            }
        } else {

            alert()
        }
    }
    
    @IBOutlet weak var viewBackScrollView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnAll: UIButton!
    
    var viewNavigation = UIView()
    var isfromDesignWall:String = ""

    var strTitle:String = ""
    let viewNoImg = UIView()
    let lblNoImg = UILabel()
    
    var stackView:UIStackView!
    var viewtab:UIButton!
    
    var count:Int = 0
    
    var arrGalleryList    = [arrResponseGalleryList]()
    var arrNavGalleryList = [arrResponseNavGalleryListDesignGallery]()
    
    var swipeableView: ZLSwipeableView!
    var colors = [String]()
    var arrSummaryImg = [String]()
    var arrGalleryId = [String]()
    
    var colorIndex = 0
    var loadCardsFromXib = false
    let lblTitle = UILabel()
    let lblSubTitle = UILabel()
    
    var viewBottom = UIView()
    var viewComment = UIView()
    var dislikeButton: UIButton!
    var likeButton: UIButton!
    var commentButton: UIButton!
    var shareButton: UIButton!
    var addButton: UIButton!
    var txtComment: UITextView!
    var isCommentActive:String = "0"
    var shareImgURL:String!
    
    var gallery_ID:String = ""
    var like_Dislike:String!
    var tabID:String = ""
    var strOffset:String = "0"
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        InitSubView()
    }
    
    func InitSubView() {
        viewNavigation = UIView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
        viewNavigation.backgroundColor = UIColor.white
        viewNavigation.layer.shadowColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        viewNavigation.layer.shadowOpacity = 1.0
        viewNavigation.layer.shadowRadius = 1
        viewNavigation.layer.shadowOffset = CGSize(width: 1, height: 1.5)
        self.view.addSubview(viewNavigation)
        
        let btnBack = UIButton(frame:CGRect(x: 8, y: 25, width: 46, height: 30))
        btnBack.setImage(UIImage(named: "back_icon"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClk), for: UIControlEvents.touchUpInside)
        self.viewNavigation.addSubview(btnBack)
        
        let btnHelp = UIButton(frame:CGRect(x: self.viewNavigation.frame.size.width - 46, y: 25, width: 46, height: 30))
        btnHelp.setImage(UIImage(named: "help_icon"), for: .normal)
        btnHelp.addTarget(self, action: #selector(btnHelpClk), for: UIControlEvents.touchUpInside)
        self.viewNavigation.addSubview(btnHelp)
        
        lblTitle.frame.origin.x = viewNavigation.center.x - 70
        lblTitle.frame.size.width = 140
        lblTitle.frame.origin.y = viewNavigation.center.y
        lblTitle.frame.size.height = 21
        lblTitle.text = "Design Gallery"
        lblTitle.font = UIFont(name: "Roboto-Light", size: 16)
        lblTitle.textAlignment = .center
        lblTitle.textColor = UIColor(red: 140/255, green: 98/255, blue: 57/255, alpha: 1)
        self.viewNavigation.addSubview(lblTitle)
        
        lblSubTitle.frame.origin.x = viewNavigation.center.x - 70
        lblSubTitle.frame.size.width = 140
        lblSubTitle.frame.origin.y = viewNavigation.center.y
        lblSubTitle.frame.size.height = 16
        lblSubTitle.text = ""
        lblSubTitle.font = UIFont(name: "Roboto-Light", size: 14)
        lblSubTitle.textAlignment = .center
        lblSubTitle.textColor = UIColor(red: 140/255, green: 98/255, blue: 57/255, alpha: 1)
        self.viewNavigation.addSubview(lblSubTitle)
        
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        
        viewBottom = UIView(frame:CGRect(x: 0, y: UIScreen.main.bounds.size.height - 80, width: UIScreen.main.bounds.size.width, height: 80))
        viewBottom.backgroundColor = UIColor.white
        self.view.addSubview(viewBottom)
        self.viewBottom.bringSubview(toFront: view)
        
        let viewSubViewBottom = UIView(frame:CGRect(x: (viewBottom.frame.size.width/2) - 150, y: 0, width: 300, height: 64))
        viewSubViewBottom.backgroundColor = UIColor.white
        self.viewBottom.addSubview(viewSubViewBottom)
        
        commentButton = UIButton(frame:CGRect(x: 0, y: 0, width: 30, height: 64))
        commentButton.setImage(UIImage(named: "comment_line"), for: .normal)
        commentButton.addTarget(self,action:#selector(commentButtonAction), for: .touchUpInside)
        viewSubViewBottom.addSubview(commentButton)
        
        shareButton = UIButton(frame:CGRect(x: commentButton.frame.origin.x + commentButton.frame.size.width + 60, y: 0, width: 30, height: 64))
        shareButton.setImage(UIImage(named: "share_line"), for: .normal)
        shareButton.addTarget(self,action:#selector(shareButtonAction), for: .touchUpInside)
        viewSubViewBottom.addSubview(shareButton)
        
        dislikeButton = UIButton(frame:CGRect(x: (viewSubViewBottom.frame.size.width/2) + 30, y: 0, width: 30, height: 64))
        dislikeButton.setImage(UIImage(named: "dislike"), for: .normal)
        dislikeButton.addTarget(self,action:#selector(dislikeButtonAction), for: .touchUpInside)
        viewSubViewBottom.addSubview(dislikeButton)
        
        likeButton = UIButton(frame:CGRect(x: viewSubViewBottom.frame.size.width - 30, y: 0, width: 30, height: 64))
        likeButton.setImage(UIImage(named: "like"), for: .normal)
        likeButton.addTarget(self,action:#selector(likeButtonAction), for: .touchUpInside)
        viewSubViewBottom.addSubview(likeButton)
        
        
        viewComment = UIView(frame:CGRect(x: 45, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width - 90, height: 50))
        viewComment.backgroundColor = UIColor.white
        self.view.addSubview(viewComment)
        self.viewComment.bringSubview(toFront: view)
        viewComment.isHidden = true
        
        viewComment.layer.shadowColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        viewComment.layer.shadowOpacity = 1.0
        viewComment.layer.shadowRadius = 1
        viewComment.layer.shadowOffset = CGSize(width: 1, height: 2.5)
        
        addButton = UIButton(frame:CGRect(x: viewComment.frame.size.width - 50, y: 0, width: 50, height: 50))
        addButton.setTitle("ADD", for: .normal)
        addButton.setTitleColor(UIColor.gray, for: UIControlState())
        
        addButton.titleLabel!.textAlignment = NSTextAlignment.center
        addButton.titleLabel!.font = UIFont(name: "Roboto-Light", size: 16)
        addButton.addTarget(self, action: #selector(DesignGalleryViewController.addButtonClk(_:)), for: UIControlEvents.touchUpInside)
        self.viewComment.addSubview(addButton)
        
        txtComment = UITextView(frame:CGRect(x: 0, y: 0, width: viewComment.frame.size.width - 50, height: 50))
        txtComment.text = "Add Comment here"
        txtComment.font = UIFont(name: "Roboto-Light", size: 16)
        txtComment.textColor = UIColor.gray
        
        viewComment.addSubview(txtComment)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeableView = ZLSwipeableView()
        view.addSubview(swipeableView)
        
        swipeableView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
            if UserDefaults.standard.value(forKey: "customerID") == nil
            {
                let loginVC = LoginViewController()
                loginVC.delegate = self
                self.displayContentController(content: loginVC)
            }
        }
        swipeableView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
            
            let strDirection = "\(direction)"
            if strDirection == "Right" {
                self.like_Dislike = "like"
            } else {
                self.like_Dislike = "dislike"
            }
            
            if UserDefaults.standard.value(forKey: "customerID") != nil
            {
                if self.currentReachabilityStatus != .notReachable {
                    self.commmentLikeDislike()
                } else {
                    self.alert()
                }
            }
//            else {
//                let loginVC = LoginViewController()
//                loginVC.delegate = self
//                self.displayContentController(content: loginVC)
//
//            }
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        swipeableView.didTap = {view, location in
            print("Did tap at location \(location)")
        }
        swipeableView.didDisappear = { view in
            print("Did disappear swiping view")
            self.dislikeButton.setImage(UIImage(named: "dislike"), for: .normal)
            self.likeButton.setImage(UIImage(named: "like"), for: .normal)
        }
        
        constrain(swipeableView, view) {
            view1, view2 in
            view1.left == view2.left+50
            view1.right == view2.right-50
            view1.top == view2.top + 120
            view1.bottom == view2.bottom - 100
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        viewNoImg.isHidden = true
        if currentReachabilityStatus != .notReachable {
            getDesignGallery(sohId: "", offset: "0")
        } else {
            alert()
        }
    }
    
    func Init() {
        btnAll.backgroundColor = UIColor.white
        btnAll.layer.shadowColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        btnAll.layer.shadowOpacity = 1.0
        btnAll.layer.shadowRadius = 1
        btnAll.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        viewBackScrollView.backgroundColor = UIColor.white
        viewBackScrollView.layer.shadowColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        viewBackScrollView.layer.shadowOpacity = 1.0
        viewBackScrollView.layer.shadowRadius = 1
        viewBackScrollView.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        self.count = self.arrNavGalleryList.count
        stackView = UIStackView(frame:CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        
        var x = 0
//        var childLevel1 = [arrResponseChildrenLevel1]()
        
        for i in 0..<count {
            viewtab = UIButton(frame:CGRect(x: x, y: 0, width: 150, height: Int(self.stackView.frame.size.height)))
            viewtab.tag = i
            let title = arrNavGalleryList[i].soh_title
            viewtab.setTitle(title, for: .normal)
            viewtab.setTitleColor(UIColor(red: 140/255, green: 98/255, blue: 57/255, alpha: 1), for: .normal)
            viewtab.titleLabel?.font = UIFont(name: "Roboto-Light", size: 16)
            x = x + 100
            stackView.addSubview(viewtab)
            viewtab.addTarget(self,action:#selector(btnViewTabClk(sender:)), for: .touchUpInside)
        }
        let arrCount : CGFloat = CGFloat(count)
        let width = viewtab.frame.size.width
        scrollView.contentSize.width = width * arrCount
        
        var framestackView:CGRect = stackView.frame
        framestackView.size.width = width * arrCount
        stackView.frame = framestackView
    }
    
    @objc func btnViewTabClk(sender:UIButton) {
        print("Level1:\(sender.tag)")
        viewNoImg.isHidden = true
//        strTitle = arrNavGalleryList[sender.tag].cat_name!
        tabID = arrNavGalleryList[sender.tag].soh_id!
        lblTitle.text = strTitle
        lblTitle.frame.origin.y = 10
        lblSubTitle.text = "Design Gallery"
        let sohId:NSString = arrNavGalleryList[sender.tag].soh_id! as NSString
        if currentReachabilityStatus != .notReachable {
            getDesignGallery(sohId: sohId, offset: "0")
        } else {
            alert()
        }
    }
    
    @objc func btnViewTabChildClk(sender:UIButton) {
        print("Level2:\(sender.tag)")
        strTitle = ""
        //        lblTitle.text = strTitle
        //        lblTitle.frame.origin.y = 10
        //        lblSubTitle.text = "Design Gallery"
        viewNoImg.isHidden = true
        let sohId:NSString = "\(sender.tag)" as NSString
        tabID = sohId as String
        if currentReachabilityStatus != .notReachable {
            getDesignGallery(sohId: sohId, offset: "0")
        } else {
            alert()
        }
    }
    
    @objc func btnHelpClk(sender: UIButton) {
        
    }
    
    @objc func btnBackClk(sender: UIButton!) {
        if isfromDesignWall == "1" {
            self.navigationController?.popViewController(animated: true)
        } else {
            let revealController: SWRevealViewController? = revealViewController()
            let homeVC = HomeViewController()
            let navigationController = UINavigationController(rootViewController: homeVC)
            revealController?.pushFrontViewController(navigationController, animated: true)
        }
    }
    
    // MARK: - Actions
    @objc func addButtonClk(_ sender:UIButton!) {
        viewComment.isHidden = true
        commentButton.setImage(UIImage(named: "comment_line"), for: .normal)
        
        if txtComment.text == "Add Comment here" || txtComment.text == "" {
            let alert = UIAlertController(title: nil, message: "Please enter message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                
                self.hideHUD()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            if UserDefaults.standard.value(forKey: "customerID") != nil
            {
                if currentReachabilityStatus != .notReachable {
                    commmentLikeDislike()
                } else {
                    alert()
                }
            } else {
                let loginVC = LoginViewController()
                loginVC.delegate = self
                displayContentController(content: loginVC)
            }
        }
    }
    
    func displayContentController(content: UIViewController) {
        addChildViewController(content)
        self.view.addSubview(content.view)
        content.view.frame = UIScreen.main.bounds
        content.didMove(toParentViewController: self)
    }
    
    @objc func commentButtonAction() {
        if isCommentActive == "0" {
            viewComment.isHidden = false
            commentButton.setImage(UIImage(named: "comment_filled"), for: .normal)
            addToolBar(textField: txtComment)
            isCommentActive = "1"
        } else {
            viewComment.isHidden = true
            commentButton.setImage(UIImage(named: "comment_line"), for: .normal)
            addToolBar(textField: txtComment)
            isCommentActive = "0"
        }
    }
    
    @objc func shareButtonAction() {
        shareButton.setImage(UIImage(named: "share_filled"), for: .normal)
        let imageShare = UIImageView()
        imageShare.setImageFromURl(stringImageUrl: shareImgURL)
        
        let image = imageShare.image!
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.excludedActivityTypes = [UIActivityType.postToWeibo, UIActivityType.print, UIActivityType.copyToPasteboard, UIActivityType.assignToContact, UIActivityType.saveToCameraRoll, UIActivityType.postToFlickr, UIActivityType.postToTencentWeibo]
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func dislikeButtonAction() {
        self.swipeableView.swipeTopView(inDirection: .Left)
        dislikeButton.setImage(UIImage(named: "dislike_filled"), for: .normal)
        like_Dislike = "dislike"
    }
    
    @objc func likeButtonAction() {
        self.swipeableView.swipeTopView(inDirection: .Right)
        likeButton.setImage(UIImage(named: "like_filled"), for: .normal)
        like_Dislike = "like"
    }
    
    // MARK: ()
    func nextCardView() -> UIView? {
        let cardView = CardView(frame: swipeableView.bounds)
        
        if arrSummaryImg.count == 0 {
            cardView.VCView1.isHidden = true
        } else {
            
            //        if isFromSummary == "1" {
            if colorIndex >= (arrSummaryImg.count) {
                //                colorIndex = 0
                
                if currentReachabilityStatus != .notReachable {
                    getDesignGallery(sohId: "", offset: strOffset as NSString)
                } else {
                    alert()
                }
            }
            let path:String = arrSummaryImg[colorIndex]
            gallery_ID = arrGalleryId[colorIndex]
            print("Images>>>\(path)")
            print("ID>>>\(gallery_ID)")
            
            shareImgURL = path
            cardView.VCView1.setImageFromURl(stringImageUrl: path)
            
            //        } else {
            //            if colorIndex >= colors.count {
            //                colorIndex = 0
            //            }
            //            cardView.VCView1.setImageFromURl(stringImageUrl: colors[colorIndex])
            //        }
            
            colorIndex += 1
        }
        return cardView
    }
    
    
    @IBAction func btnAllClk(_ sender: Any) {
        strTitle = "All"
        tabID = ""
        lblTitle.frame.origin.y = viewNavigation.center.y
        lblTitle.text = "Design Gallery"
        lblSubTitle.text = ""
        stackView.removeFromSuperview()
        viewNoImg.isHidden = true
        if currentReachabilityStatus != .notReachable {
            getDesignGallery(sohId: "", offset: "0")
        } else {
            alert()
        }
    }
    
    func colorForName(_ name: String) -> UIColor {
        let sanitizedName = name.replacingOccurrences(of: " ", with: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.perform(Selector(selector)).takeUnretainedValue() as! UIColor
    }
    
    //MARK:- WEBSERVICE CALL
    func getDesignGallery(sohId:NSString, offset:NSString) {
        showHud("Loading")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        var customerID:String = ""
        if UserDefaults.standard.value(forKey: "customerID") != nil
        {
            customerID = UserDefaults.standard.value(forKey: "customerID") as! String //540
        }
        
        let param : [String:String] = ["sessionCustomerId": customerID,
                                       "sohId": sohId as String,
                                       "offset": offset as String
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"http://54.255.247.3/selfserve/webapp/customer-app/ws-gallery/ws-get-design-gallery-list.php")
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
                                    if responseCode == "0"
                                    {
                                    }
                                    else if responseCode == "1"
                                    {
                                        let offset = resultJson.value(forKey: "offset") as? Int
                                        self.strOffset = "\(offset!)"
                                        let limit = resultJson.value(forKey: "limit") as? Int
                                        
                                        print(self.strOffset)
                                        print(limit!)
                                        self.arrNavGalleryList.removeAll()
                                        
                                        self.arrGalleryList.removeAll()
                                        
                                        if let resValue = resultJson.value(forKey:  "arrNavGalleryList") as? [AnyObject]
                                        {
                                            for arrData in resValue {
                                                
                                                let soh_id = arrData["soh_id"] as? String
                                                let soh_title = arrData["soh_title"] as? String
                                                let numOfImages = arrData["numOfImages"] as? String
                                                
                                                let NavGalleryList = arrResponseNavGalleryListDesignGallery(soh_id: soh_id!, soh_title: soh_title!, numOfImages: numOfImages!)
                                                self.arrNavGalleryList.append(NavGalleryList)
                                            }
                                            DispatchQueue.main.async(execute: {
//                                                if self.isbuttonClk == false {
                                                    self.Init()
//                                                }
                                                self.hideHUD()
                                            })
                                        }
                                        if let resValueGallery = resultJson.value(forKey: "arrGalleryList") as? [AnyObject]
                                        {
                                            for arrDataGallery in resValueGallery {
                                                
                                                let galleryimg_id = arrDataGallery["galleryimg_id"] as? String
                                                let imgFilename = arrDataGallery["imgFilename"] as? String
                                                let imgURL = arrDataGallery["imgURL"] as? String
                                                
                                                let Gallery = arrResponseGalleryList(galleryimg_id: galleryimg_id!, imgFilename: imgFilename!, imgURL: imgURL!)
                                                self.arrGalleryList.append(Gallery)
                                            }
                                            DispatchQueue.main.async(execute: {
                                                
                                                self.arrSummaryImg.removeAll()
                                                self.arrGalleryId.removeAll()
                                                //                                                let cardView = CardView()
                                                
                                                if self.arrGalleryList.count == 0 {
                                                    self.showNoImage()
                                                } else {
                                                    for images in self.arrGalleryList
                                                    {
                                                        self.arrSummaryImg.append(images.imgURL!)
                                                        self.arrGalleryId.append(images.galleryimg_id!)
                                                    }
                                                    self.swipeableView.nextView = {
                                                        return self.nextCardView()
                                                    }
                                                }
                                                self.hideHUD()
                                            })
                                        }
                                        
                                        print(self.arrNavGalleryList)
                                        print(self.arrGalleryList)
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
    
    func commmentLikeDislike() {
        showHud("Loading")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        let customerID:String = UserDefaults.standard.value(forKey: "customerID") as! String //540
        let strComment:String!
        if txtComment.text == "Add Comment here" {
            strComment = ""
        } else {
            strComment = txtComment.text
            like_Dislike = "like"
        }
        
        let param : [String:String] = ["sessionCustomerId": customerID,
                                       "galleryimg_id": gallery_ID,
                                       "flag_like_or_dislike": like_Dislike,
                                       "comment": strComment,
                                       "tab_id": tabID,
                                       "gallery_type": "designgallery",
                                       ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"http://54.255.247.3/selfserve/webapp/customer-app/ws-gallery/ws-update-gallery-customer-action.php")
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
                    
                    if response.result.isSuccess {
                        if let resJson = response.result.value as? NSDictionary {
                            if let resultJson = resJson.value(forKey: "result") as? NSDictionary
                            {
                                if let responseCode = resultJson.value(forKey: "msg") as? String
                                {
                                    if responseCode == "0" {
                                    }
                                    else if responseCode == "1" {
                                        self.txtComment.resignFirstResponder()
                                        self.moveTextField(self.viewComment, moveDistance: -250, up: false)
                                    }
                                    
                                    let message :String = resultJson.value(forKey: "msg_string") as! String
                                    let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        self.hideHUD()
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    else if response.result.isFailure {
                        print("Response Error")
                        self.hideHUD()
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func showNoImage()  {
        self.swipeableView.discardViews()
        viewNoImg.isHidden = false
        viewNoImg.frame.size.width = self.swipeableView.frame.size.width
        viewNoImg.frame.size.height = self.swipeableView.frame.size.height - 20
        viewNoImg.frame.origin.y = 20
        viewNoImg.frame.origin.x = 0
        viewNoImg.layer.cornerRadius = 10
        viewNoImg.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        viewNoImg.layer.shadowColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        viewNoImg.layer.shadowOpacity = 1.0
        viewNoImg.layer.shadowRadius = 1
        viewNoImg.layer.shadowOffset = CGSize(width: 1, height: 1.5)
        self.swipeableView.addSubview(viewNoImg)
        
        var frame:CGRect = lblNoImg.frame
        frame.origin.x = 20
        frame.origin.y = 50
        frame.size.height = 80
        frame.size.width = viewNoImg.frame.size.width - 40
        lblNoImg.frame = frame
        viewNoImg.addSubview(lblNoImg)
        lblNoImg.numberOfLines = 3
        lblNoImg.textAlignment = .center
        lblNoImg.textColor = UIColor(red: 173/255, green: 142/255, blue: 113/255, alpha: 1)
        lblNoImg.text = "No more images in \(self.strTitle) - Design Gallery"
        
        var dividerImg = UIImageView()
        dividerImg = UIImageView(frame:CGRect(x: 20, y: lblNoImg.frame.origin.y + lblNoImg.frame.size.height + 50, width: viewNoImg.frame.size.width - 40, height: 25))
        dividerImg.image = UIImage(named: "divide")
        viewNoImg.addSubview(dividerImg)
        
        let btnDesignWall = UIButton(frame:CGRect(x: 0, y: dividerImg.frame.origin.y + dividerImg.frame.size.height + 80, width: 60, height: 60))
        btnDesignWall.center.x = viewNoImg.center.x
        btnDesignWall.setImage(UIImage(named: "img_icon_shadow"), for: .normal)
        btnDesignWall.addTarget(self, action: #selector(DesignGalleryViewController.buttonGalleryTouched(_:)), for: UIControlEvents.touchUpInside)
        viewNoImg.addSubview(btnDesignWall)
        
        let lblDesignWall = UILabel(frame:CGRect(x: 20, y: btnDesignWall.frame.origin.y + btnDesignWall.frame.size.height + 40, width: viewNoImg.frame.size.width - 40, height: 25))
        lblDesignWall.textAlignment = .center
        lblDesignWall.textColor = UIColor(red: 173/255, green: 142/255, blue: 113/255, alpha: 1)
        lblDesignWall.text = "Visit your Design Wall"
        viewNoImg.addSubview(lblDesignWall)
    }
    
    @objc func buttonGalleryTouched(_ sender:UIButton!)
    {
        let galleryVC = MyDesignWallViewController()
        galleryVC.isfromHome = "0"
        self.navigationController?.pushViewController(galleryVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class arrResponseNavGalleryListDesignGallery {
    var soh_id:String?
    var soh_title:String?
    var numOfImages:String?
    
    init(soh_id:String, soh_title:String, numOfImages:String) {
        self.soh_id = soh_id
        self.soh_title = soh_title
        self.numOfImages = numOfImages
    }
}

extension DesignGalleryViewController: UITextViewDelegate
{
    func addToolBar(textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DesignGalleryViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DesignGalleryViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        txtComment.delegate = self
        txtComment.inputAccessoryView = toolBar
    }
    @objc func donePressed(){
        view.endEditing(true)
    }
    @objc func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtComment.text == "Add Comment here"
        {
            txtComment.text = ""
            addButton.setTitleColor(UIColor(red: 140/255, green: 98/255, blue: 57/255, alpha: 1), for: UIControlState())
            txtComment.textColor = UIColor(red: 140/255, green: 98/255, blue: 57/255, alpha: 1)
            moveTextField(viewComment, moveDistance: -250, up: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtComment.text == ""
        {
            txtComment.text = "Add Comment here"
            addButton.setTitleColor(UIColor.gray, for: UIControlState())
            txtComment.textColor = UIColor.gray
            moveTextField(viewComment, moveDistance: -250, up: false)
        }
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ view: UIView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
