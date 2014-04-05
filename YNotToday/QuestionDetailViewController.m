//
//  QuestionDetailViewController.m
//  YNotToday
//
//  Created by Stoica Alexandru on 3/20/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "Answer.h"
#import "QuestionsDataSource.h"
#import "ProgressHUD.h"

@interface QuestionDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@end

@implementation QuestionDetailViewController

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.questionLabel.text = self.question.body ;
    self.answerTextView.layer.borderColor = [UIColor lightGrayColor].CGColor ;
    self.answerTextView.layer.borderWidth = 0.5f ;
    if ( self.question.answer )
    {
        self.answerTextView.text = self.question.answer.body ;

        self.answerTextView.editable = false ;
        self.answerTextView.delegate =  self ;
    }

}

- (IBAction)doneButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) markQuestionAsSeen {

    [ProgressHUD show:@"Magic happening ..."];

    if ( self.question.answer )
    {
        // This is a posted question. We just need to mark it as read
        [[QuestionsDataSource getInstance] markSeenForQuestion:self.question withCompletion:^(BOOL b) {
            [self.navigationController popViewControllerAnimated:YES];
            [ProgressHUD dismiss];
        }];
    }
    else
    {
        //This is a question received. We need to submit the answer and be done.
        NSString * answer = [self.answerTextView text] ;
        NSLog(@"%@" , answer ) ;
        if ( ! [answer isEqualToString:@""] )
        {
            [[QuestionsDataSource getInstance] addAnswer:answer forQuestion:self.question withCompletion:^(BOOL b) {
                [self.navigationController popViewControllerAnimated:YES];
                [ProgressHUD dismiss];
            } ] ;
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
            [ProgressHUD dismiss];
        }
    }
}

#pragma mark - Navigation

- (void)viewWillDisappear:(BOOL)animated {
    [self markQuestionAsSeen];
}


@end
