//
//  EventInviteeModel.h
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

@protocol EventInviteeModel @end

@interface EventInviteeModel : JSONModel

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int inviteeId;
@property (assign, nonatomic) int eventId;
@property (assign, nonatomic) int numberOfPeopleInvited;
@property (assign, nonatomic) int numberOfPeopleBrought;

@end
