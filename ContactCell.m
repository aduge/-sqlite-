//
//  ContactCell.m
//  ClientMnagement
//
//  Created by maxiaolin0615 on 8/3/14.
//  Copyright (c) 2014 D9. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

@synthesize name;
@synthesize phone;
@synthesize address;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// 重写属性



-(void)setName:(NSString *)n {
    if (![n isEqualToString:name]) {
        name = [n copy];
        lbName.text = name;
    }
}

-(void)setPhone:(NSString *)p {
    if (![p isEqualToString:phone]) {
        phone = [p copy];
        lbPhone.text = phone;
    }
}



-(void)setAddress:(NSString *)a {
    if (![a isEqualToString:address]) {
        address = [a copy];
        lbAddress.text = address;
    }
}


@end