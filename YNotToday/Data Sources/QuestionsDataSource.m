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
            
            self.questionsPosted = [Question MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"posted_by_me = 1"]] ;
            self.questionsReceived = [Question MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"posted_by_me = 0"]];
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
