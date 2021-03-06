//
//  AppDelegate.h
//  Dota2App
//
//  Created by Kyle Davidson on 10/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate> 

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *heroNavStack;
@property (strong, nonatomic) UINavigationController *itemNavStack;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)showWelcomePager;
- (NSURL *)applicationDocumentsDirectory;
/*
 * Method which returns a managed object context using the traditional approach, seperate from a stackmob enabled context
 *@return the context to be returned
 */
- (NSManagedObjectContext *)offlineManagedObjectContext;

@end
