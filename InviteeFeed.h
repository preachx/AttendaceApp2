//
//  KivaFeed.h
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"
#import "ExpandedInviteeModel.h"

@interface InviteeFeed : JSONModel

@property (strong, nonatomic) ExpandedInviteeModel* invitee;

@end
