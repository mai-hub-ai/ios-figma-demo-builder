import UIKit
import WebKit

class WebViewController: UIViewController {

    private var webView: WKWebView!

    // Vite dev server 地址
    private let devServerURL = URL(string: "http://localhost:5173")!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadDevServer()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        // 允许 JavaScript
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs

        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isInspectable = true // 允许 Safari Web Inspector 调试
        webView.navigationDelegate = self

        // 模拟移动端 UA
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 FliggyShell/1.0"

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func loadDevServer() {
        let request = URLRequest(url: devServerURL)
        webView.load(request)
    }

    /// 下拉刷新重新加载
    func reload() {
        webView.reload()
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        showRetryAlert(error: error)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        showRetryAlert(error: error)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        // 所有导航都允许（SPA 内部路由）
        decisionHandler(.allow)
    }

    private func showRetryAlert(error: Error) {
        let alert = UIAlertController(
            title: "无法连接开发服务器",
            message: "请确保 Vite dev server 正在运行:\ncd web && npm run dev\n\n错误: \(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "重试", style: .default) { [weak self] _ in
            self?.loadDevServer()
        })
        present(alert, animated: true)
    }
}
