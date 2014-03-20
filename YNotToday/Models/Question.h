//
//  Question.h
//  YNotToday
//
//  Created by Stoica Alexandru on 3/20/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Answer;

@interface Question : NSObject

@property (strong, nonatomic) NSString * body ;
@property (assign, nonatomic) int question_id ;
@property (strong, nonatomic) Answer * answer ;

@end
