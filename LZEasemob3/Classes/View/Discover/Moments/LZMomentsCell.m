//
//  LZMomentsCell.m
//  LZEasemob
//
//  Created by nacker on 16/3/11.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsCell.h"
#import "LZMomentsViewModel.h"
//#import "LZMomentsOriginalView.h"

#import "LZMomentsCellCommentBgView.h"
#import "LZOperationMenu.h"

@interface LZMomentsCell()

@end

@implementation LZMomentsCell
{
    // 时间
    UILabel *_timeLabel;
    
    // 回复
    UIButton *_operationButton;
    
    // 分割线
    UIImageView *_divider;
    
    // 回复的tableView
    LZMomentsCellCommentBgView *_commentBgView;
    
    LZOperationMenu *_operationMenu;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 原创微博
    _originalView = [[LZMomentsOriginalView alloc] init];
    
    _timeLabel =  [UILabel labelWithTitle:@"" color:[UIColor lightGrayColor] fontSize:13 alignment:NSTextAlignmentLeft];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _operationMenu = [[LZOperationMenu alloc] init];
    __weak typeof(self) weakSelf = self;
    [_operationMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLickButtonInCell:)]) {
            [weakSelf.delegate didClickLickButtonInCell:weakSelf];
        }
    }];
    [_operationMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:)]) {
            [weakSelf.delegate didClickcCommentButtonInCell:weakSelf];
        }
    }];
    
    // 回复
    _commentBgView = [[LZMomentsCellCommentBgView alloc] init];
    
    // 分割线
    _divider = [[UIImageView alloc] init];
    _divider.alpha = 0.3f;
    _divider.backgroundColor = [UIColor grayColor];

    [self.contentView addSubview:_originalView];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_operationButton];
    [self.contentView addSubview:_divider];
    [self.contentView addSubview:_commentBgView];
    [self.contentView addSubview:_operationMenu];
    
  
//    // 展开点赞+回复按钮
    [_operationMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_operationButton.mas_left).offset(0);
        make.centerY.equalTo(_operationButton);
        make.height.equalTo(@36);
        make.width.equalTo(@0);
    }];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)setViewModel:(LZMomentsViewModel *)viewModel
{
    _viewModel = viewModel;
    _originalView.viewModel = viewModel;
    _originalView.frame = viewModel.originalViewF;
    _originalView.indexPath = self.indexPath;
    
    _timeLabel.text = viewModel.time;
    _timeLabel.frame = viewModel.timeLabelF;
    
    _operationButton.frame = viewModel.operationButtonF;
    
    if (!viewModel.status.commentItemsArray.count && !viewModel.status.likeItemsArray.count) {
        _commentBgView.hidden = YES;
    }else {
        _commentBgView.hidden = NO;
        _commentBgView.viewModel = viewModel;
        _commentBgView.frame = viewModel.commentBgViewF;
    }
    
    _divider.frame = viewModel.dividerF;
}

- (void)operationButtonClicked:(UIButton *)btn
{
    _operationMenu.show = !_operationMenu.isShowing;

    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    UIButton *btn = (UIButton *)[touch view];
    [self operationButtonClicked:btn];
    
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}
@end
