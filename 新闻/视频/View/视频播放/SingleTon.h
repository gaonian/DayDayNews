//
//  SingleTon.h
//  完美单例
//
//  Created by 高超 on 15/5/25.
//  Copyright (c) 2015年 高超. All rights reserved.
//
//完美单例文件
//点H文件的宏
#define SingleTonH(methodName)   +(instancetype)share## methodName;

//点M文件的宏


#if __has_feature(objc_arc)
#define SingleTonM(methodName)\
static id _instance = nil;\
\
+(instancetype)share##methodName\
{\
_instance =[[self alloc]init];\
return _instance;\
\
}\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
if (!_instance) {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
_instance =[super allocWithZone:zone];\
});\
}\
return _instance;\
}\
-(instancetype)init\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super init];\
});\
return _instance;\
}

#else
#define SingleTonM(methodName)\
static id _instance = nil;\
\
+(instancetype)share##methodName\
{\
_instance =[[self alloc]init];\
return _instance;\
\
}\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
if (!_instance) {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
_instance =[super allocWithZone:zone];\
});\
}\
return _instance;\
}\
-(instancetype)init\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super init];\
});\
return _instance;\
}\
-(oneway void)release\
{\
\
}\
-(instancetype)retain\
{\
\
return self;\
}\
-(NSUInteger )retainCount\
{\
return 1;\
}

#endif