//
//  ArticleParser+Other.m
//  SinaNews
//
//  Created by Boris on 15-6-11.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNArticleParser+Other.h"
#import "SNArticle.h"
#import "SNCommonMacro.h"
#import "SNImageUrlManager.h"
#import "SNPoll.h"
#import "JSONKit.h"
//#import "RegexKitLite.h"
#import "SNArticleConstant.h"
#import "SNArticleAppInfo.h"
#import "SNArticleManager+Tag.h"

@implementation SNArticleParser (Other)

#pragma mark - 音频

//原创正文音频，支持多个
- (void)parseAudioListWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
//    NSArray * audioArray = [dict objectDataForKeySafely:@"audioModule"];
//    if ([audioArray isKindOfClass:[NSArray class]])
//    {
//        for(int i = 0;i<[audioArray count];i++)
//        {
//            NSDictionary *audioDictionary = [audioArray objectAtIndexSafely:i];
//            
//            if ([audioDictionary isKindOfClass:[NSDictionary class]])
//            {
//                NSDictionary *data = [audioDictionary objectForKeySafely:@"data"];
//                if ([data isKindOfClass:[NSDictionary class]])
//                {
//                    SNArticleAudio *audio = [[SNArticleAudio alloc] init];
//                    audio.audioTitle = SN_SAFE_STRING([data objectForKeySafely:@"title"]);
//                    audio.audioUrl = SN_SAFE_STRING([data objectForKeySafely:@"url"]);
//                    NSString *audioDuration = [data objectForKeySafely:@"runTime"];
//                    if ([audioDuration respondsToSelector:@selector(longLongValue)])
//                    {
//                        audio.audioDuration = [audioDuration longLongValue];
//                    }
//                    audio.audioIcon = SN_SAFE_STRING([data objectForKeySafely:@"icon"]);
//                    audio.audioIntro = SN_SAFE_STRING([data objectForKeySafely:@"iconText"]);
//                    
//                    article.audio = audio;
//                }
//            }
//            
//            // 替换
//            // 参数: title,icon,intro,时间,链接
//            SNArticleAudio *articleAudio = article.audio;
//            if (articleAudio)
//            {
//                NSString *runtime = [NSString formatPlayTime:articleAudio.audioDuration];
//                NSMutableString *audioHtml = [NSMutableString string];
//                
//                [audioHtml appendFormat:
//                 @"<article data-pl=\"audio\" class=\"M_listennews\">\
//                 <div data-role=\"box\" class=\"listennews listennews_play\">\
//                 <div data-role=\"button\" class=\"video_play video_pause\"></div>\
//                 <div class=\"txt\">\
//                 <div class=\"title\">%@</div>\
//                 <div class=\"img\">\
//                 <img src=\"%@\" data-src=\"%@\"></div>\
//                 <p>%@\
//                 <span class=\"error\" data-role=\"error\"></span> <em data-role=\"time\">%@</em>\
//                 <span class=\"txtaudio\">音频</span>\
//                 <span data-role=\"state\" class=\"audio audio_animation\"></span>\
//                 </p>\
//                 </div>\
//                 <audio data-role=\"audio\" preload=\"\" src=\"%@\"></audio>\
//                 </div>\
//                 </article>",articleAudio.audioTitle,articleAudio.audioIcon,articleAudio.audioIcon,articleAudio.audioIntro,runtime,articleAudio.audioUrl];
//                
//                if ([audioHtml length] > 0)
//                {
//                    NSString *audioReplace = [NSString stringWithFormat:@"<!--{AUDIO_MODULE_%d}-->" ,i+1];
//                    article.content = [article.content stringByReplacingOccurrencesOfString:audioReplace withString:audioHtml];
//                }
//            }
//        }
//    }
}

#pragma mark - 投票
- (void)parsePollWithDict:(NSDictionary *)dict
                inArticle:(SNArticle *)article
              jsonDataArr:(NSMutableArray *)jsonDataArr
{
    NSArray *votes = [dict objectForKeySafely:@"votes"];
    
    if(!CHECK_VALID_ARRAY(votes))
    {
        return;
    }
    //把数据放到jsonData中
    [jsonDataArr addObjectsFromArray:votes];
    
    //    article.jsonData = [NSString stringWithFormat:@"{\"data\":%@}", [votes SNJSONString]];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for(NSDictionary *vote in votes)
    {
        NSDictionary *data = [vote objectForKeySafely:@"data"];
        
        if(CHECK_VALID_DICTIONARY(data))
        {
            SNPoll *poll = [[SNPoll alloc] init];
            poll.pollstate = [data objectForKeySafely:@"pollState"];
            poll.name = SNString([data objectForKeySafely:@"pollName"], @"") ;
            poll.pid = SNString([data objectForKeySafely:@"pollId"], @"");
            poll.vid = SNString([data objectForKeySafely:@"voteId"], @"");
            poll.pollNumber = SNString([data objectForKeySafely:@"voterNum"], @"0");
            //获取questions
            NSArray *allQuestions = [SNPoll parserQuestionsWithDic:[data objectForKeySafely:@"pollResult"]];
            poll.questions = [NSArray arrayWithArray:allQuestions];
            poll.isPKStyle = [[data objectForKeySafely:@"pkStyleFlag"] boolValue];
            [array addObject:poll];
            SN_SAFE_ARC_RELEASE(poll);
        }
    }
    article.pollArray = [NSArray arrayWithArray:array];
}

- (void)handlePollWithArticle:(SNArticle *)article
{
    for(int i=0;i<article.pollArray.count;i++)
    {
        SNPoll *poll = [article.pollArray objectAtIndexSafely:i];
        //对应的占位符
        NSString *tag = [NSString stringWithFormat:@"<!--{VOTE_%d}-->",i+1];
        //投票
        article.content = [article.content stringByReplacingOccurrencesOfString:tag withString:[self constructPollHtml:YES poll:poll]];
    }
}

-(NSString *)constructPollHtml:(BOOL)isOrigin poll:(SNPoll *)poll
{
    if (poll == nil) {
        return @"";
    }
    
    NSString *resultStrFinal = @"";
    
    if(poll.questions.count == 0)
    {
        return @"";
    }
    
    if(poll.isPKStyle)
    {
        SNPollQuestion *question = poll.questions.firstObject;
        
        SNPollAnswer *answer1 = question.answers.firstObject;
        SNPollAnswer *answer2 = question.answers.lastObject;
        
        NSMutableString *html = [NSMutableString string];
        
        //题目
        [html appendFormat:@"<article class=\"M_editor M_pk\" data-pl=\"vote\" data-voteid=\"%@\">",poll.vid];
        [html appendFormat:@"<div class=\"M_tag vtitle\"><span>投票</span></div>"];
        
        [html appendFormat:@"<div class=\"M_s_con\">"];
        [html appendFormat:@"<div class=\"pk_txt\">"];
        [html appendFormat:@"<span class=\"q_icon\">PK</span>"];
        [html appendString:question.name];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"</div>"];
        
        [html appendFormat:@"<div class=\"M_s_con M_s_ans\">"];
        [html appendFormat:@"<div class=\"pk_point\">"];
        
        //正方
        [html appendFormat:@"<div class=\"pk_side up\">"];
        [html appendFormat:@"<div class=\"side\">红方</div>"];
        [html appendFormat:@"<div class=\"attitude\" textlimit-role=\"text\" ui-textlimit>%@</div>",answer1.name];
        [html appendFormat:@"<div class=\"arrow\"></div>"];
        [html appendFormat:@"</div>"];
        
        //反方
        [html appendFormat:@"<div class=\"pk_side down\">"];
        [html appendFormat:@"<div class=\"side\">蓝方</div>"];
        [html appendFormat:@"<div class=\"attitude\" textlimit-role=\"text\" ui-textlimit>%@</div>",answer2.name];
        [html appendFormat:@"<div class=\"arrow\"></div>"];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"<div class=\"vs\">VS</div>"];
        [html appendFormat:@"</div>"];
        
        //操作区
        [html appendFormat:@"<div class=\"pk_act\">"];
        
        [html appendFormat:@"<div class=\"pk_side up\" data-role=\"submit\" type=\"support\" params=\"id:%@;qid:%@;count:%@;\">",answer1.aid,question.qid,answer1.count];
        [html appendFormat:@"<em></em>"];
//        [html appendFormat:@"<span class=\"value\">顶</span>"];
//        [html appendFormat:@"<span class=\"status\"></span>"];
        [html appendFormat:@"</div>"];
        
        [html appendFormat:@"<div class=\"pk_side down\" data-role=\"submit\" type=\"oppose\" params=\"id:%@;qid:%@;count:%@;\">",answer2.aid,question.qid,answer2.count];
        [html appendFormat:@"<em></em>"];
//        [html appendFormat:@"<span class=\"value\">顶</span>"];
//        [html appendFormat:@"<span class=\"status\"></span>"];
        [html appendFormat:@"</div>"];
        
        [html appendFormat:@"<div class=\"bar\">"];
        [html appendFormat:@"<span class=\"up\" vote-up style=\"width:%@%%;\"></span>",answer1.percent];
        [html appendFormat:@"<span class=\"down\" vote-down style=\"width:%@%%;\"></span>",answer2.percent];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"</div>"];
        
        [html appendFormat:@"<div class=\"p_tip p_tip_overdue\" data-role=\"overdueSign\">"];
        [html appendFormat:@"<div class=\"tip\">该投票已过期</div>"];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"<div class=\"p_tip p_tip_voting\" data-role=\"voting\" style=\"display: none;\"><div class=\"tip\">进行中<em>(%@人参与)</em></div></div>",poll.pollNumber];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"</article>"];
        
        resultStrFinal = [NSString stringWithString:html];
    }
    else
    {
//
        NSString *titleHtml = [NSString stringWithFormat:@"<div class=\"M_tag vtitle\">  <span>投票<em data-role=\"voternum\">(%@人参与)</em></span><a data-role=\"toggle\">查看结果</a></div>", [self getTenKString:poll.pollNumber]];
        NSMutableString *resultStr = [[NSMutableString alloc] initWithString:titleHtml];
        NSString *allQuestionsHtml = [self construcQuestionsHtml:poll.questions];
        [resultStr appendFormat:@"<div data-role=\"question\" style=\"\">%@</div>", allQuestionsHtml];
        
        [resultStr appendString:@"<div data-role=\"result\" style=\"display: none;\"></div>"];
        
        
        resultStrFinal = [NSString stringWithFormat:@"<article data-pl=\"vote\" class=\"M_vote\" data-voteid=\"%@\">%@</article>", poll.vid, resultStr];
    }
    
    
    return resultStrFinal;
}

-(NSString *)getTenKString:(NSString *)number
{
    return [NSString numberToXWan:[number intValue]];
}

-(NSString *)construcQuestionsHtml:(NSArray *)questions
{
    NSMutableString *allQuestionsHtml = [[NSMutableString alloc] init];
    
    for (SNPollQuestion *question in questions) {
        
        NSString *questionType = nil;
        if ([question.state intValue] == 0) {
            questionType = @"多选";
        } else {
            questionType = @"单选";
        }
//        <div class="q_title"> <span class="q_icon">多选</span>
//        你如何看待国考报名人数下降？</div>
        NSString *questionTitle = [NSString stringWithFormat:@"<div class=\"q_title\" questionid=\"%@\"> <span class=q_icon>%@</span> %@ </div>", question.qid, questionType, question.name];
        [allQuestionsHtml appendString:questionTitle];
        
        NSString *allAnswer = [self constructAnswersHtml:question.answers andQuestion:question];
        NSString *questionList = [NSString stringWithFormat:@"<ul class=\"list\" qid=\"%@\">%@</ul>", question.qid, allAnswer];
        
        [allQuestionsHtml appendString:questionList];
    }
    
    [allQuestionsHtml appendFormat:@"<div class=\"btn_zone\"><div class=\"btn_q gray\" data-role=\"submit\">提交</div></div>"];
    
    return allQuestionsHtml;
}

-(NSString *)constructAnswersHtml:(NSArray *)answers andQuestion:(SNPollQuestion *)question
{
    int state = [question.state intValue];
    NSMutableString *allAnswer = [[NSMutableString alloc] init];
    for (SNPollAnswer *answer in answers) {
        NSString *btnType = nil;
        if (state == 1) {
            btnType = @"radio";
        } else {
            btnType = @"checkbox";
        }
        
        NSString *answerHtml = [NSString stringWithFormat:@"<li> <input type=\"%@\" id=\"%@\" name=\"%@\"> <label for=\"%@\" class=\"active\"> <span class=\"ico\"></span><span class=\"qtxt\">%@</span> </label> </li>", btnType, answer.aid, question.qid, answer.aid, answer.name];
        [allAnswer appendString:answerHtml];
    }
    return allAnswer;
}

#pragma mark - 直播

//模型化直播
- (void)parseLiveModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
    NSDictionary *dataDic = [dict objectDataForKeySafely:@"liveModule"];
    if(![dataDic isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    NSDictionary *videoDic = [dataDic objectForKeySafely:@"video"];
    if(![videoDic isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    SNArticleVideo *articleVideo = [[SNArticleVideo alloc] init];
    articleVideo.videoTitle = @"";
    articleVideo.pictureUrl = SNString([videoDic objectForKey:@"kpic"], @"");
    
    articleVideo.videoUrl = SNString([videoDic objectForKey:@"url"], @"");
    article.liveVideo = articleVideo;
}

// 由于调用此函数的地方会保证三个参数为有效的NSString,所以此处不做有效性判定.
- (NSString *)liveTagWithText:(NSString *)text withLiveID:(NSString *)liveID withType:(NSString*)type
{
    NSString *liveHtml = [NSString stringWithFormat:@"<div id=\"live\" ui-link=\"method:liveClick;type:%@;match_id:%@\">%@</div>",type,liveID,text];
    
    return liveHtml;
}

- (void)parseLiveWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
    NSDictionary * obj = [dict objectForKeySafely:@"live"];
    
    if(!CHECK_VALID_STRING(article.content))
    {
        return;
    }
    
    if (!CHECK_VALID_DICTIONARY(obj))
    {
        return;
    }
    NSString * text = [SNString([obj objectForKey:@"text"], @"") htmlEntityDecoding];
    NSString * type = SNString([obj objectForKey:@"type"], @"");
    NSString * liveId = SNString([obj objectForKey:@"matchId"], @"");
    
    if (CHECK_VALID_STRING(text) && CHECK_VALID_STRING(type) && CHECK_VALID_STRING(liveId))
    {
        SNArticleLive * live = [[SNArticleLive alloc] init];
        live.liveText = text;
        live.liveType = type;
        live.liveId = liveId;
        
        article.live = live;
        
        NSString * preLive = [self liveTagWithText:text withLiveID:liveId withType:type];
        
        article.content = [preLive stringByAppendingString:article.content];
    }
}

#pragma mark - 相关阅读

- (void)parseRecommendArticlesWithDict:(NSDictionary *)dict
                             inArticle:(SNArticle *)article
                           jsonDataArr:(NSMutableArray *)jsonDataArr;
{
    NSMutableArray * abstractList = [[NSMutableArray alloc] init];
    NSMutableArray * dataList = [[NSMutableArray alloc] init];
    // 解析相关新闻
    NSArray *recommendArray = SNArray([dict objectDataForKeySafely:@"recommend"],nil);
    for (int i = 0;i<recommendArray.count;i++)
    {
        NSDictionary *aRecommendDic  = [recommendArray objectAtIndexSafely:i];
        
        if (CHECK_VALID_DICTIONARY(aRecommendDic))
        {
//            Abstract * abstract = [AbstractsParser createAbstractWithDic:aRecommendDic];
            [abstractList safeAddObject:aRecommendDic];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:aRecommendDic];
            NSString *url = nil;
            url = [SNString([dic objectForKey:@"kpic"], @"") htmlEntityDecoding];
            if(CHECK_VALID_STRING(url))
            {
                NSString *tagId = [SNArticleManager tagIDWithRecommendImageIndex:i];
                
                SNArticleImage * img = [[SNArticleImage alloc] init];
                img.url = url;
                img.width = ArticleRecommendImage_Width;
                img.height = ArticleRecommendImage_Height;
                img.tagId = tagId;
                
                img.needCut = YES;
                img.doZoom = YES;
                
                [article.articleImageArray addObject:img];
                
                [dic setObject:tagId forKey:@"imgID"];
            }
            [dataList addObject:dic];
        }
    }
    
    NSDictionary *jsonData = [NSDictionary dictionaryWithObjectsAndKeys:dataList,@"data",@"recommends",@"type", nil];
    
    [jsonDataArr addObject:jsonData];
    
    article.recommendedAbstractArray = abstractList;
}

#pragma mark - 关键字

- (void)parseKeyWordsWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
//    NSArray *keyWords = SNArray([dict objectDataForKeySafely:@"keys"], nil);
//    
//    if (CHECK_VALID_ARRAY(keyWords))
//    {
//        NSMutableArray *keyWordsArray = [[NSMutableArray alloc] initWithCapacity:[keyWords count]];
//        
//        for (NSString *key in keyWords)
//        {
//            if (CHECK_VALID_STRING(key))
//            {
//                [keyWordsArray addObject:key];
//            }
//        }
//        
//        // 保存keyWordsArray
//        if ([keyWordsArray count] > 0)
//        {
//            article.keys = keyWordsArray;
//        }
//    }
}

+ (NSString *)keywordsTagTemplate:(NSArray *)wordsArray
{
    /*
     <div class="keyword">
     <span>关键词：</span><a href="#">两字</a><a href="#">三个字</a><a href="#">四四个字</a><a href="#">最多五个字</a>
     </div>
     
     */
    NSString * keywords = @"";
    if ([wordsArray count] > 0)
    {
        keywords = @"<div class=\"keyword\"><span>关键词：</span>";
        for (NSString * aword in wordsArray)
        {
            keywords = [keywords stringByAppendingFormat:@"<a href=\"keyword=%@\">%@</a>",aword,aword];
        }
        keywords = [keywords stringByAppendingString:@"</div>"];
    }
    return keywords;
}

#pragma mark - app推广

- (void)parseAppInfosWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
//    if (!CHECK_VALID_DICTIONARY(dict) || nil == article)
//        return;
//    
//    NSDictionary * extInfo = [dict objectForKeySafely:@"extInfo"];
//    
//    if (!CHECK_VALID_DICTIONARY(extInfo))
//        return;
//    
//    NSArray *openAppArray = [extInfo objectDataForKeySafely:@"openApp"];
//    
//    if (CHECK_VALID_ARRAY(openAppArray))
//    {
//        // 创建app信息数组
//        NSMutableArray *articleAppArray = [[NSMutableArray alloc] initWithCapacity:[openAppArray count]];
//        
//        for (NSDictionary* openApp in openAppArray)
//        {
//            if (CHECK_VALID_DICTIONARY(openApp) && [SNArticleAppInfo isValidate:openApp])
//            {
//                SNArticleAppInfo *aai = [[SNArticleAppInfo alloc] initWithInfo:openApp];
//                [articleAppArray safeAddObject:aai];
//            }
//        }
//        
//        if ([articleAppArray count] > 0)
//        {
//            article.openAppArray = articleAppArray;
//        }
//    }
//    
//    NSDictionary *channelDic = [extInfo objectDataForKeySafely:@"channel"];
//    //若频道信息存在
//    if(CHECK_VALID_DICTIONARY(channelDic))
//    {
//        article.channel = [NSDictionary dictionaryWithDictionary:channelDic];
//    }
}

#pragma mark - 深度阅读

- (void)handleDeepReadGroupInArticle:(SNArticle *)conciseArticle
{
    // 有深度模块,进行替换
    if ([conciseArticle.deepReadModuleArray count] > 0)
    {
        int idx = 0;
        for (SNArticleDeepReadGroup * deepGroup in conciseArticle.deepReadModuleArray )
        {
            NSString *deepGroupHtml = [SNArticleParser deepGroupHtmlWithconciseDeepGroup:deepGroup];
            
            conciseArticle.content = [conciseArticle.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:PlaceHolder_DEEP_MODULE,idx+1] withString:deepGroupHtml];
            
            idx++;
        }
    }
}

- (void)parseDeepReadModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
    NSArray *deepReadModuleArray = [dict objectDataForKeySafely:@"deepReadModule"];
    
    if ([deepReadModuleArray isKindOfClass:[NSArray class]])
    {
        NSInteger moduleCount = [deepReadModuleArray count];
        // 存在深度阅读组
        if (moduleCount > 0)
        {
            // 创建深度阅读组数组
            NSMutableArray *articleDeepReadModuleArray = [[NSMutableArray alloc] initWithCapacity:[deepReadModuleArray count]];
            
            // 遍历深度阅读组数组,每一个dictionary代表一个微博组
            for (NSDictionary *deepReadModuleDictionary in deepReadModuleArray)
            {
                if ([deepReadModuleDictionary isKindOfClass:[NSDictionary class]])
                {
                    NSArray *listArray = [deepReadModuleDictionary objectForKeySafely:@"data"];
                    if ([listArray isKindOfClass:[NSArray class]])
                    {
                        if ([listArray count] > 0)
                        {
                            // 创建一个深度阅读组
                            SNArticleDeepReadGroup * deepReadGroup = [[SNArticleDeepReadGroup alloc] init];
                            
                            //默认横滑展示
                            deepReadGroup.type = ArticleDeepReadTypeScroll;
                            
                            NSString *typeString = SNString([deepReadModuleDictionary objectForKeySafely:@"type"], @"");
                            if([typeString isEqualToString:@"deep_read_module"])
                            {
                                deepReadGroup.type = ArticleDeepReadTypeScroll;
                            }
                            else if([typeString isEqualToString:@"deep_read_time"])
                            {
                                deepReadGroup.type = ArticleDeepReadTypeTimeLine;
                            }
                            
                            if (nil == deepReadGroup.deepReadGroup)
                            {
                                NSMutableArray * temp = [[NSMutableArray alloc] init];
                                deepReadGroup.deepReadGroup = temp;
                            }
                            //组标题
                            deepReadGroup.title = SNString([deepReadModuleDictionary objectForKeySafely:@"title"], @"深度解读");
                            
                            // 遍历深度阅读
                            for (NSDictionary *listDictionary in listArray)
                            {
                                // 创建一个深度阅读
                                SNArticleDeepRead *deepRead = [[SNArticleDeepRead alloc] init];
                                
                                deepRead.title = SNString([listDictionary objectForKey:@"title"], @"");
                                deepRead.summary = SNString([listDictionary objectForKey:@"summary"], @"");
                                deepRead.newsId = SNString([listDictionary objectForKey:@"newsId"], @"");
                                deepRead.linkUrl = [SNString([listDictionary objectForKey:@"url"], @"") htmlEntityDecoding];
                                deepRead.picUrl = [SNString([listDictionary objectForKey:@"kpic"], @"") htmlEntityDecoding];
                                deepRead.authorUrl = [SNString([listDictionary objectForKey:@"authorPic"], @"") htmlEntityDecoding];
                                deepRead.source = SNString([listDictionary objectForKey:@"source"], @"");
                                deepRead.totalComment = SNInt([listDictionary objectForKeySafely:@"totalComment"], 0);
                                
                                NSDate * date = [NSDate dateFromTimestamp:[listDictionary objectForKeySafely:@"pubDate"]];
                                deepRead.pubDate = [date stringWithTimeStampNoSecFormat];
                                
                                // 把深度阅读加入深度阅读组
                                [deepReadGroup.deepReadGroup addObject:deepRead];
                            }
                            
                            // 把深度阅读组加入深度阅读组数组
                            [articleDeepReadModuleArray addObject:deepReadGroup];
                        }
                    }
                }
            }
            
            // 设置正文深度阅读组数组
            article.deepReadModuleArray = articleDeepReadModuleArray;
        }
    }
}

+ (NSString *)deepGroupHtmlWithconciseDeepGroup:(SNArticleDeepReadGroup*)deepGroup
{
    NSMutableString *deepGroupHtml = [NSMutableString string];
    if (!deepGroup)
    {
        return @"";
    }
    int deepCount = (int)[deepGroup.deepReadGroup count];
    if (deepCount == 0)
    {
        return @"";
    }
    
    if(deepGroup.type == ArticleDeepReadTypeScroll)
    {
        // section开始
        [deepGroupHtml appendString:@"<section data-pl=\"deep_read_module\" class=\"M_grouptxt\">"];
        [deepGroupHtml appendFormat:@"<div class=\"M_tag\"><span>%@</span></div>",deepGroup.title];
        //            [deepGroupHtml appendString:@"<article class=\"grouptxt_w\" ui-slides=\"\" style=\"margin-left: 15px; margin-right: 15px;\" >"];
        [deepGroupHtml appendString:@"<article class=\"grouptxt_w M_groupdeep\" ui-slides=\"\" >"];
        [deepGroupHtml appendFormat:@"<ul style=\"width:%d%%;\">",(deepCount * 100)];
        
        CGFloat liWidth = 100.0 / deepCount;
        NSString *liWidthString = [NSString stringWithFormat:@"%f", liWidth];
        
        // article
        SNArticleDeepRead *articleDeep = nil;
        for (int i = 0; i < deepCount; ++i)
        {
            articleDeep = [deepGroup.deepReadGroup objectAtIndexSafely:i];
            if (articleDeep)
            {
                // 参数:newsid,索引,title,头像,来源,阅读数,图片,summary
                if (CHECK_VALID_STRING(articleDeep.picUrl))
                {
                    [deepGroupHtml appendFormat:@"<li ui-button style=\"width: %@%%;\" ui-link=\"method:deepReadClick;id:%@\">",liWidthString,articleDeep.newsId];
                    [deepGroupHtml appendString:@"<div class=\"txt\">"];
                    [deepGroupHtml appendFormat:@"<div class=\"M_depth\">"];
                    
                    [deepGroupHtml appendFormat:@"<div class=\"title\">%@</div>",articleDeep.title];
                    [deepGroupHtml appendFormat:@"<div class=\"txtp\" ui-textlimit>"];
                    
                    [deepGroupHtml appendFormat:@"<div class=\"big_img\">"];
                    [deepGroupHtml appendFormat:@"<span class=\"bigimg\"><img src=\"%@\"></span>",articleDeep.picUrl];
                    //close big_img
                    [deepGroupHtml appendFormat:@"</div>"];
                    
                    [deepGroupHtml appendFormat:@"<p textlimit-role=\"text\">%@</p>",articleDeep.summary];
                    
                    //close txtp
                    [deepGroupHtml appendFormat:@"</div>"];
                    //close M_depth
                    [deepGroupHtml appendFormat:@"</div>"];
                    //close txt
                    [deepGroupHtml appendFormat:@"</div>"];
                    [deepGroupHtml appendString:@"<div class=\"deep_more\"><div class=\"a_txt\">查看详情<span></span></div></div>"];
                    
                    [deepGroupHtml appendFormat:@"</li>"];
                }
                else
                {
                    [deepGroupHtml appendFormat:@"<li ui-button style=\"width: %@%%;\" ui-link=\"method:deepReadClick;id:%@\">",liWidthString,articleDeep.newsId];
                    [deepGroupHtml appendString:@"<div class=\"txt\">"];
                    [deepGroupHtml appendFormat:@"<div class=\"M_depth\" >"];
                    [deepGroupHtml appendFormat:@"<div class=\"title\">%@</div>",articleDeep.title];
                    [deepGroupHtml appendFormat:@"<div class=\"txtp\" ui-textlimit>"];
                    [deepGroupHtml appendFormat:@"<p textlimit-role=\"text\">%@</p>",articleDeep.summary];
                    
                    //close txtp
                    [deepGroupHtml appendFormat:@"</div>"];
                    //close M_depth
                    [deepGroupHtml appendFormat:@"</div>"];
                    //close txt
                    [deepGroupHtml appendFormat:@"</div>"];
                    [deepGroupHtml appendString:@"<div class=\"deep_more\"><div class=\"a_txt\">查看详情<span></span></div></div>"];
                    [deepGroupHtml appendFormat:@"</li>"];
                }
            }
        }
        
        [deepGroupHtml appendString:@"</ul>"];
        [deepGroupHtml appendString:@"</article>"];
        // section关闭
        [deepGroupHtml appendString:@"</section>"];
    }
    else if(deepGroup.type == ArticleDeepReadTypeTimeLine)
    {
        [deepGroupHtml appendFormat:@"<article class=\"M_timeline\">"];
        
        [deepGroupHtml appendFormat:@"<div class=\"M_tag\">"];
        [deepGroupHtml appendFormat:@"<span>%@</span>",deepGroup.title];
        [deepGroupHtml appendFormat:@"</div>"];
        
        [deepGroupHtml appendFormat:@"<div class=\"time_list\">"];
        
        // article
        SNArticleDeepRead *articleDeep = nil;
        for (int i = 0; i < deepCount; ++i)
        {
            articleDeep = [deepGroup.deepReadGroup objectAtIndexSafely:i];
            if (articleDeep)
            {
                //time_detail div里的属性.
                NSString *paramString = @"";
                //有newsId,才加点击事件
                if(CHECK_VALID_STRING(articleDeep.newsId))
                {
                    paramString = [NSString stringWithFormat:@"ui-button=\"\" ui-link=\"method:deepReadClick;id:%@\"",articleDeep.newsId];
                }
                
                [deepGroupHtml appendFormat:@"<div class=\"time_item\">"];
                [deepGroupHtml appendFormat:@"<p class=\"time_title\"><span></span>%@</p>",articleDeep.title];
                
                [deepGroupHtml appendFormat:@"<div class=\"time_detail\" %@>",paramString];
                [deepGroupHtml appendFormat:@"<div class=\"txt\">"];
                [deepGroupHtml appendFormat:@"<div class=\"M_depth\">"];
                [deepGroupHtml appendFormat:@"<div class=\"txtp\" textlimit-role=\"text\">"];
                [deepGroupHtml appendFormat:@"<p>%@</p>",articleDeep.summary];

                [deepGroupHtml appendFormat:@"</div>"];
                [deepGroupHtml appendFormat:@"</div>"];
                [deepGroupHtml appendFormat:@"</div>"];
                //有newsId,才展示查看详情
                if(CHECK_VALID_STRING(articleDeep.newsId))
                {
                    [deepGroupHtml appendFormat:@"<div class=\"deep_more\">查看详情<span></span></div>"];
                }
                [deepGroupHtml appendFormat:@"</div>"];
                
                [deepGroupHtml appendFormat:@"</div>"];
            }
        }
        [deepGroupHtml appendFormat:@"</div>"];
        [deepGroupHtml appendFormat:@"</article>"];
    }
    
    
    return deepGroupHtml;
}

#pragma mark - 段落

- (void)handleParagraphInArticle:(SNArticle *)conciseArticle
{
    // 新段首空2格
    conciseArticle.content = [conciseArticle.content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"<p class=\"M_p M_smallp\">"];
}

#pragma mark - 广告条

//顶部广告
- (void)parseTopBannerInArticle:(SNArticle *)article
{
    if(![article.topBanner isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    SNArticleImage * img = [[SNArticleImage alloc] init];
    
    //若有媒体介绍
    if(CHECK_VALID_STRING(article.intro))
    {
        if ([article.topBanner objectForKeySafely:@"height"] && [article.topBanner objectForKeySafely:@"width"])
        {
            //宽
            img.width = SNInt([article.topBanner objectForKey:@"width"], 0);
            //高
            img.height = SNInt([article.topBanner objectForKey:@"height"], 0);
        }
    }
    //没有媒体介绍
    else
    {
        img.width = WIDTH_TOP_BANNER;
        img.height = HEIGHT_TOP_BANNER;
        img.needCut = YES;
        img.doZoom = YES;
    }
    
    img.url = SNString([article.topBanner objectForKey:@"kpic"], @"");
    
    img.tagId = @"topbanner";
    
    [article.articleImageArray addObject:img];
}

//中部广告
- (void)parseAdBannerInArticle:(SNArticle *)article
{
    if (article.articleImageArray == nil) {
        article.articleImageArray = [NSMutableArray array];
    }
    if([article.middleBanner objectForKey:@"pic"])
    {
        SNArticleImage * img = [[SNArticleImage alloc] init];
        
        img.width = WIDTH_AD_BANNER;
        img.height = HEIGHT_AD_BANNER;
        img.needCut = YES;
        
        img.url = SNString([article.middleBanner objectForKey:@"kpic"], @"");
        img.tagId = @"adbanner";
        
        [article.articleImageArray addObject:img];
    }
}

#pragma mark - 特殊内容

//特殊内容
- (void)parseSpecialContentWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
    NSArray *array = [dict objectForKeySafely:@"specialContent"];
    if(!CHECK_VALID_ARRAY(array))
        return;
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for(NSDictionary *dict in array)
    {
        if(CHECK_VALID_DICTIONARY(dict))
        {
            NSDictionary *dataDict = [dict objectForKeySafely:@"data"];
            
            if(CHECK_VALID_DICTIONARY(dataDict))
            {
                SNSpecalContent *content = [[SNSpecalContent alloc]init];
                
                //默认type
                SpecalContentType type = SpecalContentTypeBackgroud;
                NSString *typeString = [dict objectForKeySafely:@"type"];
                
                if(CHECK_VALID_STRING(typeString))
                {
                    //四个类型的默认标题不同
                    if([typeString isEqualToString:@"background"])
                    {
                        type = SpecalContentTypeBackgroud;
                        content.title = SNString([dataDict objectForKeySafely:@"modelName"], @"背景");
                    }
                    else if([typeString isEqualToString:@"blockquote"])
                    {
                        type = SpecalContentTypeQuote;
                        content.title = SNString([dataDict objectForKeySafely:@"modelName"], @"");
                    }
                    else if([typeString isEqualToString:@"summary"])
                    {
                        type = SpecalContentTypeSummary;
                        content.title = SNString([dataDict objectForKeySafely:@"modelName"], @"摘要");
                    }
                    else if([typeString isEqualToString:@"conclusion"])
                    {
                        type = SpecalContentTypeConclusion;
                        content.title = SNString([dataDict objectForKeySafely:@"modelName"], @"结语");
                    }
                }
                
                content.type = type;
                content.content = SNString([dataDict objectForKeySafely:@"content"], @"");
                
                [tempArr addObject:content];
            }
        }
    }
    article.specialContentArray = [NSArray arrayWithArray:tempArr];
}

//处理特殊内容
- (void)handleSpecialContentInArticle:(SNArticle *)article
{
    for(int i = 0;i< [article.specialContentArray count];i++)
    {
        SNSpecalContent *specalContent = [article.specialContentArray objectAtIndexSafely:i];
        NSMutableString *html = [NSMutableString string];
        switch (specalContent.type)
        {
            case SpecalContentTypeBackgroud:
            {
                [html appendFormat:@"<h2 class=\"M_contentbg\"><strong>%@：</strong>%@</h2>",specalContent.title,specalContent.content];
            }
                break;
            case SpecalContentTypeQuote:
            {
                [html appendFormat:@"<h2 class=\"M_quote\" class=\"M_quote\">"];
                [html appendFormat:@"<div class=\"quote_ico\"></div>"];
                [html appendFormat:@"<div class=\"quote_txt\">%@</div>",specalContent.content];
//                [html appendFormat:@"<p class=\"people\">比尔盖茨</p>"];
                [html appendFormat:@"</h2>"];
            }
                break;
            case SpecalContentTypeSummary:
            {
                [html appendFormat:@"<h2 class=\"abstract\"><strong>%@：</strong>%@</h2>",specalContent.title,specalContent.content];
            }
                break;
            case SpecalContentTypeConclusion:
            {
                [html appendFormat:@"<h5><strong>%@：</strong>%@</h5>",specalContent.title,specalContent.content];
                
            }
                break;
                
            default:
                break;
        }
        NSString *htmlTag = [NSString stringWithFormat:@"<!--{SPECIALCONTENT_%d}-->",i+1];
        
        article.content = [article.content stringByReplacingOccurrencesOfString:htmlTag withString:html];
    }
}

#pragma mark - 导语,结语,小编提问

//导语
- (void)handleLeadInOriginalArticle:(SNArticle *)article
{
    if(CHECK_VALID_STRING(article.lead))
    {
        NSString *leadHtml = [NSString stringWithFormat:@"<h2 data-pl=\"lead\"><strong>%@：</strong>%@</h2>",article.leadTitle,article.lead];
        //        article.content = [NSString stringWithFormat:@"%@%@",leadHtml,article.content];
        //去掉前边的空行
        article.content = [article.content stringByReplacingOccurrencesOfString:@"<p class=\"M_p M_smallp\"><!--{LEAD}-->" withString:leadHtml];
        //前边没有空行的情况
        article.content = [article.content stringByReplacingOccurrencesOfString:@"<!--{LEAD}-->" withString:leadHtml];
    }
}

//结语
- (void)handleConclusionInOriginalArticle:(SNArticle *)article
{
    if(CHECK_VALID_STRING(article.conclusion))
    {
        NSString *conclusionHtml = [NSString stringWithFormat:@"<h5 data-pl=\"conclusion\"><strong>%@：</strong>%@</h5>",article.conclusionTitle,article.conclusion];
        //        article.content = article.content = [NSString stringWithFormat:@"%@%@",article.content,conclusionHtml];
        //去掉前边的空行
        article.content = [article.content stringByReplacingOccurrencesOfString:@"<p class=\"M_p M_smallp\"><!--{CONCLUSION}-->" withString:conclusionHtml];
        //前边没有空行的情况
        article.content = [article.content stringByReplacingOccurrencesOfString:@"<!--{CONCLUSION}-->" withString:conclusionHtml];
    }
}

//小编提问
- (void)handleEditorQuestionInOriginalArticle:(SNArticle *)article
{
    if(CHECK_VALID_STRING(article.editorQuestion))
    {
        NSMutableString *html = [NSMutableString stringWithFormat:@"<article ui-button data-pl=\"editor\" class=\"M_editor\" ui-link=\"method:openComment;\">"];
        
        [html appendFormat:@"<div class=\"M_s_con\">"];
        [html appendFormat:@"<div class=\"q_title\">"];
        [html appendFormat:@"<span class=\"q_logo\"></span>"];
        [html appendFormat:@"<span class=\"title\">小编提问</span>"];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"<div class=\"q_txt\">%@</div>",article.editorQuestion];
        [html appendFormat:@"</div>"];
        
        [html appendFormat:@"<div class=\"M_s_con M_s_ans\">"];
        [html appendFormat:@"<div class=\"a_txt\">回答小编<span></span></div>"];
        [html appendFormat:@"</div>"];
        [html appendFormat:@"</article>"];

        //去掉前边的空行
        article.content = [article.content stringByReplacingOccurrencesOfString:@"<p class=\"M_p M_smallp\"><!--{EDIT_QUESTION}-->" withString:html];
        //前边没有空行的情况
        article.content = [article.content stringByReplacingOccurrencesOfString:@"<!--{EDIT_QUESTION}-->" withString:html];
    }
}

#pragma mark - 其他

//- (void)handleTitleStyleInArticle:(Article *)article
//{
//    /*正则替换:
//     NSString * const PlaceHolder_Lead = @"<!--LEAD-->";
//     NSString * const PlaceHolder_End = @"<!--CLOSING-->";
//     NSString * const PlaceHolder_SubTitle = @"<!--SUBTITLE-->";
//     */
//    
//    NSMutableDictionary * replaceMap = [[NSMutableDictionary alloc] initWithCapacity:3];
//    [replaceMap setObject:[NSArray arrayWithObjects:@"h3 class=\"preface\"",@"h3",nil] forKey:@"LEAD"];
//    [replaceMap setObject:[NSArray arrayWithObjects:@"h3 class=\"preface\"",@"h3",nil] forKey:@"CLOSING"];
//    [replaceMap setObject:[NSArray arrayWithObject:@"h3"] forKey:@"SUBTITLE"];
//    
//    
//    [replaceMap enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSArray * obj, BOOL *stop)
//     {
//         @autoreleasepool
//         {
//             NSString * startTag = [obj objectAtIndexSafely:0];
//             NSString * endTag   = ([obj count]==2)?[obj objectAtIndexSafely:1]:startTag;
//             NSString * regex = [NSString stringWithFormat:@"<!--%@([^>]*)-->",key];
//             NSString * replacedStr = [NSString stringWithFormat:@"<%@>$1</%@>",startTag,endTag];
//             article.content = [article.content stringByReplacingOccurrencesOfRegex:regex withString:replacedStr];
//         }
//     }];
//}
- (NSDictionary *)parseRecommendArticleWithDic:(NSDictionary *)dict inArticle:(SNArticle *)article{
    NSMutableArray *recommendArrayList;
    NSMutableArray *abstractList;
    NSMutableArray *imageArray;
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSDictionary *data = [self parseBaseDataWithDict:dict];
    if (CHECK_VALID_DICTIONARY(data)){
        NSArray *recommendArray = SNArray([data objectDataForKeySafely:@"list"],nil);
        if (CHECK_VALID_ARRAY(recommendArray)){
            
            recommendArrayList = [NSMutableArray arrayWithCapacity:0];
            abstractList = [NSMutableArray arrayWithCapacity:0];
            imageArray = [NSMutableArray arrayWithCapacity:0];
            
            [recommendArray enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
                NSDictionary *recommendDic = (NSDictionary *)obj;
                if (CHECK_VALID_DICTIONARY(recommendDic)){
                    
                    [abstractList safeAddObject:recommendDic];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:recommendDic];
                    NSString *url = nil;
                    url = [SNString([dic objectForKey:@"kpic"], @"") htmlEntityDecoding];
                    if(CHECK_VALID_STRING(url))
                    {
                        NSString *tagId = [SNArticleManager tagIDWithRecommendImageIndex:index];
                        
                        SNArticleImage *img = [[SNArticleImage alloc] init];
                        img.url = url;
                        img.width = ArticleRecommendImage_Width;
                        img.height = ArticleRecommendImage_Height;
                        img.tagId = tagId;
                        
                        img.needCut = YES;
                        img.doZoom = YES;
                        
                        [imageArray addObject:img];
                        [article.articleImageArray addObject:img];
                        
                        [dic setObject:tagId forKey:@"imgID"];
                    }
                    [recommendArrayList addObject:dic];
                }
            }];
        }
    }
    if (imageArray){
        [resultDic setObject:imageArray forKey:@"ImageArray"];
    }
    
    article.recommendedAbstractArray = abstractList;
    if (CHECK_VALID_ARRAY(recommendArrayList)){
        NSDictionary *jsonData = @{@"data":recommendArrayList,@"type":@"recommends"};
        [resultDic setObject:jsonData forKey:@"JsonData"];
    }
    
    return resultDic;
}
@end
