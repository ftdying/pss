//
//  PSSClient.h
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 12/3/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
#import "Table.h"
#import "Record.h"
#import "Query.h"

@interface PSSClient : NSObject

-(id)initWithAccessToken:(NSString *)accessToken;


-(Response *)createTable:(Table *)table;
-(Response *)alertTable:(NSString *)tableName
        addIndexs:(Index *)addIndexs
       dropIndexs:(Index *)dropIndexs;
-(Response *)dropTable:(NSString *)tableName;
-(Response *)dropTable:(NSString *)tableName
       permanent:(BOOL)permanent;
-(void)restoreTable:(NSString *)tableName;
-(void)describeTable:(NSString *)tableName;



-(void)insertRecords:(NSArray *)records toTable:(NSString *)tableName;
-(void)insertRecord:(Record *)record toTable:(NSString *)tableName;

-(void)updateRecords:(NSArray *)records toTable:(NSString *)tableName replace:(BOOL)replace;
-(void)updateRecord:(Record *)record toTable:(NSString *)tableName replace:(BOOL)replace;
-(void)updateRecords:(NSArray *)records toTable:(NSString *)tableName;
-(void)updateRecord:(Record *)record toTable:(NSString *)tableName;

-(void)deleteRecords:(NSArray *)records fromTable:(NSString *)tableName permanent:(BOOL)permanent;
-(void)deleteRecord:(Record *)record fromTable:(NSString *)tableName permanent:(BOOL)permanent;
-(void)deleteRecords:(NSArray *)records fromTable:(NSString *)tableName;
-(void)deleteRecord:(Record *)records fromTable:(NSString *)tableName;

-(void)select:(Query *)query;

-(void)diffTable:(NSString *)tableName withCursor:(NSString *)cursor andFields:(NSArray *)fields;


-(void)listRecycle:(Query *)query;
-(void)restoreRecords:(NSArray *)records inTable:(NSString *)tableName;
-(void)restoreRecord:(NSString *)record inTable:(NSString *)tableName;

@property (strong, nonatomic) NSString *accessToken;

@end
