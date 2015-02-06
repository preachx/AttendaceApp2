//
//  EventInviteeModel.m
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "EventInviteeModel.h"

@implementation EventInviteeModel

+(JSONKeyMapper*)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
