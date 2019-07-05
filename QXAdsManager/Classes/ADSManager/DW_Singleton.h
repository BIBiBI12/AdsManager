//.h文件
#define DW_SingLetonH(name) + (instancetype)share##name;

//.m文件
#define DW_SingLetonM(name)\
static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
        \
    });\
    return _instance;\
}\
\
+ (instancetype)share##name{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc] init];\
    });\
    return _instance;\
}\
\
- (instancetype)copyWithZone:(NSZone *)zone{\
    return _instance;\
}
