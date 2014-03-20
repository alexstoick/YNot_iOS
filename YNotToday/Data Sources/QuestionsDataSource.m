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

            NSMutableArray * questionPosted = [[NSMutableArray alloc] init] ;

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
                [questionPosted addObject:currentQuestion];
            }
            self.questionsPosted = questionPosted ;
            completionBlock(YES) ;

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completionBlock(NO) ;
        }
    ] ;

}

@end