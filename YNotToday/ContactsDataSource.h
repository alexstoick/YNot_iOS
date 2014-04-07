//
//  ContactsDataSource.h
//  YNotToday
//
//  Created by Stoica Alexandru on 4/5/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsDataSource : NSObject

+(ContactsDataSource *) getInstance;

@property (strong, nonatomic) NSArray * contacts ;
@property (strong, nonatomic) NSArray * contactsInApp ;

-(void) parseContactsWithCompletion:(void(^)(BOOL)) completionBlock ;

-(void) inviteContactAtIndex: (NSInteger) index withCompletionBlock:(void(^)(BOOL)) completionBlock ;

-(void) getContactsList;

@end
