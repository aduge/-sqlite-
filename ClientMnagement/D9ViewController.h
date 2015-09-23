//
//  D9ViewController.h
//  ClientMnagement
//
//  Created by maxiaolin0615 on 8/3/14.
//  Copyright (c) 2014 D9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "ContactCell.h"
#import "ContactDao.h"

@interface D9ViewController : UIViewController<UISearchBarDelegate>
{
   NSMutableArray *listContact;
    
    //搜索结果列表
    NSMutableArray *searchResult;
    NSMutableArray *contactNameList;
    
    IBOutlet UISearchBar *searchBar;
    
    BOOL isSearchOn;
    BOOL canSelectRow;
    
}
@property (strong, nonatomic) IBOutlet UITableView *utableView;

@property (nonatomic,retain) UISearchBar *searchBar;

@property NSString *rowSelected;

@property NSString *selectedName;

@property (nonatomic,retain) NSMutableDictionary *contactDic;
@property (nonatomic,retain) NSMutableArray *searchByName;
@property (nonatomic,retain) NSMutableArray *searchByPhone;


@end
