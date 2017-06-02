//
//  Define.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/21.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#ifndef Define_h
#define Define_h

//#define kBaseURLString         @"http://121.40.179.185:8080/campus/api/v1/" // 测试
#define kBaseURLString       @"http://139.129.221.253:8080/campus/api/v1/"  // 正式
//#define kBaseURLString       @"http://192.168.1.23:8080/campus/api/v1/"  // 本地

//融云
#define kRongCloudURL @"https://api.cn.ronghub.com/user/getToken.json"

#define RCAppKey @"vnroth0krtt2o"   //正式：z3v5yqkbvyyd0  测试2：z3v5yqkbvyyd0  生产环境： vnroth0krtt2o

// 双方约定私钥
//#define RCAppSecret @"ZGE1NOh7XirnSu"  //正式：ZGE1NOh7XirnSu  测试2： ZGE1NOh7XirnSu


#define KQNHttp @"http://7y6y23.com2.z1.glb.clouddn.com/"


////推送
//#define kJPushAPP_KEY @"27fe96dfb231f70483aeb116"  //
//#define kJPushMasterSecret @"2494ce370d6021d861c2c6f0"
//
//#define kJPushCHANNEL @"Publish channal"
//#define kJPushAPS_FOR_PRODUCTION NO
//#define kUserEquipmentNo @"UserEquipmentNo"
///分享
#define kShareApp_key @"16d519627f780"
#define kShareSecret @"ba5e7d574ff3d31082fc41afc817ea60"




/////......................path.....................///
// Token接口
//
#define Url_TokenRC @"group/token?"
#define Url_TokenQN @"today_duty/token"

//
// 登录接口
//
#define Url_Login @"login?"         //  登录

//
// 常用接口
//
#define Url_CommonIndexList @"index_frequently/list?"
#define Url_ @"?"
#define Url_ @"?"
#define Url_AllFriends @"group/all_friends_groups?"
//
// 我的学校接口
//
#define Url_SchoolSearch @"school_extranet/search?"                 // 所有学校列表
#define Url_SchoolAttention @"school_extranet/attention?"                         // 关注学校
#define Url_SchoolUnattention @"school_extranet/unattention?"                          // 取消关注学校 uid=1&sid=1?
#define Url_SchoolAttentionSchool @"school_extranet/attention_school?"                     // 已关注的学校
#define Url_SchoolBanner @"school_extranet/banner?"                     // 轮播图
#define Url_SchoolTeacher @"school_extranet/teacher?"                   //留言对象列表
#define Url_SchoolLeavemsg @"school_extranet/leavemsg?"       // 留言
#define Url_SchoolNewsArticle @"school_extranet/newsarticle?" // 新闻
#define Url_SchoolNotice @"school_extranet/notice?"         // 公告
#define Url_SchoolBrief @"school_extranet/brief?"                // 简介
#define Url_SchoolImg @"school_extranet/img?"               // 图片
#define Url_SchoolInnerNotice @"school_inner/notice?"           // 内部公告
#define Url_SchoolInnerfiles @"school_inner/files?"                        // 内网文件列表
#define Url_SchoolGroup @"group/list_school_group?"             // 内网校群
#define Url_SchoolMails @"school_inner/newsreport?"                  // 内网通讯录
#define Url_GroupMembers @"group/group_member?"                        // 群成员 
#define Url_SchoolInnerNoticeTranmit @"school_inner/notice_transmit?" // 内网公告转发
#define Url_SchoolInnerSearchTeacher @"school_extranet/contacts?"     //搜索全网教师
#define Url_SchoolGroupCreat @"group/join_teacher_school_group?"    // 创建群，加入群
#define Url_SchoolGroupDismiss @"group/dismissGroup?"       // 解散群
//
// 我的班级接口
//
#define Url_ClassDotCancle @"class/cancle_red_dot?"
#define Url_ClassDot @"class/mark_red_dot?"
#define Url_ClassList @"class/list?"                        // 班级列表
#define Url_ClassAttentionClass @"today_duty/class_change_role?"    // 已关注的班级列表uid=1?
#define Url_ClassAttention @"class/attention?"              // 关注班级列表 uid=1&cid=1?
#define Url_ClassUnattention @"class/unattention?"          // 取消关注班级列表 uid=1&cid=1?
#define Url_ClassCourse @"class/course?"          // 教授科目
#define Url_ClassRoles @"class/roles?"            // 教师类型
#define Url_ClassTeachers @"class/teachers?"                // 班级教师列表
#define Url_ClassPatriarchList @"class/patriarch_list?"              // 班级家长列表
#define Url_ClassAddPatriarch @"class/addpatriarch?"        // 添加班级家长
#define Url_ClassAddTeacher @"class/addteacher?"            // 添加班级老师
#define Url_ClassAddStudents @"class/addstudent?"         // 添加学生
#define Url_ClassCinfo_list @"class/cinfo_list?"            // 班级通知列表
#define Url_ClassNoticeDetail @"class/info_detail?"            //通知详情
#define Url_ClassDelpatriarch @"class/delpatriarch?"        // 删除家长
#define Url_ClassUpdateTeacher @"class/updateteacher?"      // 修改老师
#define Url_ClassDelteacher @"class/delteacher?"            // 删除老师
#define Url_ClassConform @"class/conform?"                 // 家长确认收到通知
#define Url_ClassNotice_count @"class/notice_count?"        // 通知查阅统计
#define Url_ClassNoticePatriarch @"class/notice_view_patriarch?" // 通知家长信息
#define Url_FileFiles @"file/files?"                        // 班级文件列表
#define Url_FileUpload @"file/upload?"                      // 班级上传文件
#define Url_CalssTimetableList @"timetable/list?"         // 课程表
#define Url_ClassVoteList @"vote/list_vote?"                 //投票列表
#define Url_ClassVoteInfo @"vote/info_vote?"                //投票详情
#define Url_ClassVotPut @"vote/put_vote?"                       //投票
#define Url_ClassFriendTeachers @"friends/teachers?"            // 班级好友教师列表
#define Url_ClassFriendPatriarch @"friends/patriarch_friend_list?"   // 班级好友家长列表   
#define Url_ClassDelegateFriends @"friends/patriarch_del?"         // 删除家长好友
#define Url_ClassAddGroupInform @"group/add_group_inform?"                             //发通知
#define Url_ClassGroupMember @"group/group_member?"                // 班群成员
#define Url_ClassGroupInform @"group/discuss_group_inform?"    // 班群通知
#define Url_ClassDiscussion @"class/discussion?"    // 班级讨论组
#define Url_ClassDiscussOpen @"class/open?"             // 打开讨论组
#define Url_ClassDiscussClose @"class/close?"             // 关闭讨论组
#define Url_ClassTeacherBelongClass @"class/school_teacher_belong_class?"    //老师所属的班级 用来转发通知
#define Url_DutyPatriarchCourseList @"today_duty/patriarch_course_list?"     // 家长作业课程列表
#define Url_DutyPatriarchList @"today_duty/patriarch_index?"           // 家长查看作业列表
#define Url_DutyFinish @"today_duty/set_work_finish?"           // 作业完成回执
#define Url_DutyUnfinish @"today_duty/set_work_unfinish?"       // 取消完成
#define Url_DutyReply @"today_duty/patriarch_save_fj?"          // 提交附件作业
#define Url_MessagePushList @"msgpush/from_list?"                 //接受添加好友消息列表
#define Url_MessageAcceptList @"msgpush/accpt_list?"                    //接收添加好友消息列表
#define Url_FriendsAgree @"friends/patriarch_add?"                        //同意添加好友
#define Url_FriendsRefuse @"friends/patriarch_friend_refuse?"           //拒绝添加好友
#define Url_FriendAddSend @"friends/send_patriarch_add_self_msg?"  // 发送添加好友请求
#define Url_DutyTeacherCourseList @"today_duty/teacher_course_list?"  // 老师课程列表
#define Url_DutyGroupList @"today_duty/group_list?"           // 班机组列表:
#define Url_DutyGroupStudents @"today_duty/students?"        // 组下边的学生列表
#define Url_DutyByGroup @"today_duty/patriarch_index_bygroup?"           // 组下班学生作业
#define Url_DutyAllStudent @"today_duty/class_student_list?"   // 班机所有学生列表
#define Url_DutyGroupNew @"today_duty/group?"                   // 创建组:
#define Url_DutyHomework @"today_duty/homework?"  // 老师留作业
#define Url_DutyCheck @"today_duty/teacher_check_duty_fj_list?uid=1&alloction=xx?"  // 老师检查作业 弹框附件列表
#define Url_DutyStatusList @"today_duty/teacher_index?"  // 老师检查作业 单个学生作业列表
#define Url_DutyMonthTeacher @"today_duty/teacher_statistics_duty_situation?"  // 当月作业完成情况 老师检查
#define Url_DutyMonthPatriarh @"today_duty/parents_statistics_duty_situation?"  //当月作业完成情况 家长检查
//
// 安全教育
//
#define Url_StudyCotalog @"study/list_catalog"          // 学习资源标题列表
#define Url_StudtArticle @"study/list_article?"         // 学习资源列表
//
// 个人中心接口
//
#define Url_MeUpdata @"self/update?"
#define Url_MeAttentionList @"self/attention_list?"
// 设置成默认
#define Url_MeAddHomePage @"index_frequently/operation?"
#define Url_MeReplacePwd @"self/changepassword?"
#define Url_MeAbout @"self/help?"   // 关于

#define Url_ @"?"
#endif /* Define_h */
