//
//  ContactCell.h
//  ClientMnagement
//
//  Created by maxiaolin0615 on 8/3/14.
//  Copyright (c) 2014 D9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell
{
    IBOutlet UILabel *lbName;
    IBOutlet UILabel *lbPhone;
    IBOutlet UILabel *lbAddress;

}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *address;

@end
