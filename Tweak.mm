/*
 * Tweak: 	RemoveRecents
 * Version:	2.0
 * Creator: EvilPenguin (James Emrich)
 * 
 * Enjoy :0)
 */

#import "RemoveRecents.h"

#pragma mark - Private Functions

NSString *bundleIdentifierForObject(id object) {
  if (@available(iOS 13.0, *)) {
    SBDisplayItem *displayItem = (SBDisplayItem *)[[object allItems] firstObject];
    
    return [displayItem bundleIdentifier];
  }
  else if (@available(iOS 11.0, *)) {
    SBDisplayItem *displayItem = (SBDisplayItem *)[[object allItems] firstObject];

    return [displayItem displayIdentifier];
  } 
  else if (@available(iOS 9.0, *)) {
    SBDisplayItem *displayItem = (SBDisplayItem *)object;

    return [displayItem displayIdentifier];
  } 
  else if (@available(iOS 8.0, *)) {
    SBDisplayLayout *displayLayout = (SBDisplayLayout *)object;
    NSDictionary *plistDict = [displayLayout plistRepresentation];

    if ([plistDict count] > 0) {
      NSArray *displayItemsArray = plistDict[@"SBDisplayLayoutDisplayItemsPlistKey"];
      if (displayItemsArray.count > 0) {
        NSDictionary *item = displayItemsArray.firstObject;
        if ([item count] > 0) return item[@"SBDisplayItemDisplayIdentifierPlistKey"];
      }
    }
  } 

  return object;
}

static BOOL isAppRunning(id app) {
  if (app) {
    if ([app respondsToSelector:@selector(isRunning)]) return [app isRunning];
    else if ([app respondsToSelector:@selector(processState)]) return [[app processState] isRunning];
  }

  return NO;
}

static NSArray *getRemoveRecentsArray(NSArray<id> *array) {
  NSMutableArray *runningApps = nil;

  if (array.count > 0) {
    SBApplicationController *appController = [%c(SBApplicationController) sharedInstance];
    
    runningApps = [NSMutableArray array];
    for (id object in array) {
      // Get BundleID
      NSString *bundleIdentifier = bundleIdentifierForObject(object);

      // Check for SpringBoard
      if ([bundleIdentifier rangeOfString:@"com.apple.springboard"].location != NSNotFound) {
        [runningApps addObject:object];
      } 
      else {
        // Lets get the app
        if ([appController respondsToSelector:@selector(applicationWithBundleIdentifier:)]) {
          id app = [appController applicationWithBundleIdentifier:bundleIdentifier];
          if (isAppRunning(app)) [runningApps addObject:object];
        } 
        // Lets look at the apps
        else {
          NSArray *apps = [appController applicationsWithBundleIdentifier:bundleIdentifier];
          for (id app in apps) {
            if ([app isRunning]) [runningApps addObject:object];
          }
        }
      }
    }
  }

  return runningApps;
}

#pragma mark - Hooking

%hook SBAppSwitcherModel

// iOS 13
- (id) appLayoutsIncludingHiddenAppLayouts:(BOOL)arg1 {
  id appLayouts = %orig;

  return getRemoveRecentsArray(appLayouts);
}

// iOS 11 / 12
- (id) mainSwitcherAppLayouts {
  id appLayouts = %orig;

  return getRemoveRecentsArray(appLayouts);
}

// iOS 9, 10
- (id) displayItemsForAppsOfRoles:(id)arg1 {
  id appList = %orig;

  return getRemoveRecentsArray(appList);
}

// iOS 7, 8
- (id) snapshot {
  id appList = %orig;
  
  return getRemoveRecentsArray(appList);
}

%end

%hook SBAppSwitcherController
// iOS 6
- (id) _bundleIdentifiersForViewDisplay {
  id appList = %orig;

  return getRemoveRecentsArray(appList);
}

// iOS 5
- (id) _applicationIconsExceptTopApp {
	id appList = %orig;
	
	NSMutableArray *newAppList = [NSMutableArray array];
  for (SBIconView *iconView in appList) {
		id sbApplication = [iconView.icon application];
    if ([[sbApplication process] isRunning]) [newAppList addObject:iconView];
	}
	
  return newAppList;
}

// iOS 4
- (id) _applicationIconsExcept:(id)application forOrientation:(int)orientation {
	id appList = %orig(application, orientation);

	NSMutableArray *newAppList = [NSMutableArray array];
	for (SBApplicationIcon *icon in appList) {
		if ([[[icon application] process] isRunning]) [newAppList addObject:icon];
	}

  return newAppList;
}

%end
