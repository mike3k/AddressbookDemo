//
//  AddressbookDataSource.h
//  AddressbookDemo
//
//  Created by Mike Cohen on 5/26/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressbookDataSource : NSObject

- (void)loadContacts:(void(^)()) completion;
- (void)requestAccess:(void(^)(bool granted)) completion;

@property(nonatomic,strong) NSArray *contacts;

@end
