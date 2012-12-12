//
//  Response.h
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 12/3/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

-(id)initWithRawData:(NSString *)data;

@property (assign, nonatomic) int errorCode;
@property (strong, nonatomic) NSString *errorMsg;
@property (strong, nonatomic) NSString *rawData;

@end
