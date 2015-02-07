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
#import "InviteeFeed.h"
#import "MBProgressHUD.h"
#import "HUD.h"

static NSString *const BaseWebURL = @"http://attendancemasterb768.ninefold-apps.com/";

@interface MasterViewController () {
    AttendanceFeed* _feed;
    InviteeFeed* _inviteeFeed;
    MBProgressHUD *hud;
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
    if (_feed.invitees.count == 0) {
        

    //show loader view
    [HUD showUIBlockingIndicatorWithText:@"Fetching Data"];
    
    NSString *calling_url = [NSString stringWithFormat:@"%@%@",BaseWebURL,@"events/today/invitees"];
    //fetch the feed
    _feed = [[AttendanceFeed alloc] initFromURLWithString:calling_url
                                         completion:^(JSONModel *model, JSONModelError *err) {
                                             
                                             //hide the loader view
                                             [HUD hideUIBlockingIndicator];
                                             
                                             NSLog(@"%i",err.code);

                                             switch (err.code) {
                                                 case 1:
                                                 case 3:
                                                 case 4:
                                                     //call out error occurred
                                                     [self showErrorAlert: @"Something went wrong. You sure there is an event today?"];
                                                     break;
                                                 case 2:
                                                    //call out no event today
                                                     [self showErrorAlert: @"Something went wrong. Please try later. Please check the internet connection"];
                                                     break;
                                             }
                                             
                                             //json fetched
                                             NSLog(@"invitees: %@", _feed.invitees);
                                             NSLog(@"event: %@", _feed.event);
                                             
                                             //call out if invitees list is empty
                                             if (err.code == 0 && _feed.invitees.count == 0) {
                                                 [self showErrorAlert: @"No invitees found. Please add them."];
                                             }
                                             
                                             self.filteredInviteeArray = [NSMutableArray arrayWithCapacity:[_feed.invitees count]];
                                             
                                             self.TitleNav.title = _feed.event.desc;
                                             
                                             [self.tableView reloadData];
                                             
                                         }];
    }
}

- (void)showErrorAlert: (NSString *) message {
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.customView = [[UIImageView alloc] initWithImage:
                      [UIImage imageNamed:@"X-Mark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    [hud showWhileExecuting:@selector(waitForTwoSeconds)
                   onTarget:self withObject:nil animated:YES];
}

- (void)showInfoAlert {
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.customView = [[UIImageView alloc] initWithImage:
                      [UIImage imageNamed:@"Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Updated successfully";
    [hud showWhileExecuting:@selector(waitForTwoSeconds)
                   onTarget:self withObject:nil animated:YES];
}

- (void)waitForTwoSeconds {
    sleep(2);
}

- (void)hudWasHidden {
    
    [hud removeFromSuperview];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@",sender);
    DetailViewController *dvc = [segue destinationViewController];
    
    InviteeModel* invitee;

    if ([self.searchDisplayController isActive]) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        invitee = filteredInviteeArray[indexPath.row];
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        invitee = _feed.invitees[indexPath.row];
    }
    
    //show loader view
    [HUD showUIBlockingIndicatorWithText:@"Fetching Data"];
    
    NSString *calling_url = [NSString stringWithFormat:@"%@%@%i/events/%i",BaseWebURL,@"invitee/",invitee.id, _feed.event.id];
    //fetch the feed
    _inviteeFeed = [[InviteeFeed alloc] initFromURLWithString:calling_url
                                                   completion:^(JSONModel *model, JSONModelError *err) {
                                                       
                                                       //hide the loader view
                                                       [HUD hideUIBlockingIndicator];
                                                       
                                                       NSLog(@"invitee: %@", _inviteeFeed.invitee);
                                                       dvc.invitee = _inviteeFeed.invitee;
                                                       dvc.nameLabel.text = _inviteeFeed.invitee.name;
                                                       dvc.familyNameLabel.text = _inviteeFeed.invitee.familyName;
                                                       dvc.numPeopleInvitedLabel.text = [NSString stringWithFormat:@"Number of people Invited: %i", _inviteeFeed.invitee.numberOfPeopleInvited];
                                                       dvc.peopleBroughtTextField.text = [NSString stringWithFormat:@"%i", _inviteeFeed.invitee.numberOfPeopleBrought];
                                                       NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",BaseWebURL,_inviteeFeed.invitee.photoUrl]]];
                                                       dvc.inviteeImage.image = [UIImage imageWithData: imageData];
                                                       dvc.event_id = _feed.event.id;
                                                   }];
    
}

@end
