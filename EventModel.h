//
//  LoanModel.h
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

@protocol EventModel @end

@interface EventModel : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* eventDate;
@property (strong, nonatomic) NSString* desc;

@end
