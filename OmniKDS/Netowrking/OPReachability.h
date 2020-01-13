

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN,
    Reachable
} NetworkStatus;

@interface OPReachability : NSObject {
	SCNetworkReachabilityRef reachabilityRef;
	BOOL startedNotifier;
}

//reachabilityForInternetConnection- checks whether the default route is available.  
+ (OPReachability*) createReachabilityForInternetConnection;
+ (OPReachability*)sharedManager;
//Start listening for reachability notifications on the current run loop
- (BOOL) startNotifer;
- (void) stopNotifer;
- (NetworkStatus) currentReachabilityStatus;

@end
