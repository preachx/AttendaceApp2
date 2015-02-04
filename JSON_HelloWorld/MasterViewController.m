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

@interface MasterViewController () {
    AttendanceFeed* _feed;
}
@end

@implementation MasterViewController

-(void)viewDidAppear:(BOOL)animated
{
    //show loader view
    [HUD showUIBlockingIndicatorWithText:@"Fetching Data"];
    
    //fetch the feed
    _feed = [[AttendanceFeed alloc] initFromURLWithString:@"http://localhost:3000/events/search?event_id=1&name=a&region=&family_name="
                                         completion:^(JSONModel *model, JSONModelError *err) {
                                             
                                             //hide the loader view
                                             [HUD hideUIBlockingIndicator];
                                             
                                             //json fetched
                                             NSLog(@"invitees: %@", _feed.invitees);
                                             
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
    return _feed.invitees.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteeModel* invitee = _feed.invitees[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ || %@ || %@ || %@",
                           invitee.name, invitee.familyName, invitee.contactNumber, invitee.region
                           ];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InviteeModel* invitee = _feed.invitees[indexPath.row];
    
    NSString* message = [NSString stringWithFormat:@"%@ from %@ %@",
                         invitee.name, invitee.familyName, invitee.category
                         ];
    
    
    [HUD showAlertWithTitle:@"invitee details" text:message];
}


@end
