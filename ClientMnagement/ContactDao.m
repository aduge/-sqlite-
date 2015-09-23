//
//  ContactDao.m
//  listContactCustom
//
//  Created by tony on 12-9-4.
//  Copyright (c) 2012年 chinapcc.com. All rights reserved.
//

#import "ContactDao.h"

@implementation ContactDao

-(id) init
{
    self = [super init];
    if (self)
    {
        databaseName = @"contact.db";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    }
    return self;
}


// 打开数据库文件地址，方法内代码，不需要注解吧，（如果不懂，可以找谷歌老师）
-(BOOL)open
{
    BOOL success = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    if(!success)
    {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        success = YES;
        NSLog(@" 打开数据库成功！");
    }
    else
    {
        success = NO;
        NSLog(@" 打开数据库出错！");
    }
    return success;
}

// 创建表结构
-(BOOL)create
{
    BOOL success = NO;
    // 打开数据库文件
    if([self open])
    {
        // 创建表的SQL语句
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACT(person_id TEXT , NAME TEXT, ADDRESS TEXT, PHONE TEXT,ID INTEGER PRIMARY KEY AUTOINCREMENT)";
        // 执行创建表的语句
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errorMsg) == SQLITE_OK)
        {
            success = YES;
        }
        else
        {
            NSLog(@" 执行出错:%s ",errorMsg);
            sqlite3_free(errorMsg);  // 释放错误信息资源
        }
    } 
    
    // 关闭数据库
    sqlite3_close(database);
    return success;
}

// 方法：新增联系人
-(BOOL)insert:(Contact *)model
{
    BOOL success = NO;
    if([self open])
    {
        NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO CONTACT(person_id, NAME, ADDRESS, PHONE) VALUES ('%@','%@','%@','%@')",model.person_id,model.name, model.address,model.phone];
        const char *query_stmt = [sql UTF8String];
        if (sqlite3_exec(database, query_stmt, NULL, NULL, &errorMsg) == SQLITE_OK)
        {
            NSLog(@"写入数据成功！'%@','%@','%@','%@',",model.person_id,model.name,model.address,model.phone);
            success = YES;
        } else {
            NSLog(@"写入数据失败！%s",errorMsg);
            sqlite3_free(errorMsg);
        }
    } 
    sqlite3_close(database);
    return success;
}


// 方法：删除所有联系人
-(BOOL)deleteALLContact
{
    BOOL success = NO;
    // 打开数据库文件
    if([self open])
    {
        // 删除联系人的SQL语句
        const char *sql_stmt = "DELETE FROM CONTACT";
        // 执行删除联系人的SQL语句
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errorMsg) == SQLITE_OK)
        {
            NSLog(@" 删除所有联系人资料！");
            success = YES;
        }
        else
        {
            NSLog(@" 执行出错:%s ",errorMsg);
            sqlite3_free(errorMsg);  // 释放错误信息资源
        }
    }     
    // 关闭数据库
    sqlite3_close(database);
    return success;
}

// 方法：删除指定的联系人
-(BOOL)deleteContact:(Contact *)model
{
    NSLog(@"delete");
    BOOL success = NO;
    // 打开数据库文件
    if([self open])
    {        
        NSString *sql = [[NSString alloc] initWithFormat:@"DELETE FROM CONTACT WHERE (NAME='%@')",model.name];
        const char *query_stmt = [sql UTF8String];
        // 执行删除联系人的SQL语句
        if (sqlite3_exec(database, query_stmt, NULL, NULL, &errorMsg) == SQLITE_OK)
        {
            NSLog(@" 删除[%@]资料成功！",model.name);
            success = YES;
        }
        else
        {
            NSLog(@" 执行出错:%s ",errorMsg);
            sqlite3_free(errorMsg);  // 释放错误信息资源
        }
    }     
    // 关闭数据库
    sqlite3_close(database);
    return success;
}

// 方法：更新联系人资料
-(BOOL)update:(Contact *)model
{
    BOOL success = NO;
    if([self open])
    {
        NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE CONTACT SET NAME='%@', ADDRESS='%@', PHONE='%@' WHERE (ID='%@') ",model.name, model.address,model.phone,model.remark];
        const char *query_stmt = [sql UTF8String];
        if (sqlite3_exec(database, query_stmt, NULL, NULL, &errorMsg) == SQLITE_OK)
        {
            NSLog(@"更新数据成功！'%@','%@','%@','%@'",model.remark,model.name,model.address,model.phone);
            success = YES;
        } else {
            NSLog(@"更新数据失败！%s",errorMsg);
            sqlite3_free(errorMsg);
        }
    }
    sqlite3_close(database);
    return success;
}

// 方法：列出所有联系人资料
-(NSMutableArray*)selectAll
{
    [self create];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    if([self open])
    {
        // 设置SQL查询语名
        const char *sqlStatement = "SELECT * FROM CONTACT";
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK) {
            // 循环遍历结果并将它们添加到人员列表
            while(sqlite3_step(statement) == SQLITE_ROW) {
                // 从结果行读取数据
                
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString *phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString *remark = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                Contact *person = [[Contact alloc] initWithName:name
                                                                                            Address:address
                                                          Phone:phone Remark:remark
                                                        ];
    
                // 添加对像到数组中
                [list addObject:person];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }     return  list;
}

// 方法：根据人员编号，获取联系人的实体
-(Contact*)selectContact:(NSString*)iname;
{
    Contact *person = [[Contact alloc] init];
    if([self open])
    {
        // 设置SQL查询语名
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from CONTACT where Name like \"%@\"",iname];
        const char *sql = [querySQL UTF8String];
//        const char *sqlStatement = "SELECT * FROM CONTACT WHERE NAME=iname"大爷的这句话有错？不然返回的为什么都是第一行的数据
        
        if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // 取出查询到的第一条记录，返回结果
            if(sqlite3_step(statement) == SQLITE_ROW) {
                // 从结果行读取数据
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString *phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *remark = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                // 创建一个新对像，并且初始化赋值
                person = [[Contact alloc] initWithName:name
                                                  Address:address
                                                  Phone:phone      Remark:remark
                          
                                                ];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    return  person;
}

// 释放资源
-(void) dealloc
{
    database = nil;
    statement = nil;
    databaseName = nil;
    databasePath = nil;
    errorMsg = nil;
}

@end
