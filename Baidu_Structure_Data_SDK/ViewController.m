//
//  ViewController.m
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 11/26/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "ViewController.h"
#import "BDRequest.h"
#import "Table.h"
#import "Action.h"
#import "PSSClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    [request addQueryStringValue:@"list" forKey:@"method"];
    [request addQueryStringValue:@"3.cfb99baded90acac2aef065d19abc6c5.2592000.1357887494.754976761-248414" forKey:@"access_token"];
//    [request addBody:data forKey:@"param"];
    NSDictionary * ret = [request execute];
//    NSLog(@"ret: %@", ret);
    
//    Table *table = [[Table alloc] initWithTitle:@"artists" accessToken:@"3.eb55086a4f5b4b3a4cf06b7fee122a0d.2592000.1355373774.3256618109-373211"];
//    [table addColumnWithTitle: @"id" description:@"hello" type:COLUMN_INT required:YES];
//    [table addIndexWithTitle: @"id_index" columnTitle:@"id" order:ASC unique:YES];
//    int result = [table deletePermanently];
//    NSLog(@"result : %d", result);
    
    
    
    PSSClient *client = [[PSSClient alloc] initWithAccessToken:@"3.cfb99baded90acac2aef065d19abc6c5.2592000.1357887494.754976761-248414"];
    
    
    Table *table = [[Table alloc] initWithTitle:@"test" accessToken:nil];
    [table addColumnWithTitle: @"id" description:@"hello" type:COLUMN_INT required:YES];
    [table addIndexWithTitle: @"id_index" columnTitle:@"id" order:ASC unique:YES];
//    Response *response = [client createTable:table];
//    Response *response = [client dropTable:@"fdg"];
    [client dropTable:@"student"];
    //    NSLog(response.rawData);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
