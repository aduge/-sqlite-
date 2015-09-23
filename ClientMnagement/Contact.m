//
//  Contact.m
//  listContactCustom
//
//  Created by tony on 12-9-4.
//  Copyright (c) 2012年 chinapcc.com. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize person_id=_person_id;
@synthesize name=_name;
@synthesize address=_address;
@synthesize phone=_phone;
@synthesize email=_email;
@synthesize ID=_ID;


// 方法：初始化参数
-(id) initWithName:(NSString*)name Address:(NSString*)address Phone:(NSString*)phone ID:(NSString *)ID
{
    self = [super init];
    if (self)
    {
        _person_id = [[NSProcessInfo processInfo] globallyUniqueString];  // 获取到一个GUID编号
        _name = name; // 设置姓名
    
        _address = address; // 设置地址
        _phone = phone; // 设置电话
        _ID=ID;
            }
    return self;
}

// 释放内存
-(void) dealloc
{
    self.person_id = nil;
    self.name = nil;
    self.address = nil;
    self.phone = nil;
    self.email = nil;
    self.ID = nil;
}


@end
