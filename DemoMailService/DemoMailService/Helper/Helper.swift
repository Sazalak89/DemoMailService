
//
//  Created by Solution Analysts Pvt. Ltd. on 15/05/15.
//  Copyright (c) 2015 Solution Analysts Pvt. Ltd.. All rights reserved.
//

import UIKit
import Foundation

class Helper: NSObject {
    
	
	//MARK:- Display alert view
	/*!
	method displayAlertView
	abstract To Display Alert Msg
	*/
	class  func displayAlertView(title:NSString , message:NSString)
	{
		var alert:UIAlertView = UIAlertView(title: title as String, message: message as String, delegate: self, cancelButtonTitle: "OK")
		alert.show()
	}
	
	
	
}
