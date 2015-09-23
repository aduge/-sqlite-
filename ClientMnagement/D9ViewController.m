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
    
    // 实例化DAO
    ContactDao *dao = [[ContactDao alloc] init];
    
    // 获取所有联系人
    listContact = [dao selectAll];
    //初始化搜索结果数组
    searchResult = [[NSMutableArray alloc] init];
    contactNameList = [[NSMutableArray alloc] init];
    //设置状态
    isSearchOn=NO;
    canSelectRow=YES;
    
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
        
        ID=[numberFormatter numberFromString:p.remark];
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        [phoneArray addObject:p.phone];
        NSLog(@"%@",p.remark);
        
        [[SearchCoreManager share]AddContact:ID name:p.name phone:phoneArray];
        //用强制类型转换后的数据ID
        
        [self.contactDic setObject:p forKey:ID];

    }

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    
       //刷新界面？
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
    if (isSearchOn) {
        return [self.searchByName count] + [self.searchByPhone count];

        
    } else {
        return [listContact count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"现在调用的函数是： tableView:cellForRowAtIndexPath:");
    
    static NSString *CellIdentifier = @"Cell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (isSearchOn) {
//        NSString *iname = [searchResult objectAtIndex:indexPath.row];
//        ContactDao *dao =[[ContactDao alloc]init];
//        Contact *p=[dao selectContact:iname];
//        cell.name =iname;
//        cell.address=p.address;
//        cell.phone=p.phone;
//        //搜索时候就传名字值，不搜索的时候传行号
//        self.selectedName=iname;
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
        //        cell.detailTextLabel.text = matchString;
        
        
        return cell;
        
    } else {
        Contact *p = [listContact objectAtIndex:indexPath.row];
        //    NSLog(@"现在的indexPath是： %ld",(long)indexPath.row);
//          Contact *p = [[self.contactDic allValues] objectAtIndex:indexPath.row];
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
        ID=[numberFormatter numberFromString:p.remark];
        [[SearchCoreManager share]DeleteContact:ID];
        [dao deleteContact:p];
        
        // Delete the row from the data source 删除单元格的某一行时，在用动画效果实现删除过程
         [listContact removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        }
    }

#pragma mark - 添加搜索方法与事件

// 事件：搜索框开始输入字符
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 进入搜索状态
    isSearchOn = YES;
    
    // 不能选择行
    canSelectRow = NO;
    
    // 关闭滚动条的显示
    self.utableView.scrollEnabled = NO;
}

// 事件：搜索框中文字发生变化触发
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]>0)
    {
        isSearchOn = YES;
        canSelectRow = YES;
        self.utableView.scrollEnabled = YES;
//        [self searchContactTbleView];
         [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:searchByName phoneMatch:self.searchByPhone];
    }
    else
    {
        isSearchOn = NO;
        canSelectRow = NO;
        self.utableView.scrollEnabled = NO;
    }
    [self.utableView reloadData];
}

// 方法：搜索结果
-(void) searchContactTbleView
{
//    [searchResult removeAllObjects];
//    [contactNameList removeAllObjects];//终于找到没搜一次结果就加一的原因了，因为contactnamelist没有清空
//    NSInteger i;
//    for (i=0; i<[listContact count]; i++) {
//         Contact *p = [listContact objectAtIndex:i];
//        [contactNameList addObject:p.name];
//    }
//   
//    for (NSString *str in contactNameList) {
//        NSRange nameResultsRange=[str rangeOfString:searchBar.text
//                                             options:NSCaseInsensitiveSearch];
//        if(nameResultsRange.length>0)
//            [searchResult addObject:str];
//    }

}

// 事件：键盘上的搜索按钮事件
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [self searchContactTbleView];
}

// 事件：搜索框里取消按钮事件
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearchOn = NO;
    canSelectRow = YES;
    self.utableView.scrollEnabled = YES;
//    self.navigationItem.rightBarButtonItem = nil;
    
    [self.searchBar resignFirstResponder];
    [self.utableView reloadData];
}
#pragma mark-界面跳转传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ClientEditSegue"]) {
        if (isSearchOn) {
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
