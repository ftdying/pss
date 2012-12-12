//
//  BDRequest.h
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 11/26/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GET,
    POST
}HttpMethod;

@interface BDRequest : NSObject{
    NSMutableDictionary *queryStrings;
    NSMutableDictionary *body;
}

-(id)initWithUrl:(NSString *)preUrl
       extendUrl:(NSString *)extUrl
      httpMethod:(HttpMethod)httpMtd;
-(void)addQueryStringValue:(NSString *)value
              forKey:(NSString *)key;
-(void)addBody:(id)value
        forKey:(NSString *)key;
-(NSMutableURLRequest *)buildRequest;
-(NSString *)execute;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *extendUrl;
@property (assign, nonatomic) HttpMethod method;

@end
