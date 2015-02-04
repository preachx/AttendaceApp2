//
//  MasterViewController.m
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "JSONModelLib.h"
#import "AttendanceFeed.h"
#import "HUD.h"

static NSString *const BaseWebURL = @"http://localhost:3000/";

@interface MasterViewController () {
    AttendanceFeed* _feed;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNav;
@property (strong,nonatomic) NSMutableArray *filteredInviteeArray;
@property IBOutlet UISearchBar *searchBar;
@end

@implementation MasterViewController

@synthesize filteredInviteeArray;
@synthesize searchBar;

-(void)viewDidAppear:(BOOL)animated
{
    //show loader view
    [HUD showUIBlockingIndicatorWithText:@"Fetching Data"];
    
    NSString *calling_url = [NSString stringWithFormat:@"%@%@",BaseWebURL,@"events/today/invitees"];
    //fetch the feed
    _feed = [[AttendanceFeed alloc] initFromURLWithString:calling_url
                                         completion:^(JSONModel *model, JSONModelError *err) {
                                             
                                             //hide the loader view
                                             [HUD hideUIBlockingIndicator];
                                             
                                             //json fetched
                                             NSLog(@"invitees: %@", _feed.invitees);
                                             NSLog(@"event: %@", _feed.event);
                                             
                                             self.filteredInviteeArray = [NSMutableArray arrayWithCapacity:[_feed.invitees count]];
                                             
                                             self.TitleNav.title = _feed.event.desc;
                                             
                                             [self.tableView reloadData];
                                             
                                         }];

}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredInviteeArray count];
    } else {
        return _feed.invitees.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteeModel* invitee;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        invitee = [filteredInviteeArray objectAtIndex:indexPath.row];
    } else {
        invitee = _feed.invitees[indexPath.row];
    }
//

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ || %@ || %@ || %@",
                           invitee.name, invitee.familyName, invitee.contactNumber, invitee.region
                           ];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteeModel* invitee;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        invitee = filteredInviteeArray[indexPath.row];
    } else {
        invitee = _feed.invitees[indexPath.row];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString* message = [NSString stringWithFormat:@"%@ from %@ %@",
                         invitee.name, invitee.familyName, invitee.category
                         ];
    
    
    [HUD showAlertWithTitle:@"invitee details" text:message];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredInviteeArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@ || SELF.familyName contains[c] %@ || SELF.region contains[c] %@ || SELF.contactNumber contains[c] %@",searchText, searchText, searchText, searchText];
    filteredInviteeArray = [NSMutableArray arrayWithArray:[_feed.invitees filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
