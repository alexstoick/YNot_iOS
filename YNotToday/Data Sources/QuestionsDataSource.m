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
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"

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

            NSDictionary * questions = [responseObject valueForKey:@"questions"] ;

            NSMutableArray * questionsArray = [[NSMutableArray alloc] init] ;
//            NSArray * storedQuestions = [Question MR_findAll];
//
//            for ( Question * question in storedQuestions)
//            {
//                [question MR_deleteEntity];
//            }
            
            for ( NSDictionary * question in questions )
            {
                Question * currentQuestion = [Question MR_createEntity];
                currentQuestion.body = [question valueForKey:@"body"] ;
                currentQuestion.question_id = [question valueForKey:@"id"] ;
                currentQuestion.posted_by_me = @0 ;
                [questionsArray addObject:currentQuestion];
            }

            Question * testQuestion = [Question MR_createEntity] ;
            testQuestion.body = @"test question?" ;
            testQuestion.question_id = @-1 ;
            testQuestion.posted_by_me = @1 ;

            self.questionsPosted = questionsArray ;
            self.questionsReceived = [Question MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"posted_by_me = 1"]];
            [self saveContext] ;
            completionBlock(YES) ;

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completionBlock(NO) ;
        }
    ] ;

}

- (void)markSeenForQuestion:(Question *)question withCompletion:(void (^)(BOOL))completionBlock {

    NSString * url = [NSString stringWithFormat:@"%@/questions/%@/seen" , BaseURL , question.question_id ] ;
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

- (void)addAnswer:(NSString *)answer forQuestion:(Question *)question withCompletion:(void (^)(BOOL))completionBlock {

    NSString * url = [NSString stringWithFormat:@"%@/questions/%@/answers" , BaseURL , question.question_id ] ;
    NSDictionary * params = [NSDictionary dictionaryWithObject:answer forKey:@"answer" ] ;

    [self.manager
            POST:url
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             completionBlock(YES);
        }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completionBlock(NO) ;
        }
    ] ;
}

- (void)saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}


@end
