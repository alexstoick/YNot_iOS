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
        NSString * auth_token = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_token"];
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@" , auth_token ]
                          forHTTPHeaderField:@"Authorization"];
    }
    return _manager ;

}

- (void)parseQuestionsWithCompletion:(void (^)(BOOL))completionBlock {

    NSInteger user_id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"] integerValue];
    NSString * url = [NSString stringWithFormat:@"%@/users/%ld" , BaseURL , (long)user_id ] ;

    //[self eraseAllStoredInformation];
    
    NSLog(@"%@" , url ) ;
    [self.manager
            GET:url
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSDictionary * questions = [responseObject valueForKey:@"questions"] ;
            NSMutableArray * questionsArray = [[NSMutableArray alloc] init] ;
            
            for ( NSDictionary * question in questions )
            {
                NSLog(@"%@" , question ) ;
                Question * currentQuestion = [Question MR_findFirstByAttribute:@"question_id"
                                                                     withValue:[question valueForKey:@"id"]];
                if ( currentQuestion == nil )
                {
                    currentQuestion = [Question MR_createEntity] ;
                    currentQuestion.body = [question valueForKey:@"body"] ;
                    currentQuestion.question_id = [question valueForKey:@"id"] ;
                    currentQuestion.posted_by_me = @0 ;
                    currentQuestion.seen = @0;
                    currentQuestion.property_sent = @0 ;
                }
                [questionsArray addObject:currentQuestion];
            }
            
            Question * testQuestion = [Question MR_findFirstByAttribute:@"question_id"
                                                              withValue:@199];
            if ( ! testQuestion )
            {
                testQuestion = [Question MR_createEntity];
                testQuestion.body = @"test q?" ;
                testQuestion.posted_by_me = @1 ;
                testQuestion.seen = @0;
                testQuestion.property_sent = @0 ;
                testQuestion.question_id = @199;
            }
            Answer * testAnswer = [Answer MR_findFirstByAttribute:@"answer_id"
                                                        withValue:@200];
            if ( ! testAnswer )
            {
                testAnswer = [Answer MR_createEntity] ;
                testAnswer.answer_id = @200 ;
                testAnswer.body = @"test answer body text" ;
            }
            testQuestion.answer = testAnswer ;
            self.questionsPosted = [Question MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"posted_by_me = 0"]] ;
            self.questionsReceived = [Question MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"posted_by_me = 1"]];
            [self saveContext] ;
            completionBlock(YES) ;

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completionBlock(NO) ;
        }
    ] ;

}

-(void) eraseAllStoredInformation {
    NSArray * storedQuestions = [Question MR_findAll];
    
    for ( Question * question in storedQuestions)
    {
        [question MR_deleteEntity];
    }
    
    NSArray * storedAnswers = [Answer MR_findAll];
    for ( Answer * answer in storedAnswers )
    {
        [answer MR_deleteEntity];
    }
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
