//
//  BDRequest.m
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 11/26/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "BDRequest.h"
#import "JSONKit.h"

#define TIME_OUT 10
#define HTTP_METHOD_GET @"get"
#define HTTP_METHOD_POST @"post"
#define KEY_ERROR_CODE @"error_code"
#define KEY_ERROR_MSG @"error_msg"

@implementation BDRequest
@synthesize url;
@synthesize extendUrl;
@synthesize method;

-(id)init{
    if (self = [super init]) {
        queryStrings = [[NSMutableDictionary alloc] init];
        body = [[NSMutableDictionary alloc] init];
        url = nil;
        extendUrl = nil;
        method = GET;
    }
    return self;
}

-(id)initWithUrl:(NSString *)preUrl
       extendUrl:(NSString *)extUrl
      httpMethod:(HttpMethod)httpMtd{
    if (self = [self init]) {
        url = preUrl;
        extendUrl = extUrl;
        method = httpMtd;
    }
    return self;
}

-(void)addBody:(id)value
        forKey:(NSString *)key{
    [body setValue:value forKey:key];
}


-(void)addQueryStringValue:(NSString *)value
                    forKey:(NSString *)key{
    [queryStrings setValue:value forKey:key];
}

-(NSString *)buildUrl{
    NSMutableString *urlRet = [[NSMutableString alloc] init];
    if (nil != url && nil != extendUrl) {
        [urlRet appendFormat:@"%@/%@", url ,extendUrl];
    }
    if ([queryStrings count] > 0) {
        [urlRet appendFormat:@"?%@", [self buildQueryString]];
    }
    return urlRet;
}

-(NSString *)buildQueryString{
    NSMutableString *queryString = [[NSMutableString alloc] init];
    for (NSString *key in [queryStrings allKeys]) {
        [queryString appendFormat:@"%@=%@&", key, [queryStrings objectForKey:key]];
    }
    if ([queryStrings count] > 0) {
         queryString = (NSMutableString*)[queryString substringToIndex:[queryString length] - 1];
    }
    return queryString;
}

-(NSData *)buildBody{
    if (nil != body && [body count] > 0) {
        NSMutableData *bodyData = [[NSMutableData alloc] init];
        NSString *boundary = [self getBoundary];
        NSString *endline = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
        [bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
        
        
        //添加form-data, 如果value是raw data,则存入dataDictionary,稍后处理
        for (NSString *key in [body keyEnumerator]) {
            id value = [body objectForKey:key];
            if ([self isRawData:value]) {
                [dataDictionary setObject:value forKey:key];
                continue;
            }
            NSMutableString *content = [[NSMutableString alloc] init];
            [content appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@%@", key, [body valueForKey:key], endline];
            [bodyData appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        if ([dataDictionary count] > 0){
            for (NSString *key in [dataDictionary keyEnumerator]) {
                id value = [body objectForKey:key];
                if ([value isKindOfClass:[UIImage class]])
                {
                    UIImage *imageParam=(UIImage *)value;
                    NSData *imageData = UIImagePNGRepresentation(imageParam);
                    [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"file.png\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                    [bodyData appendData:[[NSString stringWithFormat:@"Content-Type: image/*\r\nContent-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [bodyData appendData:imageData];
                    
                } else {
                    NSData *data = (NSData *)value;
                    [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"file.png\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                    [bodyData appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [bodyData appendData:data];
                }
                [bodyData appendData:[[NSString stringWithFormat:@"\r\n--%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
 
        }
        NSLog(@"data: %@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
        return bodyData;
    }
    return nil;
}

-(BOOL)isRawData:(id)object{
    return ([object isKindOfClass:[NSData class]] || [object isKindOfClass:[UIImage class]]) ? TRUE : FALSE;
}

-(NSMutableURLRequest *)buildRequest{
    NSMutableURLRequest * ret = nil;
    NSString *requestUrl = nil;
    NSURL *destination = nil;
    
    requestUrl = [self buildUrl];
    NSLog(@"url : %@", requestUrl);
    if (requestUrl) {
        destination = [[NSURL alloc] initWithString:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (destination) {
            ret = [[NSMutableURLRequest alloc] initWithURL:destination
                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                            timeoutInterval:TIME_OUT];
        }
    }
    
    if(ret){
        if( GET == method)
        {
            [ret setHTTPMethod:HTTP_METHOD_GET];
        }else if (POST == method) {
            [ret setHTTPMethod:HTTP_METHOD_POST];
            NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", [self getBoundary]];
            [ret addValue:contentType forHTTPHeaderField:@"Content-Type"];
            [ret setHTTPBody:[self buildBody]];
        }
    }
    return ret;
}

-(NSString *)getBoundary{
    NSTimeInterval interval = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *timeStamp = [[NSString alloc] initWithFormat:@"%.f", interval];
    return timeStamp;
}

-(NSString *)execute{
    NSMutableURLRequest *req = [self buildRequest];
    if(req){
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *res = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        int statusCode = [(NSHTTPURLResponse*)response statusCode];
        NSLog(@"%d" , statusCode);
        if(error){
            return [[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:error.code], KEY_ERROR_CODE,
                    error.description, KEY_ERROR_MSG,
                    nil] JSONString];
        }
        
        NSLog(@"response: %@", [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding]);
        if(res){
            NSString * response = [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];
            return response;
        }
        
    }
    return nil;
}

@end
