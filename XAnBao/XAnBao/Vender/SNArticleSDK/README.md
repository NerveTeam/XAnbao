--------------------------------------------------
该SDK提供了正文的展示功能以及界面交互的接口.

--------------------------------------------------
集成方法:
1,将SNArticleSDK文件夹拷贝到自己的工程中.
2,在工程文件的Build Phases的Compile Sources中,将JSONKit.m和NSString+SNArticle.m加上 -fno-objc-arc 关键字.
3,将SNArticleSDK/Resource/Html目录下的css,js,images目录先删除映射,然后重新导入,导入时勾选Creat Folder References

--------------------------------------------------
使用方法:
在需要使用打开正文VC的地方

#import "SNArticleBaseViewController.h"
SNArticleBaseViewController *articleVC = [[SNArticleBaseViewController alloc]initWithNewsId:newsId];
articleVC需要指明baseDelegate和actionDelegate,两个代理分别需要实现SNArticleActionProtocal和SNArticleBaseProtocal协议,参考相关的h文件.
SNArticleBaseProtocal中的方法必须实现并且回调Block,否则将不会出现内容.
SNArticleActionProtocal中的方法可以根据需求实现.

--------------------------------------------------
注意事项:
建议使用者不要修改SDK的代码,可以创建一个SNArticleBaseViewController的子类或分类来添加自己的代码,比如重写viewWillAppear方法先调用[super viewWillAppear]后再添加自己的统计逻辑.

由于html的模板原因,精编类型新闻(最顶部有大图)和普通新闻的html偏移量不同,建议子类化SNArticleBaseViewController之后,根据是否有顶图和自己的Navigation结构来设置偏移量以及webView_.scrollView.scrollIndicatorInsets(使用self.article.headPictureUrl判断是否有顶图)

--------------------------------------------------
额外功能:
1,在SNSDKConfig.h中可通过打开/关闭宏来选择SDK是否自动缓存正文.可通过[SNArticleManager clearArticleCache]清除缓存
2,SNImageUrlManager封装了K服务(图片服务器)的访问方法,在下载图片的时候建议用该方法.
3,SNArticleSetting中提供了一些正文的相关设置,如夜间模式和字体大小,可通过shareInstance获取SNArticleSetting的单例,修改属性后调用saveInstance方法来保存设置到NSUserDefaults.

--------------------------------------------------
有任何问题随时联系
邮箱:sunbo@staff.sina.com.cn 
QQ:82934162

--------------------------------------------------
新浪新闻,孙博
2016.1.7