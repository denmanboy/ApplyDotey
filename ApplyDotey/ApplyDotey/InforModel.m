//
//  InforModel.m
//  ApplyDotey
//
//  Created by dengyanzhou on 15/9/1.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//

#import "InforModel.h"

@implementation InforModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray array];
      [(NSArray*)value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          Input *input = [[Input alloc]init];
          [input setValuesForKeysWithDictionary:(NSDictionary*)obj];
          [array addObject:input];
      }];
        self.input = array;
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{



}
@end
@implementation Input
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
@end