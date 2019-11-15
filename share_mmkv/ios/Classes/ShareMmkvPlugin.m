#import "ShareMmkvPlugin.h"
#import "MMKV.h"

static NSString *const CHANNEL_NAME     = @"com.silencezhou.sharemmkv";
static NSString *const ValueTypeString  = @"string";
static NSString *const ValueTypeBool    = @"bool";
static NSString *const ValueTypeInt     = @"int";
static NSString *const ValueTypeDouble  = @"double";

static NSString *const  KEY             = @"key";
static NSString *const  KEYS            = @"keys";
static NSString *const  VALUE           = @"value";
static NSString *const  VALUETYPE       =  @"valueType";
static NSString *const  MAP             = @"map";


static inline BOOL isEmpty(id thing) {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing isKindOfClass:[NSData class]] && [(NSData *)thing length] == 0)
    || ([thing isKindOfClass:[NSArray class]] && [(NSArray *)thing count] == 0);
}


@implementation ShareMmkvPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME
                                                                binaryMessenger:[registrar messenger]];
    ShareMmkvPlugin* instance = [[ShareMmkvPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *method = [call method];
    NSDictionary *arguments = [call arguments];
    NSString *key = arguments[KEY];
    NSString *keys = arguments[KEYS];
    NSObject *value = arguments[VALUE];
    NSString *valueType = arguments[VALUETYPE];
    NSDictionary *map = arguments[MAP];
    
    MMKV *mmkv = [MMKV defaultMMKV];
    [MMKV setLogLevel:MMKVLogNone];
    if (isEmpty(mmkv)) {
        result([FlutterError errorWithCode:@"MMKVException"
                                   message:@"MMKV is null."
                                   details:nil]);
        return;
    }
    
    if ([method isEqualToString:@"setSameValueMapWithMap"]) {
        
        if (!isEmpty(map) && [map isKindOfClass:[NSDictionary class]] && ((NSDictionary *)map).allKeys.count) {
            result(@([self setSameValueMapWithMap:map valueType:valueType mmkv:mmkv]));
        } else {
            result(@(NO));
        }
        
    }  else if ([method isEqualToString:@"getSameValueMapWithListKey"]) {
        if ([keys isKindOfClass:[NSArray class]] && ((NSArray *)keys).count > 0 && valueType.length) {
            result([self getMapWithKeys:(NSArray *)keys valueType:valueType mmkv:mmkv]);
        } else {
            result(nil);
        }
        
    } else if ([method isEqualToString:@"setBool"]) {
        result([NSNumber numberWithBool:[mmkv setBool:((NSNumber*)value).boolValue forKey:key]]);
    } else if ([method isEqualToString:@"getBool"]) {
        if ([mmkv containsKey:key]) {
            result([NSNumber numberWithBool:[mmkv getBoolForKey:key]]);
        } else {
            result(nil);
        }
    } else if ([method isEqualToString:@"setInt"]) {
        result([NSNumber numberWithBool:[mmkv setInt64:((NSNumber*)value).longValue forKey:key]]);
        
    } else if ([method isEqualToString:@"getInt"]) {
        if ([mmkv containsKey:key]) {
            result([NSNumber numberWithLong:[mmkv getInt64ForKey:key]]);
        } else {
            result(nil);
        }
    } else if ([method isEqualToString:@"setDouble"]) {
        result([NSNumber numberWithBool:[mmkv setDouble:((NSNumber*)value).doubleValue forKey:key]]);
    } else if ([method isEqualToString:@"getDouble"]) {
        if ([mmkv containsKey:key]) {
            result([NSNumber numberWithDouble:[mmkv getDoubleForKey:key]]);
        } else {
            result(nil);
        }
    } else if ([method isEqualToString:@"setString"]) {
        
        result([NSNumber numberWithBool:[mmkv setString:(NSString*)value forKey:key]]);
        
    } else if ([method isEqualToString:@"getString"]) {
        
        result([mmkv getStringForKey:key]);
        
    } else if ([method isEqualToString:@"contains"]) {
        result([NSNumber numberWithBool:[mmkv containsKey:key]]);
    } else if ([method isEqualToString:@"remove"]) {
        [mmkv removeValueForKey:key];
        result(@YES);
    } else if ([method isEqualToString:@"clear"]) {
        [mmkv clearAll];
        result(@YES);
    } else if ([method isEqualToString:@"allKeys"]) {
        result([mmkv allKeys]);
    }  else if ([method isEqualToString:@"count"]) {
        result([NSNumber numberWithLong:[mmkv count]]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (NSDictionary *)getMapWithKeys:(NSArray <NSString *>*)keys valueType:(NSString *)valueType mmkv:(MMKV *)mmkv{
    
    NSMutableDictionary *map = [NSMutableDictionary dictionary];

    for (NSString *key in keys) {
        
        if (![mmkv containsKey:key]) continue;
        
        id value;
        if ([ValueTypeString isEqualToString:valueType]) {
            value = [mmkv getStringForKey:key];
            
        } else if ([ValueTypeBool isEqualToString:valueType]) {
            value = [NSNumber numberWithBool:[mmkv getBoolForKey:key]];
            
        } else if ([ValueTypeInt isEqualToString:valueType]) {
            value = [NSNumber numberWithLong:[mmkv getInt64ForKey:key defaultValue:0]];
            
        } else if ([ValueTypeDouble isEqualToString:valueType]) {
            value = [NSNumber numberWithDouble:[mmkv getDoubleForKey:key defaultValue:0.0]];
        }

        [map setValue:isEmpty(value) ? @"null" : value  forKey:key];
    }
    return map;
}


- (BOOL)setSameValueMapWithMap:(NSDictionary *)map valueType:(NSString *)valueType mmkv:(MMKV *)mmkv{
    
   __block BOOL isSuccess = YES;
    [map enumerateKeysAndObjectsUsingBlock:^(NSString  * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        BOOL isSaveSussess = YES;
        if ([ValueTypeString isEqualToString:valueType]) {
            isSaveSussess = [mmkv setString:obj forKey:key];
        } else if ([ValueTypeBool isEqualToString:valueType]) {
            isSaveSussess = [mmkv setBool:[obj boolValue] forKey:key];
        } else if ([ValueTypeInt isEqualToString:valueType]) {
            isSaveSussess = [mmkv setInt64:[obj longLongValue] forKey:key];
        } else if ([ValueTypeDouble isEqualToString:valueType]) {
            isSaveSussess = [mmkv setDouble:[obj doubleValue] forKey:key];
        }
        if (!isSaveSussess) {
            isSuccess = NO;
        }
    }];
    
    return isSuccess;
}


@end
