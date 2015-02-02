//
//  DDatabasePool.h
//  DDB
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

/*

                         ***README OR SUFFER***
Before using DDatabasePool, please consider using DDatabaseQueue instead.

If you really really really know what you're doing and DDatabasePool is what
you really really need (ie, you're using a read only database), OK you can use
it.  But just be careful not to deadlock!

For an example on deadlocking, search for:
ONLY_USE_THE_POOL_IF_YOU_ARE_DOING_READS_OTHERWISE_YOULL_DEADLOCK_USE_DDataBASEQUEUE_INSTEAD
in the main.m file.

*/



@class DDatabase;

@interface DDatabasePool : NSObject {
    NSString            *_path;
    
    dispatch_queue_t    _lockQueue;
    
    NSMutableArray      *_databaseInPool;
    NSMutableArray      *_databaseOutPool;
    
    __unsafe_unretained id _delegate;
    
    NSUInteger          _maximumNumberOfDatabasesToCreate;
}

@property (retain) NSString *path;
@property (assign) id delegate;
@property (assign) NSUInteger maximumNumberOfDatabasesToCreate;

+ (id)databasePoolWithPath:(NSString*)aPath;
- (id)initWithPath:(NSString*)aPath;

- (NSUInteger)countOfCheckedInDatabases;
- (NSUInteger)countOfCheckedOutDatabases;
- (NSUInteger)countOfOpenDatabases;
- (void)releaseAllDatabases;

- (void)inDatabase:(void (^)(DDatabase *db))block;

- (void)inTransaction:(void (^)(DDatabase *db, BOOL *rollback))block;
- (void)inDeferredTransaction:(void (^)(DDatabase *db, BOOL *rollback))block;

#if SQLITE_VERSION_NUMBER >= 3007000
// NOTE: you can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock.
// If you need to nest, use DDatabase's startSavePointWithName:error: instead.
- (NSError*)inSavePoint:(void (^)(DDatabase *db, BOOL *rollback))block;
#endif

@end


@interface NSObject (DDatabasePoolDelegate)

- (BOOL)databasePool:(DDatabasePool*)pool shouldAddDatabaseToPool:(DDatabase*)database;

@end

