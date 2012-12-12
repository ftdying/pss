//
//  Response.m
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 12/3/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "Response.h"
#import "JSONKit.h"

#define KEY_ERROR_CODE @"error_code"
#define KEY_ERROR_MESSAGE @"error_msg"

#pragma mark Response Base

@interface Response ()

-(void)parseError;

@property (strong, nonatomic)NSDictionary *rawDict;

@end

@implementation Response
@synthesize errorCode;
@synthesize errorMsg;
@synthesize rawData;

-(id)init{
    if (self = [super init]) {
        self.errorCode = -1;
        self.errorMsg = nil;
        self.rawData = nil;
        self.rawDict = nil;
    }
    return self;
}

-(id)initWithRawData:(NSString *)data{
    if (self = [self init]) {
        self.rawData = data;
        self.rawDict = [self.rawData objectFromJSONString];
    }
    return self;
}

-(void)parseError{
    if (nil != self.rawData) {
        if(nil != [self.rawDict objectForKey:KEY_ERROR_CODE]){
            self.errorCode = [[self.rawDict objectForKey:KEY_ERROR_CODE] intValue];
            self.errorMsg = [self.rawDict objectForKey:KEY_ERROR_MESSAGE];
        }
    }
}

@end
