//
//  NetInterface.h
//  iGrow
//
//  Created by aurora-IOS on 15/7/17.
//  Copyright (c) 2015年 aurora-IOS. All rights reserved.
//

#ifndef iGrow_NetInterface_h
#define iGrow_NetInterface_h

//接口事件定义
#define TS_INTER_SHARE                  @"/app/share" //分享

#define TS_INTER_LOGIN                  @"/user/login" //登陆
#define TS_INTER_REGISTER               @"/user/register" //Z注册
#define TS_INTER_MINE               @"/user/mine"//我的首页
#define TS_INTER_RESET               @"/user/resetPassword"//重置密码
#define TS_INTER_PASSWPRD_UPDATE               @"/user/updatePassword"//重置密码

#define TS_INTER_HOMELIST               @"/news/listByNear" //首页
#define TS_INTER_STORELIST              @"/news/listByFavorite" //我的收藏
#define TS_INTER_SHOP_NEWS             @"/news/listByShop" //
#define TS_INTER_NEW_PUBLISH            @"/news/publish"//发布
#define TS_INTER_NEW_UPDATE          @"/news/update"//发布


#define TS_INTER_SHOPDETAIL             @"/shop/detail"
//修改信息
#define TS_INTER_SHOP_NAME       @"/shop/updateName"//修改名称
#define TS_INTER_SHOP_TEL       @"/shop/updateTel"//修改电话
#define TS_INTER_SHOP_BRIEF       @"/shop/updateBrief"//修改描述
#define TS_INTER_SHOP_ADDRESS       @"/shop/updateAddress"//修改地址
#define TS_INTER_SHOP_UpdateAvator       @"/shop/updateAvator"//修改地址
#define TS_INTER_SHOP_UPDATEIMAGE       @"/shop/updateImgs"//修改图片



#define TS_INTER_MESSAGES            @"/message/list" //消息列表
#define TS_INTER_MESSAGES_DETAIL            @"/message/get" //消息详情
#define TS_INTER_CARD_LIST            @"/vipCard/list"//会员卡列表
#define TS_INTER_CARD_SETDEfault            @"/vipCard/setDefault"

#define TS_INTER_Coupon_LIST    @"/userCoupon/list" //优惠劵列表
#define TS_INTER_Coupon_REDEEM  @"/userCoupon/redeem" //优惠劵兑换
#define TS_INTER_Coupon_USE  @"/userCoupon/use" //优惠劵兑换


#define TS_INTER_Favorite_Add            @"/favorite/addShop" //收藏
#define TS_INTER_Favorite_Cancel           @"/favorite/cancelShop" //收藏



#define TS_INTER_GetToken           @"/imgServer/getToken"//获取token









#endif
