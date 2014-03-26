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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionLabel;
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
    self.titleLabel.text = self.question.body ;
    self.questionLabel.layer.borderColor = [UIColor lightGrayColor].CGColor ;
    self.questionLabel.layer.borderWidth = 0.5f ;
    if ( self.question.answer )
    {
        self.questionLabel.text = self.question.answer.body ;

        self.questionLabel.editable = false ;
        self.questionLabel.delegate =  self ;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonTouched:(id)sender {
    [self markQuestionAsSeen];
}

- (void) markQuestionAsSeen {

    [ProgressHUD show:@"Marking the question as read ..."];

    [[QuestionsDataSource getInstance] markSeenForQuestion:self.question withCompletion:^(BOOL b) {
        [self.navigationController popViewControllerAnimated:YES];
        [ProgressHUD dismiss];
    }];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self markQuestionAsSeen];
}


@end
