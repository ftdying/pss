//
//  Action.h
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 12/3/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDRequest.h"
#import "Response.h"
#import "Table.h"

@interface Action : NSObject

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) BDRequest *request;


-(Response *)execute;
@end

@interface ActionTable : Action

@end

@interface ActionTableCreate : ActionTable

-(id)initWithTable:(Table *)table;

@property (strong, nonatomic) Table *table;
@end
