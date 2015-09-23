//
//  Contact.h
//  listContactCustom
//
//  Created by tony on 12-9-4.
//  Copyright (c) 2012年 chinapcc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject
{
    NSString *_person_id;
    NSString *_name;
    NSString *_address;
    NSString *_phone;
    NSString *_email;
    NSString *_remark;
}

// 属性：人员编号
@property (strong,nonatomic) NSString *person_id;

// 属性：姓名
@property (strong,nonatomic) NSString *name;

// 属性：地址
@property (strong,nonatomic) NSString *address;

// 属性：电话号码
@property (strong,nonatomic) NSString *phone;

// 属性：电子邮件
@property (strong,nonatomic) NSString *email;

// 属性：备注
@property (strong,nonatomic) NSString *remark;


// 方法：初始化参数
-(id) initWithName:(NSString*)name  Address:(NSString*)address Phone:(NSString*)phone Remark:(NSString*)remark ;


@end
