//
//  LoanModel.h
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

@protocol ExpandedInviteeModel @end

@interface ExpandedInviteeModel : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString<Optional>* familyName;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSString<Optional>* region;
@property (strong, nonatomic) NSString<Optional>* contactNumber;
@property (strong, nonatomic) NSString* photoUrl;
@property (assign, nonatomic) int numberOfPeopleInvited;
@property (assign, nonatomic) int numberOfPeopleBrought;

@end
