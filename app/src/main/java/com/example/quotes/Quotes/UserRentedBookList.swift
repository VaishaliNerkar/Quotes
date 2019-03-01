//
//	UserRentedBookList.swift
//
//	Create by Harshada Deshmukh on 27/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class UserRentedBookList : NSObject, NSCoding{

	var actualReturnDatetime : String!
	var author : String!
	var bookDeliveredToCustomerOndateTime : String!
	var bookFormat : String!
	var deliveryOption : String!
	var imageUrl : String!
	var isbn : String!
	var noOfPages : String!
	var orderId : String!
	var orderOnDatetime : String!
    var otp : String!
	var pickupDatetime : String!
	var pickupNote : String!
	var productId : String!
	var productName : String!
	var publisher : String!
	var rentedBookId : String!
	var returnedDateTime : String!
	var shortDescription : String!
	var status : String!
	var totalBookCount : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		actualReturnDatetime = json["actualReturnDatetime"].stringValue
		author = json["author"].stringValue
		bookDeliveredToCustomerOndateTime = json["bookDeliveredToCustomerOndateTime"].stringValue
		bookFormat = json["bookFormat"].stringValue
		deliveryOption = json["deliveryOption"].stringValue
		imageUrl = json["imageUrl"].stringValue
		isbn = json["isbn"].stringValue
		noOfPages = json["noOfPages"].stringValue
		orderId = json["orderId"].stringValue
		orderOnDatetime = json["orderOnDatetime"].stringValue
		pickupDatetime = json["pickupDatetime"].stringValue
		pickupNote = json["pickupNote"].stringValue
		productId = json["product_id"].stringValue
		productName = json["product_name"].stringValue
		publisher = json["publisher"].stringValue
		rentedBookId = json["rentedBookId"].stringValue
		returnedDateTime = json["returnedDateTime"].stringValue
		shortDescription = json["short_description"].stringValue
		status = json["status"].stringValue
		totalBookCount = json["totalBookCount"].stringValue
        otp = json["otp"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if actualReturnDatetime != nil{
			dictionary["actualReturnDatetime"] = actualReturnDatetime
		}
		if author != nil{
			dictionary["author"] = author
		}
		if bookDeliveredToCustomerOndateTime != nil{
			dictionary["bookDeliveredToCustomerOndateTime"] = bookDeliveredToCustomerOndateTime
		}
		if bookFormat != nil{
			dictionary["bookFormat"] = bookFormat
		}
		if deliveryOption != nil{
			dictionary["deliveryOption"] = deliveryOption
		}
		if imageUrl != nil{
			dictionary["imageUrl"] = imageUrl
		}
		if isbn != nil{
			dictionary["isbn"] = isbn
		}
		if noOfPages != nil{
			dictionary["noOfPages"] = noOfPages
		}
		if orderId != nil{
			dictionary["orderId"] = orderId
		}
		if orderOnDatetime != nil{
			dictionary["orderOnDatetime"] = orderOnDatetime
		}
		if pickupDatetime != nil{
			dictionary["pickupDatetime"] = pickupDatetime
		}
		if pickupNote != nil{
			dictionary["pickupNote"] = pickupNote
		}
		if productId != nil{
			dictionary["product_id"] = productId
		}
		if productName != nil{
			dictionary["product_name"] = productName
		}
		if publisher != nil{
			dictionary["publisher"] = publisher
		}
		if rentedBookId != nil{
			dictionary["rentedBookId"] = rentedBookId
		}
		if returnedDateTime != nil{
			dictionary["returnedDateTime"] = returnedDateTime
		}
		if shortDescription != nil{
			dictionary["short_description"] = shortDescription
		}
		if status != nil{
			dictionary["status"] = status
		}
		if totalBookCount != nil{
			dictionary["totalBookCount"] = totalBookCount
		}
        if otp != nil{
            dictionary["otp"] = otp
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         actualReturnDatetime = aDecoder.decodeObject(forKey: "actualReturnDatetime") as? String
         author = aDecoder.decodeObject(forKey: "author") as? String
         bookDeliveredToCustomerOndateTime = aDecoder.decodeObject(forKey: "bookDeliveredToCustomerOndateTime") as? String
         bookFormat = aDecoder.decodeObject(forKey: "bookFormat") as? String
         deliveryOption = aDecoder.decodeObject(forKey: "deliveryOption") as? String
         imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
         isbn = aDecoder.decodeObject(forKey: "isbn") as? String
         noOfPages = aDecoder.decodeObject(forKey: "noOfPages") as? String
         orderId = aDecoder.decodeObject(forKey: "orderId") as? String
         orderOnDatetime = aDecoder.decodeObject(forKey: "orderOnDatetime") as? String
         pickupDatetime = aDecoder.decodeObject(forKey: "pickupDatetime") as? String
         pickupNote = aDecoder.decodeObject(forKey: "pickupNote") as? String
         productId = aDecoder.decodeObject(forKey: "product_id") as? String
         productName = aDecoder.decodeObject(forKey: "product_name") as? String
         publisher = aDecoder.decodeObject(forKey: "publisher") as? String
         rentedBookId = aDecoder.decodeObject(forKey: "rentedBookId") as? String
         returnedDateTime = aDecoder.decodeObject(forKey: "returnedDateTime") as? String
         shortDescription = aDecoder.decodeObject(forKey: "short_description") as? String
         status = aDecoder.decodeObject(forKey: "status") as? String
         totalBookCount = aDecoder.decodeObject(forKey: "totalBookCount") as? String
        otp = aDecoder.decodeObject(forKey: "otp") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if actualReturnDatetime != nil{
			aCoder.encode(actualReturnDatetime, forKey: "actualReturnDatetime")
		}
		if author != nil{
			aCoder.encode(author, forKey: "author")
		}
		if bookDeliveredToCustomerOndateTime != nil{
			aCoder.encode(bookDeliveredToCustomerOndateTime, forKey: "bookDeliveredToCustomerOndateTime")
		}
		if bookFormat != nil{
			aCoder.encode(bookFormat, forKey: "bookFormat")
		}
		if deliveryOption != nil{
			aCoder.encode(deliveryOption, forKey: "deliveryOption")
		}
		if imageUrl != nil{
			aCoder.encode(imageUrl, forKey: "imageUrl")
		}
		if isbn != nil{
			aCoder.encode(isbn, forKey: "isbn")
		}
		if noOfPages != nil{
			aCoder.encode(noOfPages, forKey: "noOfPages")
		}
		if orderId != nil{
			aCoder.encode(orderId, forKey: "orderId")
		}
		if orderOnDatetime != nil{
			aCoder.encode(orderOnDatetime, forKey: "orderOnDatetime")
		}
		if pickupDatetime != nil{
			aCoder.encode(pickupDatetime, forKey: "pickupDatetime")
		}
		if pickupNote != nil{
			aCoder.encode(pickupNote, forKey: "pickupNote")
		}
		if productId != nil{
			aCoder.encode(productId, forKey: "product_id")
		}
		if productName != nil{
			aCoder.encode(productName, forKey: "product_name")
		}
		if publisher != nil{
			aCoder.encode(publisher, forKey: "publisher")
		}
		if rentedBookId != nil{
			aCoder.encode(rentedBookId, forKey: "rentedBookId")
		}
		if returnedDateTime != nil{
			aCoder.encode(returnedDateTime, forKey: "returnedDateTime")
		}
		if shortDescription != nil{
			aCoder.encode(shortDescription, forKey: "short_description")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if totalBookCount != nil{
			aCoder.encode(totalBookCount, forKey: "totalBookCount")
		}
        if otp != nil{
            aCoder.encode(otp, forKey: "otp")
        }
	}

}
