//
//  QuestionsDataSource.m
//  YNotToday
//
//  Created by Stoica Alexandru on 3/20/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import "QuestionsDataSource.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "Question.h"
#import "Answer.h"

QuestionsDataSource * _questionsDataSource ;

@interface QuestionsDataSource()

@property (strong,nonatomic) AFHTTPRequestOperationManager * manager ;

@end

@implementation QuestionsDataSource

+ (QuestionsDataSource *)getInstance {
    if ( ! _questionsDataSource )
    {
        _questionsDataSource = [[QuestionsDataSource alloc] init];
    }
    return _questionsDataSource ;
}

-(AFHTTPRequestOperationManager *) manager {
    if ( ! _manager )
    {
        _manager = [AFHTTPRequestOperationManager manager] ;
    }
    return _manager ;

}

- (void)parseQuestionsWithCompletion:(void (^)(BOOL))completionBlock {

    NSInteger user_id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] integerValue];
    NSString * url = [NSString stringWithFormat:@"%@/users/%ld" , BaseURL , (long)user_id ] ;

    NSLog(@"%@" , url ) ;
    [self.manager
            GET:url
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSDictionary * questionsPosted = [responseObject valueForKey:@"questions_posted"] ;
            NSDictionary * questionsReceived = [responseObject valueForKey:@"questions_received"] ;

            NSMutableArray * questionsPostedArray = [[NSMutableArray alloc] init] ;

            for ( NSDictionary * question in questionsPosted )
            {
                Question * currentQuestion = [[Question alloc] init];
                Answer * currentAnswer = nil;
                currentQuestion.body = [question valueForKey:@"body"] ;
                currentQuestion.question_id = (int)[[question valueForKey:@"id"] integerValue] ;
                if ( [[question valueForKey:@"has_answer"] boolValue] )
                {
                    NSDictionary * answer = [question valueForKey:@"answer"] ;

                    currentAnswer = [[Answer alloc] init] ;
                    currentAnswer.body = [answer valueForKey:@"body"] ;
                    currentQuestion.answer = currentAnswer ;
                }
                [questionsPostedArray addObject:currentQuestion];
            }

            NSMutableArray * questionsReceivedArray = [[NSMutableArray alloc] init];

            for ( NSDictionary * question in questionsReceived)
            {
                Question * currentQuestion = [[Question alloc] init];
                currentQuestion.body = [question valueForKey:@"body"] ;
                currentQuestion.question_id = (int)[[question valueForKey:@"id"] integerValue] ;
                currentQuestion.answer = nil ;
                [questionsReceivedArray addObject:currentQuestion];
            }

            self.questionsPosted = questionsPostedArray ;
            self.questionsReceived = questionsReceivedArray ;
            completionBlock(YES) ;

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completionBlock(NO) ;
        }
    ] ;

}

- (void)markSeenForQuestion:(Question *)question withCompletion:(void (^)(BOOL))completionBlock {

    NSString * url = [NSString stringWithFormat:@"%@/questions/%d/seen" , BaseURL , question.question_id ] ;
    [self.manager
            GET:url
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(YES);
    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completionBlock(NO);
    }] ;

}


@end
