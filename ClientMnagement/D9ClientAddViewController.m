//
//  D9ClientAddViewController.m
//  ClientMnagement
//
//  Created by maxiaolin0615 on 8/3/14.
//  Copyright (c) 2014 D9. All rights reserved.
//

#import "D9ClientAddViewController.h"

@interface D9ClientAddViewController ()

@end

@implementation D9ClientAddViewController
@synthesize ClientCompany;
@synthesize ClientName;
@synthesize ClientPhone;
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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SaveToDatabase:(id)sender {
   
    ContactDao *dao =[[ContactDao alloc]init];
    Contact *contact=[[Contact alloc]init] ;
    contact.name=self.ClientName.text;
    contact.phone=self.ClientPhone.text;
    contact.address=self.ClientCompany.text;
    
    [dao insert:contact];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"新增联系人成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}




@end
