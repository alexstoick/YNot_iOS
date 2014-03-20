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

    NSUserDefaults * userDefaults ;
    NSInteger user_id = (NSInteger)[userDefaults valueForKey:@"user_id"] ;
    NSString * url = [NSString stringWithFormat:@"%@/%d" , BaseURL , user_id ] ;

    [self.manager
            GET:url
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSDictionary * questionsPosted = [responseObject valueForKey:@"questions_posted"] ;
            NSDictionary * questionsReceived = [responseObject valueForKey:@"questions_received"] ;



        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        }
    ] ;

}

@end
