//
//  QuestionsDataSource.h
//  YNotToday
//
//  Created by Stoica Alexandru on 3/20/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface QuestionsDataSource : NSObject

+(QuestionsDataSource *) getInstance ;
@property (strong,nonatomic) NSArray * questionsPosted ;
@property (strong, nonatomic) NSArray * questionsReceived ;

-(void)parseQuestionsWithCompletion:(void(^)(BOOL)) completionBlock ;

-(void)markSeenForQuestion:(Question * )question withCompletion:(void(^)(BOOL)) completionBlock ;

-(void)addAnswer:(NSString *)answer forQuestion:(Question *)question withCompletion:(void(^)(BOOL)) completionBlock ;

@end
