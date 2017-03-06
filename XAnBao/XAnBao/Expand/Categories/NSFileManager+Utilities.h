//
//  NSFileManager+Utilities.h
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define FILEMANAGER   [NSFileManager defaultManager]

/*!
 Path utilities
 获取常用路径的快捷方法
 */

/*!
 *  返回Documents路径
 *
 *  @return Documents路径
 */
NSString *NSDocumentsFolder(void);

/*!
 *  生成并返回拼接Documents路径下指定文件名后的NSString对象
 *
 *  @param name 文件名称
 *
 *  @return 拼接完成的路径
 */
NSString *DocumentFileWithName(NSString *name);

/*!
 *  返回Library路径
 *
 *  @return Library路径
 */
NSString *NSLibraryFolder(void);

/*!
 *  生成并返回拼接Library路径下指定文件名后的NSString对象
 *
 *  @param name 文件名称
 *
 *  @return 拼接完成的路径
 */
NSString *LibraryFileWithName(NSString *name);//Library下某个文件

/*!
 *  返回Bundle路径
 *
 *  @return Bundle路径
 */
NSString *NSBundleFolder(void);//BundlePath,iOS下同资源目录

/*!
 *  返回Resource路径
 *
 *  @return Resource路径
 */
NSString *NSResourcePath(void);

/*!
 *  生成并返回拼接Resurce路径下指定文件名后的NSString对象
 *
 *  @param name 文件名称
 *
 *  @return 拼接完成的路径
 */
NSString *ResourceWithName(NSString *name);//资源文件

/*!
 *  返回Cache路径
 *
 *  @return Cache路径
 */
NSString *NSCacheFolder(void);

/*!
 *  生成并返回拼接Cache路径下指定文件名后的NSString对象
 *
 *  @param name 文件名称
 *
 *  @return 拼接完成的路径
 */
NSString *CacheFileWithName(NSString *name);

/*!
 *  生成并返回拼接Temporary路径下指定文件名后的NSString对象
 *
 *  @param name 文件名称
 *
 *  @return 拼接完成的路径
 */
NSString *TempFileWithName(NSString *name);//临时目录

/*!
 *  获取剩余磁盘空间，单位：byte
 *
 *  @return 磁盘剩余空间
 */
long getDiskFreeSize();

/*!
 *  将文件HASH化的相关工具方法。
 */
@interface NSFileManager (WBCrypto)
/*!
 *  生成并返回文件的MD5哈希字符串
 *
 *  @param filePath 文件路径
 *
 *  @return MD5哈希字符串
 */
+ (NSString *)fileMD5HashCreateWithPath:(NSString*)filePath;

/*!
 *  生成并返回文件的MD5哈希字符串
 *
 *  @param filePath                文件路径
 *  @param chunkSizeForReadingData 用于生成哈希字符串的数据大小
 *
 *  @return MD5哈希字符串
 */
+ (NSString *)fileMD5HashCreateWithPath:(CFStringRef)filePath ChunkSize:(size_t)chunkSizeForReadingData;

/*!
 *  生成并返回文件的SHA1哈希字符串
 *
 *  @param filePath 文件路径
 *
 *  @return SHA1哈希字符串
 */
+ (NSString *)fileSHA1HashCreateWithPath:(NSString*)filePath;

/*!
 *  生成并返回文件的SHA1哈希字符串
 *
 *  @param filePath                文件路径
 *  @param chunkSizeForReadingData 用于生成哈希字符串的数据大小
 *
 *  @return SHA1哈希字符串
 */
+ (NSString *)fileSHA1HashCreateWithPath:(CFStringRef)filePath ChunkSize:(size_t)chunkSizeForReadingData;
@end

/*!
 *  文件操作的相关操作
 */
@interface NSFileManager(WBFileManagerUtilities)
/*!
 *  判断删除对应路径文件或文件夹是否成功
 *
 *  @param path 要删除文件或文件夹的路径
 *
 *  @return 删除是否成功
 */
+ (BOOL)removeItemAtPath:(NSString*)path;

/*!
 *  读取并返回指定文件的指定大小的数据（Synchronously）
 *
 *  @param filePath 文件路径
 *  @param offset   读取起点
 *  @param length   读取数据长度
 *
 *  @return 对应位置长度的文件数据
 */
+ (NSData*)dataOfFile:(NSString*)filePath
               offset:(unsigned long long)offset
               length:(unsigned long long)length;

/*!
 *  拷贝指定路径文件到目标路径（synchronously）
 *
 *  @param fromPath  需要拷贝文件的路径
 *  @param toPath    将文件拷贝到的路径
 *  @param overWrite 是否覆盖
 *
 *  @return YES，拷贝成功；NO，拷贝失败。
 */
+ (BOOL)copyItemAtPath:(NSString*)fromPath
                toPath:(NSString*)toPath
             overWrite:(BOOL)overWrite;

/*!
 *  拷贝指定URL路径的文件到指定目标路径（asynchronously）
 *
 *  @param fromURL      源文件的URL
 *  @param toPath       目标路径
 *  @param overWrite    是否覆盖
 *  @param successBlock 拷贝成功回调的block
 *  @param failedBlock  拷贝失败回调的block
 *
 *  @return 判断是否拷贝成功的BOOL值。YES表示拷贝成功；NO，表示拷贝失败。
 */
+ (BOOL)asyncCopyImageItemFromURL:(NSURL*)fromURL
                           toPath:(NSString*)toPath
                        overWrite:(BOOL)overWrite
                     successBlock:(ALAssetsLibraryAssetForURLResultBlock)successBlock
                      failedBlock:(ALAssetsLibraryAccessFailureBlock)failedBlock;

/*!
 *  将NSArray 或 NSDictionary 类型的对象保存到Documents目录下
 *
 *  @param dataObject 要保存的数据对象
 *  @param filePath   相对Documents目录下的文件路径
 *
 *  @return 是否保存成功的BOOL; YES,保存成功; NO, 保存失败。
 */
+ (BOOL)saveDataObject:(id)dataObject
     documentsFilePath:(NSString *)filePath;

/*!
 *  使用NSKeyedArchiver避免Dict的值包含NSNull导致写入失败的情况
 *
 *  @param dataObject 要保存的数据对象
 *  @param filePath   相对Documents目录下的文件路径
 *
 *  @return 是否保存成功的BOOL; YES,保存成功; NO, 保存失败。
 */
+ (BOOL)archiverDataObject:(id)dataObject
                  filePath:(NSString *)filePath;

/*!
 *  从指定路径读取archiver object数据
 *
 *  @return 返回转换后的对象
 */
+ (id)loadArchiverObjectFromFilePath:(NSString *)filePath;

@end
/*!
 *  获取文件目录
 */
@interface NSFileManager(FileExist)
/*!
 *  判断创建指定文件目录是否成功；如果指定的文件目录不存在时，才创建。
 *
 *  @param directory 需要创建的路径
 *
 *  @return YES，拷贝成功；NO，拷贝失败；
 */
+ (BOOL)createDirectoryIfNotExist:(NSString *)directory;


/*!
 *  判断对应路径文件是否存在
 *
 *  @param path 文件路径
 *
 *  @return 该文件是否存在的BOOL
 */
+ (BOOL)existItemAtPath:(NSString*)path;

/*!
 *  建立所指定的文件目录
 *
 *  @param path  文件夹路径
 *  @param error 如果发生错误设置到error中
 *
 *  @return 是否创建成功
 */
- (BOOL)buildFolderPath:(NSString *)path error:(NSError **)error;

/*!
 *  取得指定文件路径的字符串；如果指定文件路径的文件不存在，则返回nil。
 *
 *  @param fname 文件名
 *  @param path  路径名
 *
 *  @return 完整路径
 */
+ (NSString *)pathForItemNamed:(NSString *)fname inFolder:(NSString *)path;

/*!
 *  取得Document路径下指定文件路径的字符串；如果指定文件路径的文件不存在，则返回nil。
 *
 *  @param fname 文件名
 *
 *  @return 完整路径
 */
+ (NSString *)pathForDocumentNamed:(NSString *)fname;

/*!
 *  取得Bundle路径下指定文件路径的字符串；如果指定文件路径的文件不存在，则返回nil。
 *
 *  @param fname 文件名
 *
 *  @return 完整路径
 */
+ (NSString *)pathForBundleDocumentNamed:(NSString *)fname;

/*!
 *  获取指定文件路径下，指定扩展名（不区分大小写）的文件路径字符串，以数组形式返回。
 *
 *  @param ext  拓展名
 *  @param path 文件路径
 *
 *  @return 返回文件路径的字符串。
 */
+ (NSArray *)pathsForItemsMatchingExtension:(NSString *)ext inFolder:(NSString *)path;

/*!
 *  获取Documents路径下，指定扩展名（不区分大小写）的文件路径字符串，以数组形式返回。
 *
 *  @param ext 拓展名
 *
 *  @return  返回复合指定拓展名的文件完整路径数组
 */
+ (NSArray *)pathsForDocumentsMatchingExtension:(NSString *)ext;

/*!
 *  获取Bundle路径下，指定扩展名（不区分大小写）的文件路径字符串，以数组形式返回。
 *
 *  @param ext 拓展名
 *
 *  @return 返回复合指定拓展名的文件完整路径数组
 */
+ (NSArray *)pathsForBundleDocumentsMatchingExtension:(NSString *)ext;

/*!
 *  获取目录下给定所有文件列表（不包含文件夹，只包含文件名）
 *
 *  @param path 文件路径
 *
 *  @return 文件列表数组
 */
+ (NSArray *)filesInFolder:(NSString *)path;
@end
