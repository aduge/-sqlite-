//
//  UISearchBar+RAC.m
//  ClientMnagement
//
//  Created by BinqianDu on 9/24/15.
//  Copyright © 2015 D9. All rights reserved.
//

#import "UISearchBar+RAC.h"
#import <objc/runtime.h>
@interface UISearchBar()<UISearchBarDelegate>
@end

@implementation UISearchBar (RAC)

- (RACSignal*)rac_textSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    signal = [[self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)]map:^id(RACTuple *tuple) {
        UISearchBar *searchBar = tuple.first;
        return searchBar.text;
    }];
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_ASSIGN);
    return signal;
}

- (RACSignal*)rac_isActiveSignal
{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) {
        return signal;
    }
    RACSignal *searchBarTextDidBeginEditing = [[self rac_signalForSelector:@selector(searchBarTextDidBeginEditing:) fromProtocol:@protocol(UISearchBarDelegate)]mapReplace:@YES];
    RACSignal *searchBarCancelButtonClicked = [[self rac_signalForSelector:@selector(searchBarCancelButtonClicked:) fromProtocol:@protocol(UISearchBarDelegate)]mapReplace:@NO];

    signal = [RACSignal merge:@[searchBarTextDidBeginEditing,searchBarCancelButtonClicked]];
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_ASSIGN);
    return signal;
}
@end
