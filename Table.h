//
//  Table.h
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 11/26/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    COLUMN_STRING,
    COLUMN_INT,
    COLUMN_FLOAT,
    COLUMN_BOOLEAN,
    COLUMN_ARRAY,
    COLUMN_OBJECT,
    COLUMN_NULL,
}ColumnType;

typedef enum {
    ASC = 1,
    DESC = -1,
}Order;

@interface Column : NSObject

-(id)initWithTitle:(NSString *)title
       description:(NSString *)desc
              type:(ColumnType)type
          required:(BOOL)required;
+(NSString *)getColumnType:(ColumnType)type;


@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (assign, nonatomic) ColumnType type;
@property (assign, nonatomic) BOOL required;

@end

@interface Index : NSObject

-(id)initWithTitle:(NSString *)title
       columnTitle:(NSString *)column
             order:(Order)order
            unique:(BOOL)unique;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *columnTitle;
@property (assign, nonatomic) Order order;
@property (assign, nonatomic) BOOL unique;

@end


@interface Table : NSObject{
    NSString *accessToken;
}

-(NSString *)create;
-(void)alter;
-(NSString *)deletePermanently;
-(void)restore;
-(void)describe;


-(id)initWithTitle:(NSString *)title
       accessToken:(NSString *)token;
-(void)addColumnWithTitle:(NSString *)title
              description:(NSString *)desc
                     type:(ColumnType)type
                 required:(BOOL)required;
-(void)addIndexWithTitle:(NSString *)title
             columnTitle:(NSString *)column
                   order:(Order)order
                  unique:(BOOL)unique;
-(NSString *)buildCreateBody;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *column;
@property (strong, nonatomic) NSMutableArray *index;

@end

