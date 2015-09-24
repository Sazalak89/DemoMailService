
//
//  Created by Zalak Patel on 22/09/15.
//  Copyright (c) 2015 Solution Analysts Pvt. Ltd. All rights reserved.
//

import UIKit

class UIButtonRounded: UIButton {

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.configureButton()
		
	}
	init(){
		super.init(frame: CGRectZero)
		self.configureButton()
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.configureButton()
	}
	func configureButton() // custom button design
	{
		self.layer.cornerRadius = 6.0
		self.titleLabel?.font = UIFont(name: FONT_CALIBRI_BOLD, size: 22.0)
		self.backgroundColor = UIColor(red: 220.0/255.0, green: 242.0/255.0, blue: 253.0/255.0, alpha: 1.0)
		
	
	}

}
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

