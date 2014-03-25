//
//  QuestionsTableViewController.m
//  YNotToday
//
//  Created by Stoica Alexandru on 3/20/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import "QuestionsTableViewController.h"
#import "QuestionsDataSource.h"
#import "Question.h"
#import "Answer.h"

@interface QuestionsTableViewController ()

@end

@implementation QuestionsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init] ;
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self getQuestions];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) getQuestions {

    [self.refreshControl beginRefreshing];
    [[QuestionsDataSource getInstance] parseQuestionsWithCompletion:^(BOOL b) {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];

}

-(void)refresh:(UIRefreshControl *)refreshControl {
    [self getQuestions] ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ( section == 0 )
    {
        return @"Question Posted" ;
    }
    if ( section == 1 )
    {
        return @"Question Received" ;
    }
    return nil ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
        return [[QuestionsDataSource getInstance].questionsPosted count];
    if ( section == 1 )
        return [[QuestionsDataSource getInstance].questionsReceived count];
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];

    if ( indexPath.section == 0 )
    {
        Question * question = [[QuestionsDataSource getInstance].questionsPosted objectAtIndex:indexPath.row] ;
        cell.textLabel.text = question.body ;
        cell.detailTextLabel.text = question.answer.body ;
    }
    if ( indexPath.section == 1)
    {
        Question * question = [[QuestionsDataSource getInstance].questionsReceived objectAtIndex:indexPath.row] ;
        cell.textLabel.text = question.body ;
        cell.detailTextLabel.text = question.answer.body ;
    }

    return cell;
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
