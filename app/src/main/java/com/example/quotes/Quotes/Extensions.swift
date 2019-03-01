//
//  Extensions.swift
//  Mansionly
//
//  Created by Harshada Deshmukh on 25/06/18.
//  Copyright © 2018 Essensys-09. All rights reserved.
//

import ACFloatingTextfield_Objc
import SWRevealViewController

extension UIImageView {
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
                
            }
        }
    }
    
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    func alert(){
//        let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
}

extension String {
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
        
    }
    
    var checkSpace : Bool{
        let rawString: String = self
        let whitespace = CharacterSet.whitespacesAndNewlines
        let trimmed = rawString.trimmingCharacters(in: whitespace)
        if (trimmed.count ) == 0 {
            // Text was empty or only whitespace.
            return true
        }
        return false
    }
    
    var getImageFromURl : UIImage{
        
        var image : UIImage! = UIImage()
        if let url = NSURL(string: self) {
            if let data = NSData(contentsOf: url as URL) {
                image = UIImage(data: data as Data)!
            }
        }
        return image
    }
    
    var removingWhitespacesAndNewlines: String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func setDateFormat() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date!)
        
    }
    
//    func contains(string: String)->Bool {
//        guard !self.isEmpty else {
//            return false
//        }
//        var s = self.characters.map{ $0 }
//        let c = string.characters.map{ $0 }
//        repeat {
//            if s.startsWith(c){
//                return true
//            } else {
//                s.removeFirst()
//            }
//        } while s.count > c.count - 1
//        return false
//    }

    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension UITableViewController {
    func showHudForTable(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        hud.isUserInteractionEnabled = false
        hud.layer.zPosition = 2
        self.tableView.layer.zPosition = 1
    }
}

extension UIViewController {
    func showHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        hud.isUserInteractionEnabled = false
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func pushFrontViewController(){
        let revealController: SWRevealViewController? = revealViewController()
        let navigationController = UINavigationController(rootViewController: self)
        revealController?.pushFrontViewController(navigationController, animated: true)
    }
    
    func setupTblViewHeight(_ arrCount: Int, tableView: UITableView, heightTable: NSLayoutConstraint){
        //        let arrCount : CGFloat = CGFloat(arrLeadList.count)
        tableView.frame.size.height = tableView.rowHeight * CGFloat(arrCount)
        //        heightTable.constant = arrCount > 6 ? 480.0 : tableView.frame.size.height + 10
        if UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" {
            heightTable.constant = arrCount > 6 ? 480.0 : tableView.frame.size.height + 10
            
        } else if UIDevice.current.screenType.rawValue == "iPhone X" {
            heightTable.constant = arrCount > 6 ? 480.0 : tableView.frame.size.height + 10
        }
        else if UIDevice.current.screenType.rawValue == "iPhone 4 or iPhone 4S" {//}|| UIDevice.current.screenType.rawValue == "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"{
            heightTable.constant = arrCount > 4 ? 240 : tableView.frame.size.height + 10
        }
        else{
            heightTable.constant = arrCount > 4 ? 320 : tableView.frame.size.height + 10
        }
        tableView.frame.size.height = heightTable.constant
    }
    
        
    func showAlertControllerAndHideHUD(_ alertMessage: String){
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.hideHUD()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertController(_ message: String){
        let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlertControllerWithAction(_ message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(_ txtField: ACFloatingTextField, errorTextStr : String, showErrorMsg: String){
        txtField.errorText = errorTextStr
        txtField.showError()
        txtField.showError(withText: showErrorMsg)
        txtField.errorTextColor = UIColor.red
    }
    
}

extension UserDefaults {
    func imageForKey(key: String) -> UIImage? {
        var image: UIImage?
        if let imageData = data(forKey: key) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
        }
        return image
    }
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        set(imageData, forKey: key)
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setViewShadow(_ color: UIColor, opacity : Float, radius: CGFloat, offsetWidth: CGFloat, offsetHeight: CGFloat){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)

    }
    
    func setViewShadow(_ opacity : Float, radius: CGFloat, offsetWidth: Int, offsetHeight: Int){
        self.layer.shadowColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
    }
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    
    
}

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    func applyBlurEffect(image: UIImage){
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIBoxBlur")//CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        self.image = blurredImage
        //        return blurredImage
    }
    
//    func imageFromUrl(urlString: String) {
//        if let url = NSURL(string: urlString) {
//            let request = NSURLRequest(url: url as URL)
//            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.mainQueue) {
//                (response: URLResponse?, data: NSData?, error: NSError?) -> Void in
//                if let imageData = data as NSData? {
//                    self.image = UIImage(data: imageData)
//                }
//            }
//        }
//    }
}

extension UITextView {
//    func addBottomBorderWithColor(color: UIColor, height: CGFloat) {
//        let border = UIView()
//        border.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        border.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y+self.frame.height-height, width: self.frame.width, height: height )
//        border.backgroundColor = color
//        self.superview!.insertSubview(border, aboveSubview: self)
//    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.origin.y+self.frame.size.height+1, width: width, height: 1)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UILabel {
    
    func setLabelShadow(_ color: UIColor, opacity : Float, radius: CGFloat, offsetWidth: Int, offsetHeight: Int){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        
    }
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        
        if let insets = padding {
            textWidth -= insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedStringKey.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        
        return contentSize
    }
}

//How to remove duplicate items from an array
//Paul Hudson    February 13th 2018     @twostraws
//
//There are several ways of removing duplicate items from an array, but one of the easiest is with the following extension on Array:

//extension Array where Element: Hashable {
//    func removingDuplicates() -> [Element] {
//        var addedDict = [Element: Bool]()
//        
//        return filter {
//            addedDict.updateValue(true, forKey: $0) == nil
//        }
//    }
//    
//    mutating func removeDuplicates() {
//        self = self.removingDuplicates()
//    }
//}

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}

extension UITapGestureRecognizer{
    func setupTapGesture(_ view: UIView){
//        self = UITapGestureRecognizer(target: self, action: #selector(FloorPlanViewController.myviewTapped(_:)))
        self.numberOfTapsRequired = 1
        self.numberOfTouchesRequired = 1
        view.addGestureRecognizer(self)
        view.isUserInteractionEnabled = true
    }
    
    func setupTapGesture(_ tapGesture: UITapGestureRecognizer, selectorAction: Selector, view: UIView) -> UITapGestureRecognizer{
        var tapGesture1 = tapGesture
        tapGesture1 = UITapGestureRecognizer(target: self, action: selectorAction)
        tapGesture1.setupTapGesture(view)
        return tapGesture1
    }
    func setupTapGesture(_ selectorAction: Selector, view: UIView) -> UITapGestureRecognizer{
        var tapGesture1 = self
        tapGesture1 = UITapGestureRecognizer(target: self, action: selectorAction)
        tapGesture1.setupTapGesture(view)
        return tapGesture1
    }
}

extension CGFloat{
    func calcStringWidth(_ text: String) -> CGFloat{
        let attributes = [NSAttributedStringKey.font:  UIFont(name: FONT_ROBOTO_REGULAR, size: 14)!, NSAttributedStringKey.foregroundColor: UIColor.white as Any] as [NSAttributedStringKey : Any]
        let stringSize: CGSize? = text.size(withAttributes: attributes)
        return (stringSize?.width)! + 20
    }
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case iPad = "iPad"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        case 2048, 1536:
            return .iPad
        default:
            return .unknown
        }
    }
    
    var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
    
    
}


extension UIToolbar {
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}

protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol JSONSerializable: JSONRepresentable {
}

extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()

        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation

            case let value as NSObject:
                representation[label] = value

            default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation as AnyObject
    }
}

extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation

        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
}

