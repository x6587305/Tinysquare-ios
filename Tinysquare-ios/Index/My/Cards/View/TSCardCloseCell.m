//
//  TSCardCloseCell.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/22.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSCardCloseCell.h"
#import "TSCard.h"
#import <Masonry.h>
#import "Common.h"
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import "TSCardVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Addition.h"
@interface TSCardCloseCell ()
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIImageView *backImageView;
@property(nonatomic,strong) UIImageView *headerView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIImageView *rightImageView;
@property(nonatomic,strong) UILabel *detailLabel;
@property(nonatomic,strong) UILabel *pointLabel;
@property(nonatomic,strong) UILabel *timesLabel;
@property(nonatomic,strong) UILabel *numberLabel;
@property(nonatomic,strong) UIButton *setDefaultBtn;

@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,assign) BOOL isFirstDefaule;
@end
@implementation TSCardCloseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UILabel *)numberLabel{
    if(!_numberLabel){
        _numberLabel = [[UILabel alloc]init];
        [_numberLabel setTextColor:[UIColor whiteColor]];
        [self.backView addSubview:_numberLabel];
        [_numberLabel setFont:[UIFont systemFontOfSize:12]];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightImageView.mas_left);
            make.bottom.equalTo(self.backView.mas_bottom).offset(-13);
            
            
        }];

    }
    return _numberLabel;
}

-(UILabel *)timesLabel{
    if(!_timesLabel){
        _timesLabel = [[UILabel alloc]init];
        [_timesLabel setTextColor:[UIColor whiteColor]];
        [self.backView addSubview:_timesLabel];
        [_timesLabel setFont:[UIFont systemFontOfSize:12]];
        [_timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.mas_left);
            make.bottom.equalTo(self.backView.mas_bottom).offset(-13);
            
            
        }];

    }
    return _timesLabel;
}
-(UILabel *)pointLabel{
    if(!_pointLabel){
        _pointLabel = [[UILabel alloc]init];
        [_pointLabel setTextColor:[UIColor whiteColor]];
        [self.backView addSubview:_pointLabel];
        [_pointLabel setFont:[UIFont systemFontOfSize:12]];
        [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.mas_left);
            make.bottom.equalTo(self.backView.mas_bottom).offset(-30);
            
            
        }];

    }
    return _pointLabel;
}

-(UIButton *)setDefaultBtn{
    if(!_setDefaultBtn){
        _setDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
        
        NSAttributedString *att = [[NSAttributedString alloc]initWithString:@"设为默认" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithBool:YES],NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        [_setDefaultBtn setAttributedTitle:att forState:UIControlStateNormal];
        
        [self.backView addSubview:_setDefaultBtn];
        [_setDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headerView.mas_centerY);
            make.right.equalTo(self.rightImageView.mas_left);
            make.width.equalTo(@60);
            make.height.equalTo(@17);
        }];
        
         [_setDefaultBtn addTarget:self action:@selector(setDefaultCard) forControlEvents:UIControlEventTouchUpInside];

    }
    return _setDefaultBtn;
}
-(UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]init];
        [_detailLabel setFont:[UIFont systemFontOfSize:13]];
        [_detailLabel setTextColor:[UIColor whiteColor]];
        [self.backView addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.mas_left);
            make.top.equalTo(self.headerView.mas_bottom).offset(15);
        }];

    }
    return _detailLabel;
}

-(UIImageView *)backImageView{
    if(!_backImageView){
        _backImageView = [[UIImageView alloc]init];
        
        [self.backView addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView.mas_left);
            make.right.equalTo(self.backView.mas_right);
            make.top.equalTo(self.backView.mas_top);
            make.bottom.equalTo(self.backView.mas_bottom);
        }];

    }
    return _backImageView;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        [self.backView addSubview:_nameLabel];
        [_nameLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.mas_right).offset(10);
            make.centerY.equalTo(self.headerView.mas_centerY);
        }];


    }
    return _nameLabel;
}

-(UIImageView *)headerView{
    if(!_headerView){
        _headerView = [[UIImageView alloc]init];
        [self.backView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.left.equalTo(self.backView.mas_left).offset(17);
            make.top.equalTo(self.backView.mas_top).offset(17);
            //            make.centerY.equalTo(backView.mas_centerY);
        }];

    }
    return _headerView;
}

-(UIImageView *)rightImageView{
    if(!_rightImageView){
        _rightImageView = [[UIImageView alloc]init];
        [self.backView addSubview:_rightImageView];
            [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView.mas_right);
            make.centerY.equalTo(self.headerView.mas_centerY);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
            
        }];

    }
    return _rightImageView;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self){
        UIView *backView = [[UIView alloc]init];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@58);
        }];
        backView.layer.cornerRadius = 5;
        backView.clipsToBounds = YES;
        self.backView = backView;
        
       
        
        
    }
    return self;
}

-(void)resetSubFrameAndData:(TSCard *)card andIndexPath:(NSIndexPath *)indexPath{
    self.card = card;
    self.indexPath = indexPath;
    [self.backImageView setImage:nil];
     if(self.isFirstDefaule){
         self.backImageView.backgroundColor = COLOR_RGB(255, 183, 0, 1);
     }else{
         NSArray *colorArr =  @[COLOR_RGB(252, 120, 191, 1),COLOR_RGB(81, 178, 234, 1),COLOR_RGB(253, 91, 114, 1),COLOR_RGB(95, 201, 182, 1)];
         self.backImageView.backgroundColor = colorArr[indexPath.row%4];
     }
    
    if([self.card.img length]>0){
        
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.card.img] placeholderImage: [UIImage imageNamed:@"img_photo_default"]];
    }
   
    
    [self.nameLabel setText:self.card.shopName];
    
    if(self.isFirstDefaule){
        self.setDefaultBtn.hidden = YES;
        self.rightImageView.hidden = YES;
    }else if(self.card.isOpen){
        
          self.rightImageView.hidden = NO;
        [_rightImageView setImage:[UIImage imageNamed:@"arrow_down"]];
        if([self.card.isDefault boolValue]){
            self.setDefaultBtn.hidden = YES;
        }else{
            self.setDefaultBtn.hidden = NO;
        }

    }else{
        self.setDefaultBtn.hidden = YES;
         self.rightImageView.hidden = NO;
          [_rightImageView setImage:[UIImage imageNamed:@"arrow_right"]];
    }
    
    if([card.brief length] >0&&(self.card.isOpen || self.isFirstDefaule)){
        self.detailLabel.hidden = NO;
        [self.detailLabel setText:card.brief];
    }else{
        self.detailLabel.hidden = YES;

    }
    
    if(card.points&&(self.card.isOpen || self.isFirstDefaule)){
        self.pointLabel.hidden = NO;
        [self.pointLabel setText:[NSString stringWithFormat:@"Points:%d",card.points.intValue]];
    }else{
         self.pointLabel.hidden = YES;
    }
    
    if(card.userTimes &&(self.card.isOpen || self.isFirstDefaule)){
        self.timesLabel.hidden = NO;
        [self.timesLabel setText:[NSString stringWithFormat:@"Visited: %d times",card.userTimes.intValue]];

    }else{
         self.timesLabel.hidden = YES;
    }
    
    if(card.cardNum &&(self.card.isOpen || self.isFirstDefaule)){
        self.numberLabel.hidden = NO;
        [self.numberLabel setText:[NSString stringWithFormat:@"NO.%@",card.cardNum]];
        
    }else{
        self.numberLabel.hidden = YES;
    }
    
    
    
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        if( self.isFirstDefaule){
              make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }else{
              make.bottom.equalTo(self.contentView.mas_bottom);
        }
      //600 - 280
        float height = kDeiveWidth * 270.0/600;
        if(self.card.isOpen || self.isFirstDefaule){
             make.height.equalTo(@(height));
        }else{
             make.height.equalTo(@58);
        }
       
    }];

}


static NSString *cellId = @"TSCardCloseCell";
+(void)registTableViewCell:(UITableView *)tableview{
    [tableview registerClass:self forCellReuseIdentifier:cellId];
}

+(instancetype) getCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withCards:(TSCard *)card  isFirstDefault:(BOOL) isFirstDefaule{
    TSCardCloseCell *cell =  [tableview dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.isFirstDefaule = isFirstDefaule;
    cell.tableView = tableview;
     [cell resetSubFrameAndData:card andIndexPath:indexPath];
   

    return cell;
}

-(void) update{

    self.card.isOpen = !self.card.isOpen;

    [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];


}

-(void)setDefaultCard{
    TSCard *card = self.card;
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_CARD_SETDEfault postData:@{@"id":self.card.objId,@"token":[[AppDelegate shareAppDelegate] accountwithVC:[self findViewController]].token?:@""} backSucess:^(id backData) {
        [self.vc setTableDefaultCard:card];
        
    }];
    
}


@end
