//
//  D9ClientAddViewController.h
//  ClientMnagement
//
//  Created by maxiaolin0615 on 8/3/14.
//  Copyright (c) 2014 D9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDao.h"

@interface D9ClientAddViewController : UIViewController
{
    UITextField *ClientName;
    UITextField *ClientPhone;
    UITextField *ClientCompany;
}

@property (strong, nonatomic) IBOutlet UITextField *ClientName;
@property (strong, nonatomic) IBOutlet UITextField *ClientPhone;
@property (strong, nonatomic) IBOutlet UITextField *ClientCompany;

@end
