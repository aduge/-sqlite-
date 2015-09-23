//
//  D9ClientEditViewController.h
//  ClientMnagement
//
//  Created by maxiaolin0615 on 8/5/14.
//  Copyright (c) 2014 D9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDao.h"

@interface D9ClientEditViewController : UIViewController
{   //用来存放数据库信息的表
    NSMutableArray *DetailOfContact;
    
    UITextField *editClientName;
    UITextField *editClientPhone;
    UITextField *editClientCompany;
}
@property (strong, nonatomic) IBOutlet UITextField *editClientName;
@property (strong, nonatomic) IBOutlet UITextField *editClientAddress;
@property (strong, nonatomic) IBOutlet UITextField *editClientPhone;

- (IBAction)editSaveToDataBase:(id)sender;

@property NSString *rowNumber;
@property BOOL isSearchOn;
@property NSString *iname;
//定义全局变量方便取值，remark就是ID值，根据ID值update数据，ID值是自增长主键
@property NSString *remark;

@end
