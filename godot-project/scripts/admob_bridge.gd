extends Node
# Pizza Panic AdMob bridge. Mobile only. TEST_MODE MUST remain true until release approval.
signal interstitial_finished
signal rewarded_completed
const TEST_MODE := true
const IOS_INTERSTITIAL := "ca-app-pub-8896806042324657/4457358908"
const IOS_REWARDED := "ca-app-pub-8896806042324657/2276461855"
const ANDROID_INTERSTITIAL := "ca-app-pub-8896806042324657/3442203863"
const ANDROID_REWARDED := "ca-app-pub-8896806042324657/8969862717"
const IOS_TEST_INTERSTITIAL := "ca-app-pub-3940256099942544/4411468910"
const IOS_TEST_REWARDED := "ca-app-pub-3940256099942544/1712485313"
const ANDROID_TEST_INTERSTITIAL := "ca-app-pub-3940256099942544/1033173712"
const ANDROID_TEST_REWARDED := "ca-app-pub-3940256099942544/5224354917"
var interstitial: InterstitialAd
var rewarded: RewardedAd
var interstitial_loader := InterstitialAdLoadCallback.new()
var rewarded_loader := RewardedAdLoadCallback.new()
var interstitial_callbacks := FullScreenContentCallback.new()
var rewarded_callbacks := FullScreenContentCallback.new()
var earned_listener := OnUserEarnedRewardListener.new()
var waiting_next := false
var reward_pending := false
var rewarded_granted := false
var last_interstitial_time := -100000
var last_reward_time := -100000
var no_ads := false # Only set true after VERIFIED platform purchase; not a demo toggle.
var ads_initialized := false
func is_mobile() -> bool:
    return OS.get_name() in ["Android", "iOS"]
func _ready() -> void:
    if not is_mobile(): return
    interstitial_loader.on_ad_loaded = func(ad: InterstitialAd) -> void:
        interstitial = ad
        interstitial.full_screen_content_callback = interstitial_callbacks
    interstitial_loader.on_ad_failed_to_load = func(_err: LoadAdError) -> void: interstitial = null
    rewarded_loader.on_ad_loaded = func(ad: RewardedAd) -> void:
        rewarded = ad
        rewarded.full_screen_content_callback = rewarded_callbacks
    rewarded_loader.on_ad_failed_to_load = func(_err: LoadAdError) -> void: rewarded = null
    interstitial_callbacks.on_ad_dismissed_full_screen_content = func() -> void: _finish_interstitial()
    interstitial_callbacks.on_ad_failed_to_show_full_screen_content = func(_err: AdError) -> void: _finish_interstitial()
    rewarded_callbacks.on_ad_dismissed_full_screen_content = func() -> void: _finish_rewarded()
    rewarded_callbacks.on_ad_failed_to_show_full_screen_content = func(_err: AdError) -> void: _finish_rewarded()
    earned_listener.on_user_earned_reward = func(_item: RewardedItem) -> void:
        if reward_pending and not rewarded_granted:
            rewarded_granted = true
            rewarded_completed.emit()
    MobileAds.initialize(OnInitializationCompleteListener.new())
    ads_initialized = true
    load_interstitial()
    load_rewarded()
func _ad_id(reward: bool) -> String:
    if OS.get_name() == "Android":
        if TEST_MODE: return ANDROID_TEST_REWARDED if reward else ANDROID_TEST_INTERSTITIAL
        return ANDROID_REWARDED if reward else ANDROID_INTERSTITIAL
    if TEST_MODE: return IOS_TEST_REWARDED if reward else IOS_TEST_INTERSTITIAL
    return IOS_REWARDED if reward else IOS_INTERSTITIAL
func load_interstitial() -> void:
    if ads_initialized and interstitial == null:
        InterstitialAdLoader.new().load(_ad_id(false), AdRequest.new(), interstitial_loader)
func load_rewarded() -> void:
    if ads_initialized and rewarded == null:
        RewardedAdLoader.new().load(_ad_id(true), AdRequest.new(), rewarded_loader)
func request_between_days(completed_day: int) -> bool:
    if not ads_initialized or no_ads or completed_day < 4 or completed_day % 2 != 0: return false
    if Time.get_ticks_msec() - last_interstitial_time < 300000: return false
    if interstitial == null:
        load_interstitial()
        return false
    last_interstitial_time = Time.get_ticks_msec()
    waiting_next = true
    interstitial.show()
    return true
func _finish_interstitial() -> void:
    if interstitial:
        interstitial.destroy()
        interstitial = null
    load_interstitial()
    if waiting_next:
        waiting_next = false
        interstitial_finished.emit()
func request_rewarded() -> bool:
    if not ads_initialized or reward_pending or rewarded == null: return false
    if Time.get_ticks_msec() - last_reward_time < 180000: return false
    reward_pending = true
    rewarded_granted = false
    last_reward_time = Time.get_ticks_msec()
    rewarded.show(earned_listener)
    return true
func _finish_rewarded() -> void:
    reward_pending = false
    if rewarded:
        rewarded.destroy()
        rewarded = null
    load_rewarded()
