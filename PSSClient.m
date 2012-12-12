//
//  PSSClient.m
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 12/3/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "PSSClient.h"
#import "Table.h"
#import "BDRequest.h"
#import "JSONKit.h"


#define SERVICE_URL @"https://pcs.baidu.com/rest/2.0/structure"
#define EXTEND_URL_TABLE @"table"

#define METHOD_CREATE @"create"
#define METHOD_DROP @"drop"

#define KEY_PARAM @"param"
#define KEY_OP @"op"
#define KEY_TABLE @"table"
#define KEY_METHOD @"method"
#define KEY_ACCESS_TOKEN @"access_token"

#define VALUE_RECYCLE @"recycled"

@implementation PSSClient
@synthesize accessToken = _accessToken;

-(id)initWithAccessToken:(NSString *)accessToken{
    if (self = [super init]) {
        self.accessToken = accessToken;
    }
    return self;
}

-(Response *)createTable:(Table *)table{
    BDRequest *request = [self buildTableRequestWithHttpMethod:POST];
    NSString * body = [table buildCreateBody];
    [request addQueryStringValue:METHOD_CREATE forKey:KEY_METHOD];
    [request addQueryStringValue:self.accessToken forKey:KEY_ACCESS_TOKEN];
    [request addBody:body forKey:KEY_PARAM];
    return [[Response alloc] initWithRawData:[request execute]];
}

-(Response *)dropTable:(NSString *)tableName
       permanent:(BOOL)permanent{
    BDRequest *request = [self buildTableRequestWithHttpMethod:POST];
    [request addQueryStringValue:METHOD_DROP forKey:KEY_METHOD];
    [request addQueryStringValue:self.accessToken forKey:KEY_ACCESS_TOKEN];
    [request addBody:[self buildTableDeleteBody:tableName permanent:permanent] forKey:KEY_PARAM];
    return [[Response alloc] initWithRawData:[request execute]];
}

-(NSString *)buildTableDeleteBody:(NSString *)tableName
            permanent:(BOOL)permanent{
    if(nil != tableName){
        if (NO == permanent) {
            return [[NSDictionary dictionaryWithObjectsAndKeys:
                     tableName, KEY_TABLE,
                     VALUE_RECYCLE, KEY_OP,
                     nil] JSONString];
        }else{
            return [[NSDictionary dictionaryWithObject:tableName forKey:KEY_TABLE] JSONString];
        }
    }
    return nil;
}

-(Response *)dropTable:(NSString *)tableName{
    return [self dropTable:tableName
                 permanent:YES];
    
}

-(BDRequest *)buildTableRequestWithHttpMethod:(HttpMethod)method{
     return [[BDRequest alloc] initWithUrl:SERVICE_URL
                                 extendUrl:EXTEND_URL_TABLE
                                httpMethod:method];
}

-(BDRequest *)buildRecordRequestWithHttpMethod:(HttpMethod)method{

}
@end