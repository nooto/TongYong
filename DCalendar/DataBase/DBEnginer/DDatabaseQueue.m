//
//  DDatabasePool.m
//  DDB
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "DDatabaseQueue.h"
#import "DDatabase.h"

/*
 
 Note: we call [self retain]; before using dispatch_sync, just incase 
 DDatabaseQueue is released on another thread and we're in the middle of doing
 something in dispatch_sync
 
 */
 
@implementation DDatabaseQueue

@synthesize path = _path;

+ (id)databaseQueueWithPath:(NSString*)aPath {
    
    DDatabaseQueue *q = [[self alloc] initWithPath:aPath];
    
    DDBAutorelease(q);
    
    return q;
}

- (id)initWithPath:(NSString*)aPath {
    
    self = [super init];
    
    if (self != nil) {
        
        _db = [DDatabase databaseWithPath:aPath];
        DDBRetain(_db);
#if SQLITE_VERSION_NUMBER >= 3005000
        if (![_db openWithFlags:SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_NONE]) {
#else
        if (![_db open]) {
#endif
        
            NSLog(@"Could not create database queue for path %@", aPath);
            DDBRelease(self);
            return 0x00;
        }
        
        _path = DDBReturnRetained(aPath);
        
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"DDB.%@", self] UTF8String], NULL);
    }
    
    return self;
}

- (void)dealloc {
    
    DDBRelease(_db);
    DDBRelease(_path);
    
    if (_queue) {
//        dispatch_release(_queue);
        _queue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    DDBRetain(self);
    dispatch_sync(_queue, ^() { 
        [_db close];
        DDBRelease(_db);
        _db = 0x00;
    });
    DDBRelease(self);
}

- (DDatabase*)database {
    if (!_db) {
        _db = DDBReturnRetained([DDatabase databaseWithPath:_path]);
 
#if SQLITE_VERSION_NUMBER >= 3005000
        if (![_db openWithFlags:SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_NONE]) {
#else
        if (![_db open]) {
#endif
            NSLog(@"DDatabaseQueue could not reopen database for path %@", _path);
            DDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
        

    }
    
    return _db;
}

- (void)inDatabase:(void (^)(DDatabase *db))block {
    DDBRetain(self);
    
    dispatch_sync(_queue, ^() {
        
        DDatabase *db = [self database];
        block(db);
        
        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [DDatabaseQueue inDatabase:]");
        }
    });
    
    DDBRelease(self);
}


- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(DDatabase *db, BOOL *rollback))block {
    DDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        BOOL shouldRollback = NO;
        
        if (useDeferred) {
            [[self database] beginDeferredTransaction];
        }
        else {
            [[self database] beginTransaction];
        }
        
        block([self database], &shouldRollback);
        
        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    });
    
    DDBRelease(self);
}

- (void)inDeferredTransaction:(void (^)(DDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}

- (void)inTransaction:(void (^)(DDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}

#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(DDatabase *db, BOOL *rollback))block {
    
    static unsigned long savePointIdx = 0;
    __block NSError *err = 0x00;
    DDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
        
        BOOL shouldRollback = NO;
        
        if ([[self database] startSavePointWithName:name error:&err]) {
            
            block([self database], &shouldRollback);
            
            if (shouldRollback) {
                [[self database] rollbackToSavePointWithName:name error:&err];
            }
            else {
                [[self database] releaseSavePointWithName:name error:&err];
            }
            
        }
    });
    DDBRelease(self);
    return err;
}
#endif

@end
