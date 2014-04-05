//
//  ContactsDataSource.m
//  YNotToday
//
//  Created by Stoica Alexandru on 4/5/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import <AddressBook/ABAddressBook.h>
#import "AddressBook/ABPerson.h"
#import "ContactsDataSource.h"
#import "AFHTTPRequestOperationManager.h"

ContactsDataSource * _contactsDataSource ;

@interface ContactsDataSource()

@property (strong, nonatomic) AFHTTPRequestOperationManager * manager ;

@end


@implementation ContactsDataSource

+ (ContactsDataSource *)getInstance {
    if ( ! _contactsDataSource )
    {
        _contactsDataSource = [[ContactsDataSource alloc] init];
    }
    return _contactsDataSource ;
}

- (void)getContactList {

    // fetch the contact list from the phone


}

- (void)parseContactsWithCompletion:(void (^)(BOOL))completionBlock {

    //send the list of contacts to the server
    //get back the list of contacts that are in the app.


}

- (void)inviteContactAtIndex:(NSInteger)index1 withCompletionBlock:(void (^)(BOOL))completionBlock {

    // using the API send a text message to the friend.

}


@end
