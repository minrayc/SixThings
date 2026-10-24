//
//  AdsConsentManager.swift
//  SixThings
//
//  負責「使用者同意」與「廣告 SDK 初始化」：
//  1. 每次啟動向 Google 更新同意狀態
//  2. 需要時顯示 GDPR 同意視窗（歐盟／英國）與 IDFA 說明 → 系統 ATT 視窗
//  3. 取得同意後才初始化 Google Mobile Ads SDK
//
import Foundation
import GoogleMobileAds
import UserMessagingPlatform
import Combine

@MainActor
final class AdsConsentManager: ObservableObject {

    // 是否可以請求廣告（橫幅廣告用它決定要不要載入）
    @Published private(set) var canRequestAds = false

    // 設定頁的「隱私權選項」按鈕是否需要顯示（只有歐盟／英國等地區會是 true）
    @Published private(set) var isPrivacyOptionsRequired = false

    // 避免重複初始化 SDK、重複跑同意流程
    private var isMobileAdsStarted = false
    private var hasGatheredConsent = false   // 每次啟動 App 只跑一次

    // 每次啟動呼叫一次：更新同意狀態 → 需要時顯示表單 → 初始化 SDK
    // 重複呼叫（例如從編輯頁返回主畫面）會直接略過
    func gatherConsent() async {
        guard !hasGatheredConsent else { return }
        hasGatheredConsent = true

        let parameters = RequestParameters()

        #if DEBUG
        // 測試歐盟流程時，把下面三行的註解拿掉，模擬「使用者在歐洲」
        // 測完記得改回來；Release 版本不會編譯到這段
//        let debugSettings = DebugSettings()
//        debugSettings.geography = .EEA
//        parameters.debugSettings = debugSettings
        #endif

        do {
            // 1. 向 Google 更新這位使用者的同意狀態（每次啟動都要做）
            try await ConsentInformation.shared.requestConsentInfoUpdate(with: parameters)
            // 2. 需要的話顯示表單（GDPR 同意、IDFA 說明 → ATT）；不需要就直接結束
            try await ConsentForm.loadAndPresentIfRequired(from: nil)
        } catch {
            // 出錯時，UMP 會沿用上一次的同意狀態，下面照常判斷
            print("同意流程發生錯誤：\(error.localizedDescription)")
        }

        updateState()
        startMobileAdsIfNeeded()
    }

    // 設定頁「隱私權選項」按鈕呼叫：讓使用者修改或撤回同意
    func presentPrivacyOptions() async {
        do {
            try await ConsentForm.presentPrivacyOptionsForm(from: nil)
        } catch {
            print("隱私權選項表單發生錯誤：\(error.localizedDescription)")
        }
        updateState()
    }

    #if DEBUG
    // 測試用：清除同意紀錄，下次 gatherConsent 會重新顯示表單
    func resetConsentForTesting() {
        ConsentInformation.shared.reset()
        updateState()
    }
    #endif

    // MARK: - Private

    private func updateState() {
        canRequestAds = ConsentInformation.shared.canRequestAds
        isPrivacyOptionsRequired =
            ConsentInformation.shared.privacyOptionsRequirementStatus == .required
    }

    private func startMobileAdsIfNeeded() {
        guard canRequestAds, !isMobileAdsStarted else { return }
        isMobileAdsStarted = true
        MobileAds.shared.start()
    }
}
