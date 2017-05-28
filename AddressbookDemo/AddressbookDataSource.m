//
//  AddressbookDataSource.m
//  AddressbookDemo
//
//  Created by Mike Cohen on 5/26/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

#import "AddressbookDataSource.h"
#import <AddressBook/AddressBook.h>

@interface AddressbookDataSource ()
@property (nonatomic,assign) bool hasAccess;
@end

// yes, I know Addressbook is deprecated, but I want to get rid of the annoying warnings

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


@implementation AddressbookDataSource

- (instancetype)init {
    if (self = [super init]) {
        self.contacts = nil;
        self.hasAccess = (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized);
        self.index = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadContacts:(void(^)()) completion {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY,0), ^{
            CFErrorRef error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            CFArrayRef addressBookRecords = ABAddressBookCopyArrayOfAllPeople(addressBook);
            NSUInteger recordCount = (NSUInteger) CFArrayGetCount(addressBookRecords);
            NSMutableArray *mutableContacts = [NSMutableArray arrayWithCapacity:recordCount];
            for (int i=0; i<recordCount; ++i) {
                ABRecordRef record = CFArrayGetValueAtIndex(addressBookRecords, i);
                // person's name
                NSString *fullName = (NSString *)CFBridgingRelease(ABRecordCopyCompositeName(record));
                // use only the first phone number
                ABMultiValueRef phoneNumbers = ABRecordCopyValue(record, kABPersonPhoneProperty);
                NSString *phoneNumber = (NSString *) CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, 0));
                
                // don't include if no name or phone number
                if (phoneNumber.length > 0 && fullName.length > 0) {
                    NSData *image = (NSData*)CFBridgingRelease(ABPersonCopyImageData(record));
                    NSMutableDictionary *person = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   fullName,@"Name",phoneNumber,@"Phone", nil];
                    if (image) {
                        [person setObject:image forKey:@"Image"];
                    }
                    [mutableContacts addObject:person];
                }
            }
            // sort the contacts
            [mutableContacts sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString *name1 = [obj1 valueForKey:@"Name"];
                NSString *name2 = [obj2 valueForKey:@"Name"];
                return [name1 caseInsensitiveCompare:name2];
            }];
            // build the index
            for (int i=0;i<mutableContacts.count;++i) {
                NSString *key = [[mutableContacts[i] valueForKey:@"Name"]
                                 substringWithRange:NSMakeRange(0, 1)];
                if (nil == [self.index objectForKey:key]) {
                    [self.index setObject:@(i) forKey:key];
                };
            }
            self.contacts = mutableContacts;
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        });
}

- (void)requestAccess:(void(^)(bool granted)) completion {
    if (!self.hasAccess) {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            self.hasAccess = granted;
            if (completion) {
                completion(granted);
            }
        });
    } else {
        if (completion) {
            completion(self.hasAccess);
        }
    }
}

#pragma clamg diagnostic pop

@end
