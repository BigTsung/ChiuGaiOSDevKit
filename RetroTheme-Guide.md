# 復古終端機風格主題指南

## 🖥️ 概述

基於您提供的設計圖片，我創建了一個完整的復古終端機風格主題模板。這個主題模擬了80年代電腦終端機和早期遊戲機的界面風格，具有以下特色：

- **黑色背景** - 經典終端機風格
- **白色邊框** - 清晰的視覺分隔
- **等寬字體** - 復古電腦字體
- **簡潔佈局** - 功能性優先的設計
- **高對比度** - 優秀的可讀性

## 🎨 設計Token

### 顏色方案系統

框架支援6種不同的復古顏色方案：

```swift
// 可用的顏色方案
CGDKRetroTokens.ColorScheme.classic  // 經典黑底白字綠色強調
CGDKRetroTokens.ColorScheme.amber    // 琥珀色終端機風格
CGDKRetroTokens.ColorScheme.green    // 綠色螢幕風格
CGDKRetroTokens.ColorScheme.blue     // 藍色現代終端
CGDKRetroTokens.ColorScheme.white    // 白底黑字高對比
CGDKRetroTokens.ColorScheme.matrix   // Matrix風格亮綠色
```

### 動態顏色獲取
```swift
// 根據方案獲取顏色
let colors = CGDKRetroTokens.Color.colors(for: .amber)
colors.background  // 背景色
colors.screen      // 螢幕色 
colors.border      // 邊框色
colors.text        // 文字色
colors.accent      // 強調色
```

### 基礎顏色（向後兼容）
```swift
CGDKRetroTokens.Color.terminal    // 純黑背景
CGDKRetroTokens.Color.screen      // 深灰屏幕色
CGDKRetroTokens.Color.border      // 白色邊框
CGDKRetroTokens.Color.borderLight // 淺白邊框
CGDKRetroTokens.Color.text        // 白色文字
CGDKRetroTokens.Color.textMuted   // 淺白文字
CGDKRetroTokens.Color.accent      // 綠色強調色
CGDKRetroTokens.Color.selected    // 選中狀態背景
```

### 字體系統
```swift
CGDKRetroTokens.Font.title()     // 標題 - 24pt 等寬粗體
CGDKRetroTokens.Font.heading()   // 次標題 - 18pt 等寬半粗體
CGDKRetroTokens.Font.body()      // 正文 - 16pt 等寬常規
CGDKRetroTokens.Font.caption()   // 說明 - 14pt 等寬常規
CGDKRetroTokens.Font.small()     // 小字 - 12pt 等寬常規
```

### 邊框和間距
```swift
CGDKRetroTokens.Border.thin      // 1pt 細邊框
CGDKRetroTokens.Border.medium    // 2pt 中邊框
CGDKRetroTokens.Border.thick     // 3pt 粗邊框

CGDKRetroTokens.Space.xs         // 4pt
CGDKRetroTokens.Space.sm         // 8pt
CGDKRetroTokens.Space.md         // 12pt
CGDKRetroTokens.Space.lg         // 16pt
CGDKRetroTokens.Space.xl         // 20pt
CGDKRetroTokens.Space.xxl        // 24pt
```

## 🧩 核心組件

### 1. CGDKRetroRoot - 根容器
```swift
// 基本使用（默認classic方案）
struct MyApp: View {
    var body: some View {
        CGDKRetroRoot {
            MyContentView()
        }
    }
}

// 指定顏色方案
struct AmberApp: View {
    var body: some View {
        CGDKRetroRoot(colorScheme: .amber) {
            MyContentView()
        }
    }
}
```

### 2. CGDKRetroCard - 復古卡片
```swift
CGDKRetroCard {
    VStack {
        Text("CARD TITLE")
            .font(CGDKRetroTokens.Font.heading())
        Text("Card content here...")
            .font(CGDKRetroTokens.Font.body())
    }
}
```

### 3. CGDKRetroContainer - 帶標題容器
```swift
CGDKRetroContainer(title: "MAIN PANEL") {
    // 容器內容
    VStack {
        Text("Panel content")
    }
}
```

### 4. CGDKRetroSectionHeader - 區塊標題
```swift
CGDKRetroSectionHeader("SECTION TITLE", style: .title)
CGDKRetroSectionHeader("Sub Section", style: .heading)
CGDKRetroSectionHeader("Label", style: .label)
```

### 5. CGDKRetroChoiceButton - 選擇按鈕
```swift
@State private var selectedIndex = 0

ForEach(Array(options.enumerated()), id: \.offset) { index, option in
    CGDKRetroChoiceButton(
        option,
        isSelected: selectedIndex == index
    ) {
        selectedIndex = index
    }
}
```

### 6. CGDKRetroTextField - 輸入框
```swift
@State private var text = ""

CGDKRetroTextField("Enter text...", text: $text, label: "Username")
```

### 7. CGDKRetroButton - 按鈕
```swift
CGDKRetroButton("PRIMARY", style: .primary) { /* action */ }
CGDKRetroButton("SECONDARY", style: .secondary) { /* action */ }
CGDKRetroButton("OUTLINE", style: .outline) { /* action */ }
```

### 8. CGDKRetroToggle - 復古開關
```swift
@State private var isOn = false

// 基本開關
CGDKRetroToggle("Power", isOn: $isOn)

// 指定顏色方案
CGDKRetroToggle("Debug Mode", isOn: $isOn, colorScheme: .amber)

// 顯示效果: [X] ON 或 [ ] OFF
```

### 9. CGDKRetroProgress - 進度條
```swift
@State private var progress: Double = 0.7

// 基本進度條（方塊樣式）
CGDKRetroProgress("Loading", progress: progress)

// 不同樣式的進度條
CGDKRetroProgress("System", progress: 0.6, style: .bar)      // [████████░░░░] 60%
CGDKRetroProgress("Data", progress: 0.8, style: .ascii)      // [========----] 80%
CGDKRetroProgress("Process", progress: 0.3, style: .dots)    // [••••••••    ] 30%
CGDKRetroProgress("Init", progress: 0.9, style: .loading)    // [>>>>>>>     ] 90%

// 自定義寬度和隱藏百分比
CGDKRetroProgress(
    "Custom",
    progress: 0.5,
    style: .ascii,
    showPercentage: false,
    width: 150,
    colorScheme: .green
)
```

### 10. CGDKRetroSlider - 滑桿
```swift
@State private var volume: Double = 50

// 基本滑桿
CGDKRetroSlider("Volume", value: $volume, in: 0...100)

// 自定義範圍和寬度
CGDKRetroSlider(
    "Speed",
    value: $speed,
    in: 0...200,
    width: 180,
    colorScheme: .blue
)

// 顯示效果: [----■--------] 50
```

### 11. CGDKRetroPicker - 選擇器
```swift
@State private var selectedMode = "Mode A"
let modes = ["Mode A", "Mode B", "Mode C"]

// 基本選擇器
CGDKRetroPicker("Mode", selection: $selectedMode, options: modes)

// 自定義顯示文字
CGDKRetroPicker(
    "Level",
    selection: $level,
    options: [1, 2, 3, 4, 5],
    colorScheme: .matrix
) { level in
    "LEVEL \(level)"
}

// 顯示效果: < [ Mode A ] >
```

### 12. CGDKRetroAlert - 復古彈窗
```swift
@State private var showAlert = false

// 在需要的地方觸發
Button("Show Alert") {
    showAlert = true
}

// 彈窗覆蓋層
.overlay {
    if showAlert {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
        
        CGDKRetroAlert(
            title: "System Error",
            message: "Unable to connect to server. Please check your connection.",
            primaryButton: "RETRY",
            secondaryButton: "CANCEL",
            colorScheme: .classic,
            primaryAction: {
                // 重試邏輯
                showAlert = false
            },
            secondaryAction: {
                showAlert = false
            }
        )
    }
}
```

## 📱 完整應用示例

### 顏色方案切換應用
```swift
struct RetroApp: View {
    @State private var currentScheme: CGDKRetroTokens.ColorScheme = .classic
    
    var body: some View {
        CGDKRetroRoot(colorScheme: currentScheme) {
            RetroMainView(colorScheme: $currentScheme)
        }
    }
}

struct RetroMainView: View {
    @Binding var colorScheme: CGDKRetroTokens.ColorScheme
    @State private var isSystemOn = false
    @State private var progress: Double = 0.3
    @State private var volume: Double = 75
    @State private var selectedMode = "Normal"
    @State private var showAlert = false
    
    private let colorSchemes: [CGDKRetroTokens.ColorScheme] = [.classic, .amber, .green, .blue, .white, .matrix]
    private let modes = ["Normal", "Turbo", "Debug", "Safe"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: CGDKRetroTokens.Space.lg) {
                // 標題區
                headerSection
                
                // 顏色方案選擇
                colorSchemeSection
                
                // 系統控制
                systemControlSection
                
                // 進度和狀態
                progressSection
                
                // 動作區
                actionsSection
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
        .overlay {
            if showAlert {
                alertOverlay
            }
        }
    }
    
    private var headerSection: some View {
        CGDKRetroContainer(title: "SYSTEM CONTROL") {
            VStack(alignment: .leading, spacing: CGDKRetroTokens.Space.md) {
                Text("RETRO TERMINAL INTERFACE")
                    .font(CGDKRetroTokens.Font.heading())
                    .foregroundStyle(CGDKRetroTokens.Color.colors(for: colorScheme).text)
                
                Text("Multi-scheme retro UI system with complete component set.")
                    .font(CGDKRetroTokens.Font.body())
                    .foregroundStyle(CGDKRetroTokens.Color.colors(for: colorScheme).textMuted)
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var colorSchemeSection: some View {
        CGDKRetroContainer(title: "DISPLAY MODE") {
            VStack(spacing: CGDKRetroTokens.Space.md) {
                CGDKRetroPicker(
                    "Color Scheme",
                    selection: $colorScheme,
                    options: colorSchemes,
                    colorScheme: colorScheme
                ) { scheme in
                    switch scheme {
                    case .classic: return "CLASSIC"
                    case .amber: return "AMBER"
                    case .green: return "GREEN"
                    case .blue: return "BLUE"
                    case .white: return "WHITE"
                    case .matrix: return "MATRIX"
                    }
                }
                
                Text("Current: \(schemeName)")
                    .font(CGDKRetroTokens.Font.caption())
                    .foregroundStyle(CGDKRetroTokens.Color.colors(for: colorScheme).accent)
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var systemControlSection: some View {
        CGDKRetroContainer(title: "CONTROLS") {
            VStack(spacing: CGDKRetroTokens.Space.lg) {
                CGDKRetroToggle("System Power", isOn: $isSystemOn, colorScheme: colorScheme)
                
                CGDKRetroSlider("Volume Level", value: $volume, in: 0...100, colorScheme: colorScheme)
                
                CGDKRetroPicker("Operation Mode", selection: $selectedMode, options: modes, colorScheme: colorScheme)
                
                HStack {
                    Text("STATUS:")
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(CGDKRetroTokens.Color.colors(for: colorScheme).textMuted)
                    
                    Text(isSystemOn ? "ONLINE" : "OFFLINE")
                        .font(CGDKRetroTokens.Font.caption())
                        .foregroundStyle(isSystemOn ? 
                                       CGDKRetroTokens.Color.colors(for: colorScheme).accent : 
                                       CGDKRetroTokens.Color.colors(for: colorScheme).textMuted)
                    
                    Spacer()
                }
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var progressSection: some View {
        CGDKRetroContainer(title: "PROGRESS") {
            VStack(spacing: CGDKRetroTokens.Space.md) {
                CGDKRetroProgress("System Init", progress: progress, style: .bar, colorScheme: colorScheme)
                CGDKRetroProgress("Data Load", progress: 0.8, style: .ascii, colorScheme: colorScheme)
                CGDKRetroProgress("Network", progress: isSystemOn ? 1.0 : 0.0, style: .dots, colorScheme: colorScheme)
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var actionsSection: some View {
        CGDKRetroContainer(title: "ACTIONS") {
            VStack(spacing: CGDKRetroTokens.Space.md) {
                CGDKRetroButton("EXECUTE", style: .primary) {
                    withAnimation(.linear(duration: 2)) {
                        progress = 1.0
                    }
                }
                
                HStack(spacing: CGDKRetroTokens.Space.md) {
                    CGDKRetroButton("RESET", style: .outline) {
                        resetSystem()
                    }
                    
                    CGDKRetroButton("ALERT", style: .secondary) {
                        showAlert = true
                    }
                }
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
    
    private var alertOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showAlert = false
                }
            
            CGDKRetroAlert(
                title: "System Alert",
                message: "All systems are functioning normally. Current mode: \(selectedMode)",
                primaryButton: "ACKNOWLEDGE",
                secondaryButton: "DISMISS",
                colorScheme: colorScheme,
                primaryAction: {
                    showAlert = false
                },
                secondaryAction: {
                    showAlert = false
                }
            )
        }
    }
    
    private var schemeName: String {
        switch colorScheme {
        case .classic: return "CLASSIC WHITE/GREEN"
        case .amber: return "AMBER TERMINAL"
        case .green: return "GREEN MONITOR"
        case .blue: return "BLUE SCREEN"
        case .white: return "WHITE PAPER"
        case .matrix: return "MATRIX GREEN"
        }
    }
    
    private func resetSystem() {
        isSystemOn = false
        progress = 0.0
        volume = 50
        selectedMode = modes[0]
    }
}
```

### 列表界面示例
```swift
struct RetroListView: View {
    private let items = [
        "ITEM 001: System Status",
        "ITEM 002: Network Config", 
        "ITEM 003: User Settings",
        "ITEM 004: About System"
    ]
    
    var body: some View {
        CGDKRetroRoot {
            CGDKRetroContainer(title: "SYSTEM MENU") {
                CGDKRetroList(items.map { ListItem(title: $0) }) { item in
                    HStack {
                        Text(item.title)
                            .font(CGDKRetroTokens.Font.body())
                            .foregroundStyle(CGDKRetroTokens.Color.text)
                        Spacer()
                        Text(">")
                            .font(CGDKRetroTokens.Font.body())
                            .foregroundStyle(CGDKRetroTokens.Color.accent)
                    }
                }
            }
            .padding(CGDKRetroTokens.Space.lg)
        }
    }
}

struct ListItem: Identifiable {
    let id = UUID()
    let title: String
}
```

## 🎯 快速套用指南

### 1. 替換主題
如果您有現有的應用，只需要將：
```swift
// 原來的
CGDKRoot {
    MyApp()
}

// 改為
CGDKRetroRoot {
    MyApp()
}
```

### 2. 更新組件
將現有組件替換為復古版本：
```swift
// 原來的組件 -> 復古組件
CGDKCard -> CGDKRetroCard
CGDKButton -> CGDKRetroButton
CGDKTextField -> CGDKRetroTextField
```

### 3. 使用復古Token
```swift
// 使用復古設計token
.font(CGDKRetroTokens.Font.body())
.foregroundStyle(CGDKRetroTokens.Color.text)
.padding(CGDKRetroTokens.Space.md)
```

## 🖥️ 預覽效果

運行 `RetroDemo.swift` 中的預覽來查看：
- `CGDKRetroDemoView()` - 重現您圖片中的完整界面
- `Retro Components` 預覽 - 展示所有可用組件

## 🔄 自定義擴展

您可以輕鬆擴展這個主題：

```swift
// 添加新的復古組件
public struct CGDKRetroProgressBar: View {
    let progress: Double
    
    public var body: some View {
        HStack {
            Text("LOADING...")
                .font(CGDKRetroTokens.Font.caption())
            
            Rectangle()
                .fill(CGDKRetroTokens.Color.border)
                .frame(height: 2)
                .overlay(
                    HStack {
                        Rectangle()
                            .fill(CGDKRetroTokens.Color.accent)
                            .frame(width: UIScreen.main.bounds.width * progress)
                        Spacer()
                    }
                )
        }
    }
}
```

## 🖥️ 預覽效果

運行以下預覽來查看不同的效果：

```swift
// 完整功能演示（包含所有新組件）
#Preview("Complete Demo") {
    CGDKRetroCompleteDemoView()
}

// 顏色方案對比
#Preview("Color Schemes") {
    CGDKRetroColorSchemesView()
}

// 單個組件測試
#Preview("Components") {
    CGDKRetroRoot(colorScheme: .amber) {
        VStack(spacing: CGDKRetroTokens.Space.lg) {
            CGDKRetroToggle("Test", isOn: .constant(true), colorScheme: .amber)
            CGDKRetroProgress("Loading", progress: 0.7, colorScheme: .amber)
            CGDKRetroSlider("Volume", value: .constant(80), colorScheme: .amber)
        }
        .padding()
    }
}
```

## 🎨 顏色方案展示

### 1. Classic - 經典終端
- 黑色背景 + 白色文字 + 綠色強調
- 最接近傳統UNIX終端機

### 2. Amber - 琥珀終端  
- 黑色背景 + 琥珀色文字
- 復古DOS電腦風格

### 3. Green - 綠色螢幕
- 黑色背景 + 亮綠色文字
- 經典單色螢幕風格

### 4. Blue - 藍色終端
- 深藍背景 + 亮藍色文字
- 現代終端機風格

### 5. White - 高對比
- 白色背景 + 黑色文字
- 紙張風格，適合長時間閱讀

### 6. Matrix - 駭客帝國
- 黑色背景 + Matrix綠色
- 科幻電影風格

## 📋 快速參考

### 常用組件速查
```swift
// 基礎容器
CGDKRetroRoot(colorScheme: .amber) { /* 內容 */ }
CGDKRetroContainer(title: "TITLE") { /* 內容 */ }
CGDKRetroCard { /* 內容 */ }

// 互動組件
CGDKRetroToggle("Label", isOn: $binding)
CGDKRetroSlider("Label", value: $binding, in: 0...100)
CGDKRetroPicker("Label", selection: $binding, options: array)

// 顯示組件
CGDKRetroProgress("Label", progress: 0.5, style: .bar)
CGDKRetroButton("BUTTON", style: .primary) { /* action */ }
CGDKRetroAlert(title: "Title", message: "Message", ...)

// 文字組件
CGDKRetroTextField("Placeholder", text: $binding)
CGDKRetroSectionHeader("HEADER", style: .title)
```

### 樣式選項速查
```swift
// 按鈕樣式
.primary   // 實心按鈕
.secondary // 半透明按鈕  
.outline   // 邊框按鈕

// 進度條樣式
.bar       // [████████░░░░]
.ascii     // [========----]
.dots      // [••••••••    ]
.loading   // [>>>>>>>     ]

// 標題樣式
.title     // 大標題
.heading   // 中標題
.label     // 小標題
```

## 🔄 遷移指南

### 從基礎版本升級
```swift
// 舊版本
CGDKRetroRoot {
    MyContent()
}

// 新版本（添加顏色方案）
CGDKRetroRoot(colorScheme: .amber) {
    MyContent()
}
```

### 添加新組件
```swift
// 在現有界面中添加新組件
VStack {
    // 現有內容...
    
    // 添加Toggle
    CGDKRetroToggle("New Feature", isOn: $newFeature)
    
    // 添加Progress
    CGDKRetroProgress("Status", progress: progress)
    
    // 添加Slider
    CGDKRetroSlider("Value", value: $value)
}
```

這個完整的復古主題系統讓您可以快速創建具有80年代終端機風格的iOS應用，支援多種顏色方案和豐富的UI組件，完美重現復古計算機的美學！