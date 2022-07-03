#import <UIKit/UIKit.h>
#import <libgscommon/libgsutils.h>

FOUNDATION_EXPORT NSString *const FBSOpenApplicationOptionKeyUnlockDevice;
FOUNDATION_EXPORT NSString *const FBSOpenApplicationOptionKeyActivateSuspended;
FOUNDATION_EXPORT NSString *const FBSOpenApplicationOptionKeyPromptUnlockDevice;

struct SBIconImageInfo {
    struct CGSize size;
    double scale;
    double continuousCornerRadius;
};

@interface SBIcon : NSObject
@property (nonatomic,copy,readonly) NSString * displayName;
- (UIImage *)generateIconImageWithInfo:(struct SBIconImageInfo)arg1;
@end

@interface SBIconModel : NSObject
- (SBIcon *)expectedIconForDisplayIdentifier:(id)arg1;
@end

@interface SBIconController : NSObject
@property (nonatomic,retain) SBIconModel * model;
+ (instancetype)sharedInstance;
@end

@interface FBSSystemService : NSObject
+ (id)sharedService;
- (void)openApplication:(NSString *)app options:(NSDictionary *)options withResult:(void (^)(void))result;
@end

@interface SBHIconManager : NSObject
@end

@interface SBIconListModel : NSObject
@end

@interface SBIconListView : UIView
@property (nonatomic,readonly) double horizontalIconPadding;
@property (nonatomic,copy) NSString * iconLocation;
@end

@interface SBDockIconListView : SBIconListView
@end

@interface SBIconView : UIView
@property (nonatomic,copy,readonly) NSString * applicationBundleIdentifierForShortcuts;
@end

@interface SBDockView : UIView
- (instancetype)initWithDockListView:(SBDockIconListView *)arg1 forSnapshot:(BOOL)arg2;
@end

@interface CSQuickActionsView : UIView
@end

@interface CSCombinedListViewController : UIViewController
@end

@interface CSMainPageContentViewController : UIViewController
@end

@interface CSTeachableMomentsContainerView : UIView
@end

@interface SBUICallToActionLabel : UIView
@end

@interface CSHomeAffordanceView : UIView
@end

@interface CSPageControl : UIView
@end

@interface MTMaterialView : UIView
+ (instancetype)materialViewWithRecipe:(long long)arg1 configuration:(long long)arg2;
@end

@interface SBFTouchPassThroughViewController : UIViewController
@end

@interface UIViewController (Private)
- (BOOL)_canShowWhileLocked;
@end

@interface UIDevice (Private)
+ (BOOL)tf_deviceHasFaceID;
+ (BOOL)currentIsIPad;
@end
