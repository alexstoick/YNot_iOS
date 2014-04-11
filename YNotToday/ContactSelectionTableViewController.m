//
//  ContactSelectionTableViewController.m
//  YNotToday
//
//  Created by Stoica Alexandru on 4/11/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import "ContactSelectionTableViewController.h"
#import "ContactsDataSource.h"
#import "Contact.h"
#import "QuestionCreationViewController.h"

@interface ContactSelectionTableViewController ()

@end

@implementation ContactSelectionTableViewController

- (void)viewDidAppear:(BOOL)animated {
    [[ContactsDataSource getInstance] parseContactsWithCompletion:^(BOOL b) {
        [self.tableView reloadData];
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Need to segue to the next view with this contact as the receiver of the
    // question.

}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ContactsDataSource getInstance].contactsInApp count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];

    Contact * currentContact = [[ContactsDataSource getInstance].contactsInApp objectAtIndex:indexPath.row] ;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@" , currentContact.first_name , currentContact.last_name ] ;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"contactSelectionToQuestionCreation"])
    {
        QuestionCreationViewController * destinationController = [segue destinationViewController] ;
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow] ;
        destinationController.receiver = [[ContactsDataSource getInstance].contactsInApp objectAtIndex:indexPath.row] ;
    }
}


@end
