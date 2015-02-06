//
//  DetailFeed.h
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"
#import "EventInviteeModel.h"

@interface DetailFeed : JSONModel

@property (strong, nonatomic) EventInviteeModel* eventInvitee;

@end
