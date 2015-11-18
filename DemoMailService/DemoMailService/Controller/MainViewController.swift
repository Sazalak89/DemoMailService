
//
//  Created by Zalak Patel on 22/09/15.
//  Copyright (c) 2015 Solution Analysts Pvt. Ltd. All rights reserved.
//

import UIKit
import MediaPlayer
class MainViewController: UIViewController , UITextFieldDelegate{
	
	
	@IBOutlet weak var IBtxtFieldEmail: UITextField!
	@IBOutlet weak var IBtxtcontact: UITextField!
	var currentTextField:UITextField?
	@IBOutlet weak var IBtxtFieldName: UITextField!
	@IBOutlet weak var IBbtnCheck1: UIButton!
	@IBOutlet weak var IBbtnCheck2: UIButton!
	@IBOutlet weak var IBbtnCheck3: UIButton!
	var dicData:NSMutableDictionary = NSMutableDictionary()
	var isCheckBoxSelected:Bool = false
	var arrService:NSMutableArray = NSMutableArray()
	//MARK:- View life cycle methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(animated: Bool) {
	
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK:- Setting Status bar light
	override func preferredStatusBarStyle() -> UIStatusBarStyle{
		
		return UIStatusBarStyle.LightContent
	}
	
	//MARK:- button action methods
	
	@IBAction func btnCheckBoxClicked(sender: UIButton) {
		if (!sender.selected){
			if sender.tag == 1
			{
				removeSelectionButton(IBbtnCheck2, button2: IBbtnCheck3)
				arrService.addObject(UBER_SERVICE)
			}
			else if sender.tag == 2
			{
				removeSelectionButton(IBbtnCheck1, button2: IBbtnCheck3)
				arrService.addObject(OLA_SERVICE)
			}
			else if sender.tag == 3
			{
				removeSelectionButton(IBbtnCheck1, button2: IBbtnCheck2)
				arrService.addObject(LYFT_SERVICE)
			}
			sender.selected = true
			isCheckBoxSelected = true
		}

	}
	
	func removeSelectionButton(button1:UIButton , button2:UIButton)
	{
		arrService.removeAllObjects()
		button1.selected = false
		button2.selected = false
	}
	@IBAction func btnSubmitClicked(sender: UIButtonRounded) {
		
		
		if !validateAllDetails(){
			
			MBProgressHUD.hideHUDForView(self.view, animated: true)
			return
			
		}
		
//		dicData["name"] = IBtxtFieldName.text as String
//		dicData["email"] = IBtxtFieldEmail.text as String
////		dicData["Contact"] = IBtxtcontact.text
//		dicData["service_name"] = arrService.lastObject as! String
		dicData = ["name": IBtxtFieldName.text as String,"email": IBtxtFieldEmail.text as String,"service_name" : arrService.lastObject as! String]
		println("dicData\(dicData)")
		callWSService(dicData)
	}
	
	// MARK:- TextField Delegate Method
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		var keyboardToolBar:UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
		keyboardToolBar.barStyle = UIBarStyle.Default
		
		keyboardToolBar.items = NSArray(array: [(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)) , (UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("resignKeyboard")))]) as [AnyObject]
		UIBarButtonItem.appearance().tintColor = UIColor.blackColor()
		textField.inputAccessoryView = keyboardToolBar
		currentTextField = textField
		
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		
		if string == "" {
			
			return true
		}
		
		if textField == self.IBtxtFieldName{
			
			if count(self.IBtxtFieldName!.text) >= 12 {
				
				return false
			}
		}
		
		if textField == self.IBtxtcontact {
			let newLength = count(textField.text) + count(string) - range.length
			if newLength <= 12 //AGE
			{
				var cs = NSCharacterSet(charactersInString: ACCEPTABLE_CHARECTERS).invertedSet
				var arrfiltered = string.componentsSeparatedByCharactersInSet(cs) as NSArray
				var filtered = arrfiltered.componentsJoinedByString("") as NSString
				if filtered .isEqualToString(string)
				{
					
					if count(textField.text) == 3 {
						
						textField.text = "\(textField.text)-\(string)"
						
						return false
						
						
					}
					if count(textField.text) == 7 {
						
						textField.text = "\(textField.text)-\(string)"
						
						return false
						
					}
				}
				else
				{
					return false
					
				}
				
			}
			else
			{
				return false
			}
			
		}
		
		return true
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		currentTextField!.resignFirstResponder()
		
		return false
	}

	func resignKeyboard()
	{
		currentTextField!.resignFirstResponder()
	}
	// MARK:- Validation for Details
	func validateAllDetails() -> Bool{
		MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		var str = IBtxtFieldName!.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		
		if str.isEmpty{
			
			IBtxtFieldName!.text = ""
			
			Helper.displayAlertView(ERROR, message: MSG_ERROR_EMPTY_FNAME)
			
			return false
		}
		
		
		str = IBtxtFieldName!.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		
		if (str as NSString).length < 2 || (str as NSString).length > 20{
			
			Helper.displayAlertView(ERROR, message: MSG_ERROR_VALID_FNAME)
			
			return false
		}
		
		
		str = IBtxtFieldEmail!.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		
		if str.isEmpty{
			
			IBtxtFieldEmail!.text = ""
			
			Helper.displayAlertView(ERROR, message: MSG_ERROR_EMPTY_EMAIL)
			
			return false
		}
		
		if !Helper_OBJ.validateEmail(str){
			
			Helper.displayAlertView(ERROR, message: MSG_ERROR_VALID_EMAIL)
			
			return false
		}
		
	
	
		str = IBtxtcontact!.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		
		if str.isEmpty{
			
			IBtxtcontact!.text = ""
			
			Helper.displayAlertView(ERROR, message: MSG_ERROR_EMPTY_MOBILE)
			
			return false
		}
		
		if (str as NSString).length != 12{
			
			Helper.displayAlertView(ERROR, message: MSG_ERROR_VALID_MOBILE)
			
			return false
		}
		if arrService.count < 1
		{
			Helper.displayAlertView(ERROR, message: MSG_ERROR_VALID_SERVICE)
			return false
		}
		return true
	}
	
	func callWSService(dicParams:NSDictionary)
	{
		
		let wsGetMailInfo:WSFrameWork = WSFrameWork(URLAndParams: "", dicParams: dicParams as [NSObject : AnyObject])
		wsGetMailInfo.WSType = kPOST
		wsGetMailInfo.isSync = true
		wsGetMailInfo.isLogging = true
		var DictResponse:NSDictionary = NSDictionary()
		
		wsGetMailInfo.onSuccess = { (dicResponse)  -> Void in
			DictResponse = dicResponse
			MBProgressHUD.hideHUDForView(self.view, animated: true)
			Helper .displayAlertView("Success", message: "Mail has been sent to your email address.. Thank you!!")
	}
		wsGetMailInfo.onError = { (error : NSError!) -> Void in
			MBProgressHUD.hideHUDForView(self.view, animated: true)
			Helper .displayAlertView("", message: "\(error.localizedDescription)")
		}
		wsGetMailInfo.send()
	}
		/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
