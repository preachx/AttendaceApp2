//
//  KivaFeed.h
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"
#import "InviteeModel.h"
#import "EventModel.h"

@interface AttendanceFeed : JSONModel

@property (strong, nonatomic) NSArray<InviteeModel>* invitees;
@property (strong, nonatomic) EventModel *event;

@end
