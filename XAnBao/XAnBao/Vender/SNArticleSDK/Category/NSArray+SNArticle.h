/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

@interface NSArray (SNArticle)
- (NSArray *) arrayBySortingStrings;
@property (readonly, getter=arrayBySortingStrings) NSArray *sortedStrings;
@property (readonly) NSString *stringValue;
@end

@interface NSArray (UtilityExtensions)
//- (NSArray *)uniqueMembers;
//- (NSArray *)unionWithArray:(NSArray *)array;
//- (NSArray *)intersectionWithArray:(NSArray *)array;
//- (NSArray *)intersectionWithSet:(NSSet *)set;
//- (NSArray *)complementWithArray:(NSArray *)anArray;
//- (NSArray *)complementWithSet:(NSSet *)anSet;
- (id)objectAtIndexSafely:(NSUInteger)index;
//- (NSMutableArray *)deepMutableCopy NS_RETURNS_RETAINED;
@end
//
@interface NSMutableArray (UtilityExtensions)

- (id)objectAtIndexSafely:(NSUInteger)index;

- (void)addNullableObject:(id)object;

// Converts a set into an array; actually returns a
// mutable array, if that's relevant to you.
+ (NSMutableArray*) arrayWithSet:(NSSet*)set;

- (void)addObjectIfAbsent:(id)object;

- (void)removeObjectAtIndexSafely:(NSUInteger)index;

- (NSMutableArray *) removeFirstObject;
- (NSMutableArray *) reverse;
- (NSMutableArray *) scramble;
@property (readonly, getter=reverse) NSMutableArray *reversed;
@end
//
//@interface NSMutableArray (StackAndQueueExtensions)
//- (NSMutableArray *)pushObject:(id)object;
//- (NSMutableArray *)pushObjects:(id)object,...;
//- (id) popObject;
//- (id) pullObject;
//
//// Synonyms for traditional use
//- (NSMutableArray *)push:(id)object;
//- (id) pop;
//- (id) pull;
//
//- (void)enqueueObjects:(NSArray *)objects;
//
//@end
//
@interface NSMutableArray (SafeExtensions)

- (void)safeAddObject:(id)object;
- (void)safeAddNilObject;
- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index;
- (void)safeRemoveObject:(id)object;

@end

@interface NSArray (NSArray_365Cocoa)
- (id)firstObject;
@end


@interface NSArray (PSLib)
- (id)objectUsingPredicate:(NSPredicate *)predicate;

/*
 * Checks to see if the array is empty
 */
@property(nonatomic,readonly,getter=isEmpty) BOOL empty;

@end
