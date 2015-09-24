//
//  D9ClientEditViewController.m
//  ClientMnagement
//
//  Created by maxiaolin0615 on 8/5/14.
//  Copyright (c) 2014 D9. All rights reserved.
//

#import "D9ClientEditViewController.h"


@interface D9ClientEditViewController ()

@end

@implementation D9ClientEditViewController
@synthesize editClientName;
@synthesize editClientPhone;
@synthesize editClientAddress;
@synthesize rowNumber;
@synthesize ID;
@synthesize isSearchOn;
@synthesize iname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if (isSearchOn) {
        ContactDao *dao=[[ContactDao alloc]init];
        Contact *p=[dao selectContact:iname];//根据名字查找信息       
        self.editClientName.text=p.name;
        self.editClientPhone.text=p.phone;
        self.editClientAddress.text=p.address;
        
        ID=p.ID;

    }else{
    ContactDao *dao=[[ContactDao alloc]init];
    DetailOfContact=[dao selectAll];//detailofcontact就是数据库里的全部信息
    Contact *p = [DetailOfContact objectAtIndex:[self.rowNumber integerValue]];

    self.editClientName.text=p.name;
    self.editClientPhone.text=p.phone;
    self.editClientAddress.text=p.address;
    
        ID=p.ID;
    }
    
    
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editSaveToDataBase:(id)sender {
    ContactDao *dao=[[ContactDao alloc]init];
    Contact *editContact=[[Contact alloc]initWithName:self.editClientName.text Address:self.editClientAddress.text Phone:self.editClientPhone.text ID:ID];
    NSLog(@"现在修改的条目的ID号是""%@",ID);
    [dao update:editContact];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改联系人成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}
@end
