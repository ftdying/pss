//
//  BDStructureDataTest.m
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 12/3/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "BDStructureDataTest.h"
#import "BDRequest.h"

@implementation BDStructureDataTest
@synthesize client;

-(id)init{
    if (self = [super init]) {
    self.client = [[PSSClient alloc] initWithAccessToken:@"3.eb55086a4f5b4b3a4cf06b7fee122a0d.2592000.1355373774.3256618109-373211"];
    }
    return self;
}

- (void)testRequest{
    NSString *data = @"{\
\"table\" : \"wife\",\
\"column\" :\
{\
\"id\" :\
{\
\"description\" : \"\",\
\"type\" : \"int\",\
\"required\" : true\
}\
},\
\"index\":\
{\
\"id_index\" :\
{\
\"column\" : {\"id\" : 1}\
}\
}\
}";
    BDRequest *request = [[BDRequest alloc]initWithUrl:@"https://pcs.baidu.com/rest/2.0/structure"
                                             extendUrl:@"table"
                                            httpMethod:POST];
    [request addQueryStringValue:@"create" forKey:@"method"];
    [request addQueryStringValue:@"3.eb55086a4f5b4b3a4cf06b7fee122a0d.2592000.1355373774.3256618109-373211" forKey:@"access_token"];
    [request addBody:data forKey:@"param"];
//    NSString * ret = [request execute];
//    GHTestLog(@"ret: %@", ret);
//    GHAssertNotNil(ret, @"ret should not be nil");
}

- (void)testCreateTable{
    Table *table = [[Table alloc] initWithTitle:@"artists" accessToken:@"3.eb55086a4f5b4b3a4cf06b7fee122a0d.2592000.1355373774.3256618109-373211"];
    [table addColumnWithTitle: @"id" description:@"hello" type:COLUMN_INT required:YES];
    [table addIndexWithTitle: @"id_index" columnTitle:@"id" order:ASC unique:YES];
    Response *response = [self.client createTable:table];
    GHTestLog(response.rawData);
}


@end
