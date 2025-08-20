# ChiuGaiOSDevKit

一個功能完整的iOS開發框架，旨在加速iOS應用程式開發，提供統一的設計系統、通用工具和UI/UX組件。

## 🎯 主要特色

- **統一設計系統** - 完整的主題管理和設計token
- **多種主題風格** - 默認現代風格 + 復古終端機風格
- **豐富的UI組件** - 按鈕、輸入框、加載器、頭像等
- **UX模式** - 彈窗、操作表單、底部面板等
- **網絡層** - 基於async/await的HTTP客戶端
- **存儲系統** - UserDefaults、Keychain、CoreData整合
- **導航系統** - 統一的導航協調器和深度鏈接
- **動畫效果** - 預設動畫和自定義轉場
- **工具集** - 驗證、日誌、日期格式化等

## 🚀 快速開始

### 基本使用

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        CGDKRoot {
            // 您的應用內容
            CGDKVStack(spacing: .lg) {
                CGDKCard {
                    Text("Welcome to ChiuGaiOSDevKit!")
                        .font(CGDKTokens.Font.title())
                }
                
                CGDKButton("Get Started") {
                    // 按鈕動作
                }
            }
            .cgdkPadding(.xl)
        }
    }
}
```

### 在Xcode中使用

1. 將框架添加到您的Xcode項目中
2. 在需要使用的文件中導入：`import ChiuGaiOSDevKit`（如果是模塊）
3. 使用`CGDKRoot`作為應用的根視圖來自動設置主題和環境對象

### 復古終端機風格
```swift
// 使用復古風格主題
struct RetroApp: View {
    var body: some View {
        CGDKRetroRoot {
            CGDKRetroContainer(title: "MAIN MENU") {
                VStack {
                    CGDKRetroButton("START GAME") { /* action */ }
                    CGDKRetroButton("OPTIONS", style: .outline) { /* action */ }
                }
                .padding(CGDKRetroTokens.Space.lg)
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
}
```

> 查看 `RetroTheme-Guide.md` 獲取復古主題的完整使用指南

## 📦 主要組件

### 設計系統

#### 主題管理
```swift
// 使用默認主題
@EnvironmentObject var themeManager: CGDKThemeManager

// 應用主題背景
.cgdkThemedBackground()
```

#### 設計Token
```swift
// 顏色
CGDKTokens.Color.brand
CGDKTokens.Color.text
CGDKTokens.Color.muted

// 間距
CGDKTokens.Space.sm  // 8pt
CGDKTokens.Space.md  // 12pt
CGDKTokens.Space.lg  // 16pt

// 字體
CGDKTokens.Font.title()
CGDKTokens.Font.body()
CGDKTokens.Font.caption()

// 圓角
CGDKTokens.Radius.sm
CGDKTokens.Radius.md
CGDKTokens.Radius.lg
```

### UI組件

#### 按鈕
```swift
// 基本按鈕
CGDKButton("標題", style: .primary) {
    // 動作
}

// 加載按鈕
CGDKLoadingButton("提交", isLoading: isSubmitting) {
    // 提交邏輯
}
```

#### 輸入框
```swift
CGDKTextField(
    "請輸入郵箱",
    text: $email,
    validationRules: [
        CGDKRequiredRule(),
        CGDKEmailRule()
    ]
)
```

#### 卡片和佈局
```swift
CGDKCard {
    Text("卡片內容")
}

CGDKVStack(spacing: .lg) {
    // 垂直堆疊內容
}

CGDKSection(
    header: { Text("標題") },
    content: { Text("內容") }
)
```

### UX模式

#### 彈窗系統
```swift
@StateObject private var alertManager = CGDKAlertManager()

// 顯示彈窗
alertManager.show(CGDKAlertData(
    title: "確認刪除",
    message: "此操作無法撤銷",
    primaryButton: CGDKAlertButton(title: "刪除", style: .destructive) {
        // 刪除邏輯
    },
    secondaryButton: CGDKAlertButton(title: "取消", style: .cancel)
))

// 應用彈窗管理
.cgdkAlert(manager: alertManager)
```

#### 操作表單
```swift
.cgdkActionSheet(
    isPresented: $showActionSheet,
    title: "選擇操作",
    items: [
        CGDKActionSheetItem(title: "編輯") { /* 編輯 */ },
        CGDKActionSheetItem(title: "刪除", style: .destructive) { /* 刪除 */ }
    ]
)
```

#### 底部面板
```swift
.cgdkBottomSheet(isPresented: $showSheet) {
    VStack {
        Text("底部面板內容")
        CGDKButton("關閉") { showSheet = false }
    }
    .cgdkPadding(.xl)
}
```

### 網絡層

#### API請求
```swift
struct UserRequest: CGDKAPIRequest {
    typealias Response = User
    
    let baseURL = "https://api.example.com"
    let path = "/users"
    let method: CGDKHTTPMethod = .GET
}

// 發送請求
let client = CGDKHTTPClient()
let user = try await client.send(UserRequest())
```

#### API服務
```swift
struct UserService: CGDKAPIService {
    let baseURL = "https://api.example.com"
    
    func getUser(id: String) async throws -> User {
        let request = try CGDKJSONRequest<User>(
            baseURL: baseURL,
            path: "/users/\\(id)",
            method: .GET
        )
        return try await client.send(request)
    }
}
```

### 存儲系統

#### UserDefaults
```swift
struct Settings {
    @CGDKUserDefault(key: "username", defaultValue: "")
    var username: String
    
    @CGDKUserDefault(key: "isFirstLaunch", defaultValue: true)
    var isFirstLaunch: Bool
}
```

#### Keychain
```swift
// 存儲敏感資訊
try CGDKKeychain.shared.save("token_value", forKey: "auth_token")

// 讀取
let token = try CGDKKeychain.shared.loadString(forKey: "auth_token")

// 使用屬性包裝器
@CGDKKeychainStorage(key: "auth_token")
var authToken: String?
```

#### 檔案存儲
```swift
// 存儲Codable對象
try CGDKFileStorage.shared.save(user, forKey: "current_user")

// 讀取
let user = try CGDKFileStorage.shared.load(User.self, forKey: "current_user")
```

### 驗證系統

```swift
// 創建驗證規則
let emailRules: [CGDKValidationRule] = [
    CGDKRequiredRule(),
    CGDKEmailRule()
]

let passwordRules: [CGDKValidationRule] = [
    CGDKRequiredRule(),
    CGDKMinLengthRule(8),
    CGDKPasswordRule()
]

// 執行驗證
let result = CGDKValidator.validate(email, rules: emailRules)
switch result {
case .success(let validEmail):
    // 驗證通過
case .failure(let error):
    // 顯示錯誤
}
```

### 動畫系統

```swift
// 使用預設動畫
.cgdkAnimatedEntry(animation: CGDKAnimations.smooth)

// 應用動畫效果
.cgdkPulse()
.cgdkBounce()
.cgdkGlow(color: .blue)

// 自定義轉場
.transition(.cgdkSlideIn)
.transition(.cgdkFadeScale)
```

### 導航系統

```swift
// 導航協調器
@StateObject private var coordinator = CGDKNavigationCoordinator()

// 推送頁面
coordinator.push(UserProfileDestination(userId: "123"))

// 彈出頁面
coordinator.presentSheet(SettingsDestination())

// 深度鏈接
CGDKDeepLinkManager.shared.handle(url)
```

### 日誌系統

```swift
// 全局日誌函數
CGDKLogDebug("調試資訊")
CGDKLogInfo("一般資訊")
CGDKLogWarning("警告")
CGDKLogError("錯誤")

// 配置日誌等級
CGDKLogger.shared.minimumLevel = .info
```

## 🎨 自定義主題

```swift
let customTheme = CGDKTheme(
    colors: .init(
        bg: .black,
        card: .gray.opacity(0.1),
        text: .white,
        muted: .gray,
        brand: .blue,
        line: .gray.opacity(0.2),
        danger: .red
    ),
    radius: .init(sm: 4, md: 8, lg: 12, pill: 999)
)

themeManager.apply(customTheme)
```

### 內建主題

框架提供兩種內建主題：

#### 1. 默認現代主題
```swift
CGDKRoot { /* 您的內容 */ }
// 或
CGDKRoot(theme: .default) { /* 您的內容 */ }
```

#### 2. 復古終端機主題
```swift
CGDKRetroRoot { /* 您的內容 */ }
// 或  
CGDKRoot(theme: .retro) { /* 您的內容 */ }
```

**復古主題特色：**
- 🖥️ 80年代終端機風格
- ⚫ 黑色背景 + 白色邊框
- 🔤 等寬字體系統
- 📟 復古按鈕和輸入框
- 🎮 遊戲機界面美學

## 📱 完整示例

查看 `DemoView.swift` 了解完整的使用示例，展示了框架的各種功能和組件。

## 🛠 開發指南

### 添加新組件

1. 在 `DesignSystem/Components.swift` 中添加新的UI組件
2. 使用 `@EnvironmentObject var tm: CGDKThemeManager` 獲取主題
3. 遵循現有的命名約定和結構

### 擴展工具集

1. 在 `Utils/` 目錄下創建新的工具文件
2. 使用 `CGDK` 前綴命名所有公共API
3. 添加完整的文檔註釋

## 📄 許可證

此項目使用 MIT 許可證。

---

**ChiuGaiOSDevKit** - 讓iOS開發更快速、更優雅！