//
//  ContactsTableViewController.m
//  YNotToday
//
//  Created by Stoica Alexandru on 4/10/14.
//  Copyright (c) 2014 Stoica Alexandru. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactsDataSource.h"
#import "Contact.h"

@interface ContactsTableViewController ()

@end

@implementation ContactsTableViewController

- (void)viewDidAppear:(BOOL)animated {

    [[ContactsDataSource getInstance] parseContactsWithCompletion:^(BOOL b) {
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ContactsDataSource getInstance].contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];

    Contact * currentContact = [[ContactsDataSource getInstance].contacts objectAtIndex:indexPath.row] ;

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentContact.first_name , currentContact.last_name ];
    cell.imageView.image = currentContact.thumbnail ;
    [cell.imageView.layer setMasksToBounds:YES];
    [cell.imageView.layer setCornerRadius:20];

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
