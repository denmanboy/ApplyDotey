//
//  InforModel.h
//  ApplyDotey
//
//  Created by dengyanzhou on 15/9/1.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Input;
@interface InforModel : NSObject

@property (nonatomic, copy  ) NSString *code;
@property (nonatomic, copy  ) NSString *logourl;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) NSArray  *input;
@property (nonatomic, copy  ) NSString *logo;
@end
@interface Input : NSObject
@property (nonatomic, copy  ) NSString *key;
@property (nonatomic, copy  ) NSString *value;
@property (nonatomic, copy)  NSString  *text;
@end

