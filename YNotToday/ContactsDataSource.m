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
#import "APAddressBook.h"
#import "APContact.h"
#import "Contact.h"

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

- (void)getContactsListWithCompletion:(void (^)(BOOL))completionBlock {

    // fetch the contact list from the phone

    APAddressBook *addressBook = [[APAddressBook alloc] init];
    addressBook.fieldsMask = APContactFieldFirstName | APContactFieldLastName |
            APContactFieldPhones | APContactFieldThumbnail ;
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };


    [addressBook loadContacts:^(NSArray *contacts, NSError *error)
    {
        // hide activity
        if (!error)
        {
            int i = 0 ;
            for ( APContact * contact in contacts )
            {
                ++ i ;
                // NSLog ( @"%@ %@" , contact.firstName , contact.lastName ) ;
                for ( NSString * phone_number in contact.phones )
                {
                    Contact * contactEntity = [Contact MR_findFirstByAttribute:@"phone_number"
                                                               withValue:phone_number] ;
                    NSNumber * has_app = @0 ;
                    if ( i % 15 == 0 )
                        has_app = @1 ;
                    if ( contactEntity == nil )
                    {
                        contactEntity = [Contact MR_createEntity] ;
                        contactEntity.first_name = contact.firstName ;
                        contactEntity.last_name = contact.lastName ;
                        contactEntity.phone_number = phone_number ;
                        contactEntity.thumbnail = contact.thumbnail ;
                    }
                    contactEntity.has_app = has_app ;
                }
            }
            completionBlock(YES);
        }
        else
        {
            // show error
        }
    }];

}

- (void)parseContactsWithCompletion:(void (^)(BOOL))completionBlock {

    //send the list of contacts to the server
    //get back the list of contacts that are in the app.

    [self getContactsListWithCompletion:^(BOOL b) {

        NSArray * contacts = [Contact MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"has_app = 0"]];
        NSArray * contactsInApp = [Contact MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"has_app = 1"]];
        self.contacts = contacts ;
        self.contactsInApp = contactsInApp ;
        completionBlock(YES);


    }];

}

- (void)inviteContactAtIndex:(NSInteger)index1 withCompletionBlock:(void (^)(BOOL))completionBlock {

    // using the API send a text message to the friend.

}


@end
