//
//  D9ViewController.m
//  ClientMnagement
//
//  Created by maxiaolin0615 on 8/3/14.
//  Copyright (c) 2014 D9. All rights reserved.
//

#import "D9ViewController.h"
#import "D9ClientEditViewController.h"
#import "SearchCoreManager.h"
#import "UISearchBar+RAC.h"
@interface D9ViewController ()

@end

@implementation D9ViewController
@synthesize utableView;
@synthesize searchBar;
@synthesize rowSelected;
@synthesize selectedName;
@synthesize contactDic;
@synthesize searchByName;
@synthesize searchByPhone;
- (void)viewDidLoad

{
    [super viewDidLoad];

    [self initDao];
    
	
    //searchBar_RAC
    self.tuple = [[RACTuple alloc]init];
    RAC(self,tuple) = [self rac_liftSelector:@selector(search:) withSignalsFromArray:@[self.searchBar.rac_textSignal]];
    @weakify(self);
    [self.searchBar.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        searchByName = self.tuple.first;
        searchByPhone = self.tuple.second;
        [self.utableView reloadData];
    }];
    
    RAC(self,isSearchOn) = [[self.searchBar rac_isActiveSignal]doNext:^(id x) {
        if ([x boolValue]) {
            //
        } else {
            @strongify(self);
            searchBar.text = @"";
            self.tuple = [self search:@""];
            searchByName = self.tuple.first;
            searchByPhone = self.tuple.second;
            [searchBar resignFirstResponder];
            [self.utableView reloadData];
        }
        
    }];


}
-(void)initDao
{
    // 实例化DAO
    ContactDao *dao = [[ContactDao alloc] init];
    
    // 获取所有联系人
    listContact = [dao selectAll];
    //初始化搜索结果数组
    searchResult = [[NSMutableArray alloc] init];
    contactNameList = [[NSMutableArray alloc] init];
    //设置状态
    _isSearchOn=NO;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    self.contactDic=dic;
    NSMutableArray *nameIDArray = [[NSMutableArray alloc]init];
    self.searchByName=nameIDArray;
    NSMutableArray *phoneIDArray = [[NSMutableArray alloc]init];
    self.searchByPhone=phoneIDArray;
    
    for (int i=0; i<[listContact count]; i++) {
        Contact *p = [listContact objectAtIndex:i];
        //类型转换
        NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc]init];
        NSNumber *ID=[[NSNumber alloc]init];
        
        ID=[numberFormatter numberFromString:p.ID];
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        [phoneArray addObject:p.phone];
        NSLog(@"%@",p.ID);
        
        [[SearchCoreManager share]AddContact:ID name:p.name phone:phoneArray];
        //用强制类型转换后的数据ID
        
        [self.contactDic setObject:p forKey:ID];
        
    }

}

-(void)viewDidAppear:(BOOL)animated{
    
       //刷新界面
    ContactDao *dao = [[ContactDao alloc] init];
    listContact=[dao selectAll];
    [utableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearchOn) {
        return [self.searchByName count] + [self.searchByPhone count];
        } else {
        return [listContact count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (_isSearchOn) {

        NSNumber *localID = nil;
        NSMutableString *matchString = [NSMutableString string];
        NSMutableArray *matchPos = [NSMutableArray array];
        if (indexPath.row < [searchByName count]) {
            localID = [self.searchByName objectAtIndex:indexPath.row];
            
            //姓名匹配 获取对应匹配的拼音串 及高亮位置
            if ([self.searchBar.text length]) {
                [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
            }
        } else {
            localID = [self.searchByPhone objectAtIndex:indexPath.row-[searchByName count]];
            NSMutableArray *matchPhones = [NSMutableArray array];
            
            //号码匹配 获取对应匹配的号码串 及高亮位置
            if ([self.searchBar.text length]) {
                [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
                [matchString appendString:[matchPhones objectAtIndex:0]];
            }
        }
        Contact *p=[[Contact alloc]init];
        p = [contactDic objectForKey:localID];
        NSLog(@"%@",p.name);
        cell.name = p.name;
        self.selectedName = p.name;//搜索到只剩一个人的时候才能准确找到此人，第一个iOSdemo有很多不足的地方
        return cell;
        
    } else {
        Contact *p = [listContact objectAtIndex:indexPath.row];
        cell.name = p.name;  // 显示姓名
        cell.phone = p.phone; // 显示电话
        cell.address = p.address; // 显示通讯地址
       return cell;
    
        }
    
}


#pragma mark-滑动删除效果
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
    }

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //获取选中删除行索引值
        NSInteger row=[indexPath row];
        //通过获取的索引值删除数组中的值
       
        NSLog(@"%ld",(long)row);
        //删除数据库中的对应的值
        ContactDao *dao = [[ContactDao alloc]init];
        Contact *p = [listContact objectAtIndex:(indexPath.row)];
        
        NSLog(@"%@",p.name);
        NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc]init];
        NSNumber *ID=[[NSNumber alloc]init];
        ID=[numberFormatter numberFromString:p.ID];
        [[SearchCoreManager share]DeleteContact:ID];
        [dao deleteContact:p];
        
        // Delete the row from the data source 删除单元格的某一行时，在用动画效果实现删除过程
         [listContact removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        }
    }

-(RACTuple*)search:(NSString*)searchText
{
     [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:searchByName phoneMatch:self.searchByPhone];
    RACTuple *tuple_return = [RACTuple tupleWithObjects:searchByName,searchByPhone, nil];
    return tuple_return;
}


#pragma mark-界面跳转传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ClientEditSegue"]) {
        if (_isSearchOn) {
            UIViewController *viewController = segue.destinationViewController;
            D9ClientEditViewController *d9ClientEditViewController = (D9ClientEditViewController*)viewController;
            //此时传名字值和查找状态
            d9ClientEditViewController.iname=self.selectedName;
            d9ClientEditViewController.isSearchOn=YES;
            NSLog(@"现在的mingzi是： %@",self.selectedName);
        }else{
            
        UIViewController *viewController = segue.destinationViewController;
        D9ClientEditViewController *d9ClientEditViewController = (D9ClientEditViewController *)viewController;
        self.rowSelected=[[NSString alloc]initWithFormat:@"%ld",(long)[self.utableView indexPathForSelectedRow].row];
        d9ClientEditViewController.rowNumber=self.rowSelected;
            d9ClientEditViewController.isSearchOn=NO;
         NSLog(@"现在的indexPath是： %@",self.rowSelected);
        }
    }
    
}

@end
