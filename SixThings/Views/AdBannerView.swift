//
//  AdBannerView.swift
//  SixThings
//
//  橫幅廣告：取得同意（canRequestAds）後才載入，
//  尺寸固定 320×50，和原本的灰色佔位一樣高，畫面不會跳動。
//
import SwiftUI
import GoogleMobileAds

// 廣告單元 ID
enum AdUnitID {
    #if DEBUG
    // 開發時用測試廣告，避免自己看到正式廣告、誤點導致帳號被停權
    static let banner = "ca-app-pub-3940256099942544/2435281174"
    #else
    // 上架版本用正式廣告
    static let banner = "ca-app-pub-3462428075271677/5230226979"
    #endif
}

struct AdBannerView: View {
    @EnvironmentObject var adsConsentManager: AdsConsentManager

    var body: some View {
        Group {
            if adsConsentManager.canRequestAds {
                BannerViewContainer()
            } else {
                // 還沒取得同意：先留白，保持版面高度不變
                Color.clear
            }
        }
        .frame(width: AdSizeBanner.size.width, height: AdSizeBanner.size.height)
        .frame(maxWidth: .infinity)   // 置中
    }
}

// 把 UIKit 的 BannerView 包成 SwiftUI 可以用的 View
private struct BannerViewContainer: UIViewRepresentable {

    // makeUIView 只會在第一次顯示時呼叫一次，所以廣告只會請求一次，
    // 之後由 AdMob 後台設定的頻率自動更新
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = AdUnitID.banner
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) { }
}

#Preview {
    AdBannerView()
        .environmentObject(AdsConsentManager())
}
