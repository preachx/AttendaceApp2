//
//  DetailViewController.m
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

static NSString *const BaseWebURL = @"http://localhost:3000/";
#import "DetailViewController.h"
#import "HUD.h"
#import "JSONModelLib.h"
#import "DetailFeed.h"

@interface DetailViewController (){
    DetailFeed *detailFeed;
    MBProgressHUD *hud;
}
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)updateNumPeopleBrought:(id)sender {

    NSString *temp = [_peopleBroughtTextField text];
    if (!isNumericI(temp)) {
        [self showErrorAlert: @"Please enter a number"];
        return;
    }
    if (temp.intValue <= 0) {
        [self showErrorAlert: @"Please enter a number greater than 0"];
        return;
    }

    NSString *urlString = [NSString stringWithFormat: @"%@events/update_invitee_people_count?event_id=%i&invitee_id=%i&number_of_people_brought=%@", BaseWebURL, _event_id, _invitee.id, temp];
    
    //show loader view
    [HUD showUIBlockingIndicatorWithText:@"Fetching Data"];
    
    detailFeed = [[DetailFeed alloc] initFromURLWithString:urlString
                                               completion:^(JSONModel *model, JSONModelError *err) {
                                                   
                                                //hide the loader view
                                                [HUD hideUIBlockingIndicator];
                                                   
                                                 NSLog(@"invitees: %@", detailFeed.eventInvitee);
                                                   
                                                   if(detailFeed.eventInvitee.numberOfPeopleBrought == temp.intValue){
                                                       [self showInfoAlert];
                                                   }else{
                                                       showError(@"Something went wrong. Please try later.");
                                                   }
                                                   
                                               }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

void showError(NSString *errorMessage) {
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Error" message: errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
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

BOOL isNumericI(NSString *s)
{
    NSUInteger len = [s length];
    NSUInteger i;
    BOOL status = NO;
    
    for(i=0; i < len; i++)
    {
        unichar singlechar = [s characterAtIndex: i];
        if ( (singlechar == ' ') && (!status) )
        {
            continue;
        }
        if ( ( singlechar >= '0' ) &&
            ( singlechar <= '9' ) )
        {
            status = YES;
        } else {
            return NO;
        }
    }
    return (i == len) && status;
}

@end
