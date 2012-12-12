//
//  Action.m
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 12/3/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "Action.h"
#import "Response.h"

#define SERVICE_URL @"https://pcs.baidu.com/rest/2.0/structure"
#define EXTEND_URL_TABLE @"table"
#define METHOD_CREATE @"create"
#define KEY_PARAM @"param"
#define KEY_METHOD @"method"

@implementation Action
@synthesize accessToken = _accessToken;
@synthesize method = _method;
@synthesize request = _request;

-(id)init{
    if (self = [super init]) {
        self.accessToken = nil;
        self.method = nil;
        self.request = [[BDRequest alloc] init];
        self.request.url = SERVICE_URL;
    }
    return self;
}

-(Response *)execute{
    return [[Response alloc] init];
}

@end


@implementation ActionTable

-(id)init{
    if (self = [super init]) {
        self.request.extendUrl = EXTEND_URL_TABLE;
    }
    return self;
}

@end

@implementation ActionTableCreate

-(id)init{
    if (self = [super init]) {
        self.method = METHOD_CREATE;
        self.request.method = POST;
        assert(self.accessToken != nil);
    }
    return self;
}

-(id)initWithTable:(Table *)table{
    if (self = [super init]) {
        self.table = table;
    }
    return self;
}

-(Response *)execute{
    NSString * body = [_table buildCreateBody];
    [self.request addQueryStringValue:self.method forKey:KEY_METHOD];
    [self.request addBody:body forKey:KEY_PARAM];
    return [[Response alloc] initWithRawData:[self.request execute]];
}

@end