//
//  TSMessageDetailVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/5.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSMessageDetailVC.h"
#import "TSMessage.h"
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import "CommentLabel.h"
#import "Common.h"
#import "HttpRequestHelper.h"
#import "MyCenterTips.h"
#import "TSUtilties.h"

@interface HttpHandler:NSObject<NSXMLParserDelegate>
@property(nonatomic,copy) XMLSuccess successBlock;
@property(nonatomic,copy) XMLError errorBlock;
@property(nonatomic,strong) NSXMLParser *xmlParser;
@property(nonatomic,strong) NSMutableString *result;
@property(nonatomic,copy) NSString *urlStr;
@end

@implementation HttpHandler
-(void) parser{
    self.xmlParser.delegate = self;
    [self.xmlParser parse];
}
#pragma mark NSXMLParserDelegate

/* 开始解析xml文件，在开始解析xml节点前，通过该方法可以做一些初始化工作 */
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.result = [NSMutableString string];
    NSLog(@"开始解析xml文件");
}

/* 当解析器对象遇到xml的开始标记时，调用这个方法开始解析该节点 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    self.urlStr = [attributeDict objectForKey:@"value"];
    NSLog(@"发现节点");
}

/* 当解析器找到开始标记和结束标记之间的字符时，调用这个方法解析当前节点的所有字符 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.result appendString:string];
    
    NSLog(@"正在解析节点内容");
}

/* 当解析器对象遇到xml的结束标记时，调用这个方法完成解析该节点 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //    NSLog(@"解析节点结束");
}

/* 解析xml出错的处理方法 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if(self.errorBlock){
        self.errorBlock();
    }
    //    NSLog(@"解析xml出错:%@", parseError);
}

/* 解析xml文件结束 */
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(self.successBlock){
        self.successBlock(self.result,self.urlStr);
    }
    NSLog(@"解析xml文件结束");
}
@end


@interface TSMessageDetailVC ()<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong) TSMessage *message;
@end

@implementation TSMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"Message";
    [TSUtilties createLeftReturnButtonBlack:self];
      [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.backgroundColor = [UIColor whiteColor];
//    self.tableview.tableHeaderView = [[UIView alloc]init];
   
    [self refreshNetData];

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)refreshNetData{
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_MESSAGES_DETAIL postData:@{@"id":self.message.objId,@"token":[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@""} backSucess:^(NSDictionary *backData) {
        if(backData){
            self.message.isRead = [NSNumber numberWithBool:YES];
            self.message = [TSMessage objectWithDic:backData];
            [self.tableview reloadData];
        }
    } backFalied:^(id backData) {
        
    } ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell1
    switch (indexPath.row) {
        case 0:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            UILabel *label1 = [cell viewWithTag:1001];
            [label1 setText:@"标    题："];
            UILabel *label2 = [cell viewWithTag:1002];
            [label2 setText:self.message.title];
            return cell;
        }
            
            break;
        case 1:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            UILabel *label1 = [cell viewWithTag:1001];
            [label1 setText:@"发送人："];
            UILabel *label2 = [cell viewWithTag:1002];
            [label2 setText:self.message.from];
            return cell;
        }
            
            break;
        case 2:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            UILabel *label1 = [cell viewWithTag:1001];
            [label1 setText:@"时    间："];
            UILabel *label2 = [cell viewWithTag:1002];
            [label2 setText:self.message.entrydate];
            return cell;
        }
            
            break;
        case 3:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            CommentLabel *label1 = [cell viewWithTag:1003];
            
            [self setLabelContent:label1 andContent:self.message.content];
//            [label1 setText:self.message.content];

            return cell;
        }
            
            break;
            
        default:
            break;
    }
    
    return [[UITableViewCell alloc]init];
}

+(TSMessageDetailVC *)getVC:(TSMessage *)message{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MessageDetail" bundle:nil];
    TSMessageDetailVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"TSMessageDetailVC"];
    vc.message = message;
    return  vc;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}



-(void)setLabelContent:(CommentLabel *)showLabel andContent:(NSString *)content{
    //<request value="http://ec2-54-175-19-148.compute-1.amazonaws.com/tinysquare-api/userCoupon/redeem?code=456">优惠券</request>
    //www.tinysquareapi.com
//    content = @"呵呵,点击领取<request value=\"http://192.168.1.106:8080/tinysquare-api/userCoupon/redeem?code=456\">优惠券</request>";
    NSString *re = @"<request.*</request>";
    NSRange range = [content rangeOfString:re options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        {
            NSString *subStr = [content substringWithRange:range];
            NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:[subStr dataUsingEncoding:NSUTF8StringEncoding]];
            HttpHandler *hander = [[HttpHandler alloc]init];
            hander.successBlock = ^(NSString *title,NSString *urlStr){
                
                NSString *showStr = [content stringByReplacingCharactersInRange:range withString: title];
                NSRange clickRange = NSMakeRange(range.location, [title length]);
                
                NSMutableAttributedString *showAttributedStr =  [[NSMutableAttributedString alloc]initWithString:showStr];
                
                [showAttributedStr addAttribute:NSFontAttributeName value: [UIFont systemFontOfSize:13] range:NSMakeRange(0, [showStr length])];
                [showAttributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_SIGLE(51) range:NSMakeRange(0, [showStr length])];
                [showAttributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(49, 177, 237, 1) range:clickRange];
                
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setLineSpacing:6];
                [showAttributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, showStr.length)];
                [showLabel setAttributedText:showAttributedStr];
                
                [showLabel addAttribute:kLinkString value:urlStr range:clickRange];
                [showLabel setLinkBlock:^(NSString* usrStr) {
                    NSString *blockUrl = usrStr;
                     NSRange range2 =[usrStr rangeOfString:@"?"];
                    if (range2.location != NSNotFound) {
                        NSString *url = [usrStr substringToIndex:range2.location];
                        blockUrl = url;
                        NSString *parms = [usrStr substringFromIndex:range2.location+1];
                        NSArray *parmStrArr = [parms componentsSeparatedByString:@"&"];
                        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
                        for (NSString *parm in parmStrArr) {
                            NSArray *parmArr = [parm componentsSeparatedByString:@"="];
                            if([parmArr count] == 2){
                                [parmDic setObject:parmArr[1] forKey:parmArr[0]];
                            }
                        }
                        [parmDic setObject:[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"" forKey:@"token" ];
                        
                        NSDictionary *blockDic = parmDic;
                        
                        [HttpRequestHelper sendHttpRequestWithFullUrlBlock:blockUrl postData:blockDic backSucess:^(id backData) {
                            [MyCenterTips showTips:backData];
                        } backDelete:^{
                            
                        } backFalied:^(id backData) {
                            
                        } andWithErrorTips:NO];

                
                    }

                    
                    
                    
                    
                    
                }];

            };
            hander.xmlParser = xmlParser;
            [hander parser];
        }
     

        
        return;
        
        NSString *subStr = [content substringWithRange:NSMakeRange(range.location +9, range.length - 19)];
        NSRange range2 =[subStr rangeOfString:@"?"];
        if (range2.location != NSNotFound) {
            NSString *url = [subStr substringToIndex:range2.location-1];
            NSString *parms = [subStr substringFromIndex:range2.location+1];
            NSArray *parmStrArr = [parms componentsSeparatedByString:@"&"];
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            for (NSString *parm in parmStrArr) {
                NSArray *parmArr = [parm componentsSeparatedByString:@"="];
                if([parmArr count] == 2){
                    [parmDic setObject:parmArr[1] forKey:parmArr[0]];
                }
            }
            
            NSString *showClickValue = [parmDic objectForKey:@"value"];
            
            

        }
    }
    else {
        
        [showLabel setText:content];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
