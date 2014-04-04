//
//  Answer.h
//  YNotToday
//
//  Created by Stoica Alexandru on 4/4/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Answer : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSManagedObject *question;

@end
