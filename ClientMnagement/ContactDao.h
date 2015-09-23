//
//  ContactDao.h
//  listContactCustom
//
//  Created by tony on 12-9-4.
//  Copyright (c) 2012年 chinapcc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// 此处要引用SQLite3的头文件
#import <sqlite3.h>

// 要引用刚刚写的实体类
#import "Contact.h"

// 联系人处理的数据操作类（DAO：Data Access Objects）
@interface ContactDao : NSObject
{
    // 数据库
    sqlite3 *database;
    
    // 返回的是sql解析的结果集
    sqlite3_stmt *statement;
    
    // 返回的错误信息
    char *errorMsg;
    
    // 数据库名称
	NSString *databaseName;
    
    // 数据库路径
	NSString *databasePath;
}

//打开数据库
-(BOOL)open;

//创建数据表
-(BOOL)create;

//增加、删除、修改、查询, 不用我每行注解了吧，大家都懂的
-(BOOL)insert:(Contact *)model;
-(BOOL)deleteALLContact;
-(BOOL)deleteContact:(Contact*)model;
-(BOOL)update:(Contact*)model;

-(NSMutableArray*)selectAll;
-(Contact*)selectContact:(NSString*)person_id;



@end
