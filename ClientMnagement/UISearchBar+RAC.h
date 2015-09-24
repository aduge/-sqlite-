//
//  UISearchBar+RAC.h
//  ClientMnagement
//
//  Created by BinqianDu on 9/24/15.
//  Copyright © 2015 D9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (RAC)

- (RACSignal *)rac_textSignal;

- (RACSignal *)rac_isActiveSignal;

@end
