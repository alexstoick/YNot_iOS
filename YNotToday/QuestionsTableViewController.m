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
#import "QuestionDetailViewController.h"

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ( [self tableView:tableView numberOfRowsInSection:section] == 0 )
        return 0 ;
    return 21 ;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * headerLabel = [[UILabel alloc] init] ;
    if ( section == 0 )
    {
        if ( [[QuestionsDataSource getInstance].questionsPosted count] == 0 )
            return nil ;
        headerLabel.text = @"   Questions posted" ;
    }
    else
    {
        if ([[QuestionsDataSource getInstance].questionsReceived count] == 0 )
            return nil ;
        headerLabel.text = @"   Questions received" ;
    }
    headerLabel.frame = CGRectMake( 0 , 0 , 320 , 21 ) ;
    headerLabel.font = [UIFont fontWithName:@"Avenir" size:18] ;
    headerLabel.backgroundColor = [UIColor lightGrayColor] ;
    UIView * headerView = [[UIView alloc] init] ;
    [headerView addSubview:headerLabel];
    headerView.layer.borderColor = [UIColor blueColor].CGColor ;
    headerView.layer.borderWidth = 1.0f ;
    return headerView ;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"questionsTableToDetail"] )
    {
        QuestionDetailViewController * questionDetailViewController = [segue destinationViewController] ;
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow] ;
        Question * question = nil ;
        if ( indexPath.section == 0 )
        {
            question = [[QuestionsDataSource getInstance].questionsPosted objectAtIndex:indexPath.row] ;
        }
        if ( indexPath.section == 1)
        {
            question = [[QuestionsDataSource getInstance].questionsReceived objectAtIndex:indexPath.row] ;
        }

        questionDetailViewController.question = question ;
    }
}

@end
