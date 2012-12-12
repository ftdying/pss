//
//  Table.m
//  Baidu_Structure_Data_SDK
//
//  Created by DingYi on 11/26/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "Table.h"
#import "BDRequest.h"
#import "JSONKit.h"

#define KEY_TABLE @"table"
#define KEY_COLUMN @"column"
#define KEY_INDEX @"index"
#define KEY_DESCRIPTION @"description"
#define KEY_TYPE @"type"
#define KEY_REQUIRED @"required"
#define KEY_UNIQUE @"unique"

#define KEY_METHOD @"method"
#define KEY_ACCESS_TOKEN @"access_token"
#define KEY_PARAM @"param"
#define KEY_ERROR_CODE @"error_code"
#define KEY_OP @"op"

#define VALUE_RECYCLE @"recycle"
#define VALUE_METHOD_CREATE @"create"
#define VALUE_METHOD_DELETE @"drop"


#define COLUMN_TYPE_STRING @"string"
#define COLUMN_TYPE_INT @"int"
#define COLUMN_TYPE_FLOAT @"float"
#define COLUMN_TYPE_BOOLEAN @"boolean"
#define COLUMN_TYPE_ARRAY @"array"
#define COLUMN_TYPE_OBJECT @"object"
#define COLUMN_TYPE_NULL @"null"

#define SERVICE_URL @"https://pcs.baidu.com/rest/2.0/structure"
#define EXTEND_URL_TABLE @"table"

@implementation Column
@synthesize title = _title;
@synthesize desc = _desc;
@synthesize required = _required;
@synthesize type = _type;

-(id)init{
    if (self = [super init]) {
        _title = nil;
        _desc = nil;
        _required = NO;
        _type = COLUMN_INT;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title
       description:(NSString *)desc
              type:(ColumnType)type
          required:(BOOL)required{
    if (self = [self init]) {
        _title = title;
        _desc = desc;
        _required = required;
        _type = type;
    }
    return self;
}

+(NSString *)getColumnType:(ColumnType)type{
    NSArray *columnTypes = [NSArray arrayWithObjects:
                            COLUMN_TYPE_STRING,
                            COLUMN_TYPE_INT,
                            COLUMN_TYPE_FLOAT,
                            COLUMN_TYPE_BOOLEAN,
                            COLUMN_TYPE_ARRAY,
                            COLUMN_TYPE_OBJECT,
                            COLUMN_TYPE_NULL,
                            nil];
    return [columnTypes objectAtIndex:type];
}

@end

@implementation Index
@synthesize title = _title;
@synthesize columnTitle = _columnTitle;
@synthesize order = _order;
@synthesize unique = _unique;

-(id)init{
    if (self = [super init]) {
        _title = nil;
        _columnTitle = nil;
        _order = ASC;
        _unique = NO;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title
       columnTitle:(NSString *)column
             order:(Order)order
            unique:(BOOL)unique{
    if (self = [self init]) {
        _title = title;
        _columnTitle = column;
        _order = order;
        _unique = unique;
    }
    return self;
}

@end

@interface Table ()

@property (strong, nonatomic) BDRequest *request;

@end

@implementation Table
@synthesize name = _name;
@synthesize column = _column;
@synthesize index = _index;
@synthesize request = _request;

-(id)init{
    if (self = [super init]) {
        _name = nil;
        _column = [[NSMutableArray alloc] init];
        _index = [[NSMutableArray alloc] init];
        accessToken = nil;
        _request = [[BDRequest alloc] initWithUrl:SERVICE_URL
                                        extendUrl:EXTEND_URL_TABLE
                                       httpMethod:POST];
    }
    return self;
}

-(id)initWithTitle:(NSString *)title
       accessToken:(NSString *)token{
    if (self = [self init]) {
        _name = title;
        accessToken = token;
        [_request addQueryStringValue:accessToken forKey:KEY_ACCESS_TOKEN];
    }
    return self;
}

-(void)addColumnWithTitle:(NSString *)title
              description:(NSString *)desc
                     type:(ColumnType)type
                 required:(BOOL)required{
    Column *column = [[Column alloc] initWithTitle:title
                                       description:desc
                                              type:type
                                          required:required];
    [_column addObject:column];
}

-(void)addIndexWithTitle:(NSString *)title
             columnTitle:(NSString *)column
                   order:(Order)order
                  unique:(BOOL)unique{
    Index *index = [[Index alloc] initWithTitle:title
                                    columnTitle:column
                                          order:order
                                         unique:unique];
    [_index addObject:index];
}

-(NSString *)buildCreateBody{
    NSLog(@"%@", [[_column objectAtIndex:0] title]);
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    if (nil != _name) {
        [ret setValue:_name forKey:KEY_TABLE];
    }
    if ([_column count] > 0) {
        NSMutableDictionary *columns = [NSMutableDictionary dictionary];
        for (Column *c in _column) {
            NSDictionary *column = [NSDictionary dictionaryWithObjectsAndKeys:
                                    c.desc, KEY_DESCRIPTION,
                                    [Column getColumnType:c.type], KEY_TYPE,
                                    [NSNumber numberWithBool:c.required], KEY_REQUIRED,
                                    nil];
            [columns setValue:column forKey:c.title];
        }
        [ret setValue:columns forKey:KEY_COLUMN];
    }
    if ([ _index count] > 0) {
        NSMutableDictionary *indexs = [NSMutableDictionary dictionary];
        for (Index *i in _index) {
            NSDictionary *index = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObject: [NSNumber numberWithInt:i.order] forKey:i.columnTitle], KEY_COLUMN,
                                   [NSNumber numberWithBool:i.unique], KEY_UNIQUE,
                                    nil];
            [indexs setValue:index forKey:i.title];
        }
        [ret setValue:indexs forKey:KEY_INDEX];
    }
    return [ret JSONString];
}

-(NSString *)buildDeleteBody:(BOOL)recycle{
    if(nil != _name){
        if (YES == recycle) {
            return [[NSDictionary dictionaryWithObjectsAndKeys:
                     _name, KEY_TABLE,
                     VALUE_RECYCLE, KEY_OP,
                     nil] JSONString];
        }else{
            return [[NSDictionary dictionaryWithObject:_name forKey:KEY_TABLE] JSONString];
        }
    }
    return nil;
}

-(NSString *)create{
    [_request addQueryStringValue:VALUE_METHOD_CREATE forKey:KEY_METHOD];
    [_request addBody:[self buildCreateBody] forKey:KEY_PARAM];
    return [_request execute];
}

-(NSString *)delete:(BOOL)permanent{
    [_request addQueryStringValue:VALUE_METHOD_DELETE forKey:KEY_METHOD];
    [_request addQueryStringValue:[self buildDeleteBody:permanent]forKey:KEY_PARAM];
    return [_request execute];
}

@end
