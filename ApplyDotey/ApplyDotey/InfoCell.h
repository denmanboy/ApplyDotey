//
//  InfoCell.h
//  ApplyDotey
//
//  Created by dengyanzhou on 15/9/1.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoCell;
@protocol InfoCellDelegate <NSObject>

- (void)textFieldDidEndEditingWithCell:(InfoCell*)cell andTextFeild:(UITextField*)textField;

@end
@interface InfoCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<InfoCellDelegate> delegate;
@end
