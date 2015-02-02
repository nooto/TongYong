#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DResultSet.h"
#import "DDatabasePool.h"


#if ! __has_feature(objc_arc)
    #define DDBAutorelease(__v) ([__v autorelease]);
    #define DDBReturnAutoreleased DDBAutorelease

    #define DDBRetain(__v) ([__v retain]);
    #define DDBReturnRetained DDBRetain

    #define DDBRelease(__v) ([__v release]);
#else
    // -fobjc-arc
    #define DDBAutorelease(__v)
    #define DDBReturnAutoreleased(__v) (__v)

    #define DDBRetain(__v)
    #define DDBReturnRetained(__v) (__v)

    #define DDBRelease(__v)
#endif


@interface DDatabase : NSObject  {
    
    sqlite3*            _db;
    NSString*           _databasePath;
    BOOL                _logsErrors;
    BOOL                _crashOnErrors;
    BOOL                _traceExecution;
    BOOL                _checkedOut;
    BOOL                _shouldCacheStatements;
    BOOL                _isExecutingStatement;
    BOOL                _inTransaction;
    int                 _busyRetryTimeout;
    
    NSMutableDictionary *_cachedStatements;
    NSMutableSet        *_openResultSets;
    NSMutableSet        *_openFunctions;

}

@property (assign) BOOL traceExecution;
@property (assign) BOOL checkedOut;
@property (assign) int busyRetryTimeout;
@property (assign) BOOL crashOnErrors;
@property (assign) BOOL logsErrors;
@property (retain) NSMutableDictionary *cachedStatements;


+ (id)databaseWithPath:(NSString*)inPath;
- (id)initWithPath:(NSString*)inPath;

- (BOOL)open;
#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL)openWithFlags:(int)flags;
#endif
- (BOOL)close;
- (BOOL)goodConnection;
- (void)clearCachedStatements;
- (void)closeOpenResultSets;
- (BOOL)hasOpenResultSets;

// encryption methods.  You need to have purchased the sqlite encryption extensions for these to work.
- (BOOL)setKey:(NSString*)key;
- (BOOL)rekey:(NSString*)key;

- (NSString *)databasePath;

- (NSString*)lastErrorMessage;

- (int)lastErrorCode;
- (BOOL)hadError;
- (NSError*)lastError;

- (sqlite_int64)lastInsertRowId;

- (sqlite3*)sqliteHandle;

- (BOOL)update:(NSString*)sql withErrorAndBindings:(NSError**)outErr, ...;
- (BOOL)executeUpdate:(NSString*)sql, ...;
- (BOOL)executeUpdateWithFormat:(NSString *)format, ...;
- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;

- (DResultSet *)executeQuery:(NSString*)sql, ...;
- (DResultSet *)executeQueryWithFormat:(NSString*)format, ...;
- (DResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;
- (DResultSet *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;

- (BOOL)rollback;
- (BOOL)commit;
- (BOOL)beginTransaction;
- (BOOL)beginDeferredTransaction;
- (BOOL)inTransaction;
- (BOOL)shouldCacheStatements;
- (void)setShouldCacheStatements:(BOOL)value;

#if SQLITE_VERSION_NUMBER >= 3007000
- (BOOL)startSavePointWithName:(NSString*)name error:(NSError**)outErr;
- (BOOL)releaseSavePointWithName:(NSString*)name error:(NSError**)outErr;
- (BOOL)rollbackToSavePointWithName:(NSString*)name error:(NSError**)outErr;
- (NSError*)inSavePoint:(void (^)(BOOL *rollback))block;
#endif

+ (BOOL)isSQLiteThreadSafe;
+ (NSString*)sqliteLibVersion;

- (int)changes;

- (void)makeFunctionNamed:(NSString*)name maximumArguments:(int)count withBlock:(void (^)(sqlite3_context *context, int argc, sqlite3_value **argv))block;

@end

@interface DStatement : NSObject {
    sqlite3_stmt *_statement;
    NSString *_query;
    long _useCount;
}

@property (assign) long useCount;
@property (retain) NSString *query;
@property (assign) sqlite3_stmt *statement;

- (void)close;
- (void)reset;

@end

