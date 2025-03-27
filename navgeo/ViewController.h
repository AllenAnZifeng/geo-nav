//
//  ViewController.h
//  navgeo
//
//  Created by Zifeng(Allen) An on 3/24/25.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic, strong) UITextField *sourceField;
@property(nonatomic, strong) UITextField *destinationField;
@property(nonatomic, strong) UITextField *waypointsField;

@property(nonatomic, strong) UITextField *addressField;
@property(nonatomic, strong) UITextField *xcoordinateField;
@property(nonatomic, strong) UITextField *ycoordinateField;

@property(nonatomic, strong) UISegmentedControl *directionsPlaceControl;
@property(nonatomic, strong) UIView *directionsView;
@property(nonatomic, strong) UIView *placeView;

@property(nonatomic, strong) UISegmentedControl *addressCoordinateControl;
@property(nonatomic, strong) UIView *addressionsView;
@property(nonatomic, strong) UIView *coordinateView;

@property (nonatomic, strong) UIButton *goAddressButton;
@property (nonatomic, strong) UIButton *goCoordinateButton;

@property (nonatomic, strong) NSMutableArray<UITextField *> *waypointTextFields;
@property (nonatomic, strong) UIButton *addWaypointButton;
@property (nonatomic, strong) UIButton *removeWaypointButton;
@property (nonatomic, strong) UIStackView *stackWaypointView;
@property (nonatomic, strong) UIStackView *buttonView;
@property (nonatomic, strong) UIButton *goDirectionsButton;
@property (nonatomic, strong) NSString *url;
@end

