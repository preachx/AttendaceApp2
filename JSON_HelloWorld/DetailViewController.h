//
//  DetailViewController.h
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandedInviteeModel.h"
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController <MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numPeopleInvitedLabel;
@property (weak, nonatomic) IBOutlet UILabel *numPeopleBroughtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *inviteeImage;
@property (weak, nonatomic) IBOutlet UITextField *peopleBroughtTextField;
@property (strong, nonatomic) ExpandedInviteeModel* invitee;
@property (assign, nonatomic) int event_id;
- (IBAction)updateNumPeopleBrought:(id)sender;

@end
