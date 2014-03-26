//
//  QuestionDetailViewController.m
//  YNotToday
//
//  Created by Stoica Alexandru on 3/20/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "Answer.h"

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
    if ( self.question.answer )
    {
        self.questionLabel.text = self.question.answer.body ;
        self.questionLabel.layer.borderColor = [UIColor lightGrayColor].CGColor ;
        self.questionLabel.layer.borderWidth = 0.5f ;
        self.questionLabel.editable = false ;
        self.questionLabel.delegate =  self ;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
