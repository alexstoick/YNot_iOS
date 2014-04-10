//
//  Contact.h
//  YNotToday
//
//  Created by Stoica Alexandru on 4/10/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) NSNumber * has_app;

@end
