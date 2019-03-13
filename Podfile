use_frameworks!
platform :ios, '10.0'

$RX_VERSION = '~> 4.0'
$ALAMOFIRE_VERSION = '~> 5.0.0-beta.3'
$R_SWIFT_VERSION = '~> 5.0.2'
$SWIFTER_VERSION = '~> 1.4.5'
$SAM_KEYCHAIN_VERSION = '~> 1.5.3'
$DYNAMIC_COLOR_VERSION = '~> 4.0.3'
$SNAP_KIT_VERSION = '~> 4.0.0'

def rx
  pod 'RxSwift', $RX_VERSION
  pod 'RxCocoa', $RX_VERSION
end

def swifter
    pod 'Swifter', $SWIFTER_VERSION
end

def rSwift
    pod 'R.swift', $R_SWIFT_VERSION
end

target 'RunningApp' do
  # Pods for RunningApp
  pod 'Alamofire', $ALAMOFIRE_VERSION
  rSwift
  rx
  swifter
  pod 'SAMKeychain', $SAM_KEYCHAIN_VERSION
  pod 'DynamicColor', $DYNAMIC_COLOR_VERSION
  pod 'SnapKit', $SNAP_KIT_VERSION
end

target 'RunningAppServer' do
    rSwift
    swifter
end
