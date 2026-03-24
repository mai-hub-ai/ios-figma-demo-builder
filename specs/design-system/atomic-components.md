# 原子组件库

## 已沉淀的可复用组件

### 1. CitySelector 城市选择器
**文件**：`src/components/business/CitySelector/index.tsx`

**功能**：
- 触发器显示当前选中城市
- 浮层包含：搜索框、热门城市网格、字母索引城市列表
- 右侧字母索引导航，点击锚定

**Props**：
```typescript
interface CitySelectorProps {
  className?: string
}
```

**使用示例**：
```tsx
<CitySelector />
```

**依赖**：Zustand store (selectedCity, hotCities, cityList, ...)

---

### 2. SearchInput 搜索输入框
**文件**：`src/components/business/SearchInput/index.tsx`

**功能**：
- 带搜索图标的输入框
- 支持 placeholder
- 自适应图标大小

**Props**：
```typescript
interface SearchInputProps {
  className?: string
}
```

**使用示例**：
```tsx
<SearchInput />
```

---

### 3. DatePicker 日期选择器
**文件**：`src/components/business/DatePicker/index.tsx`

**功能**：
- 显示入住/离店日期
- 显示晚数（椭圆框样式）
- 点击拉起 CalendarSheet 浮层

**Props**：
```typescript
interface DatePickerProps {
  className?: string
}
```

**使用示例**：
```tsx
<DatePicker />
```

**配套浮层**：CalendarSheet

---

### 4. GuestPicker 人数选择器
**文件**：`src/components/business/GuestPicker/index.tsx`

**功能**：
- 显示房间数/成人/儿童
- 始终显示儿童数（包括0）
- 点击拉起 GuestPickerSheet 浮层

**导出**：
- `GuestPicker` - 触发器组件
- `GuestPickerSheet` - 浮层组件（需在父组件中引入）

**Props**：
```typescript
interface GuestPickerProps {
  className?: string
}
```

**使用示例**：
```tsx
<GuestPicker />
<GuestPickerSheet />
```

---

### 5. SearchButton 搜索按钮
**文件**：`src/components/business/SearchButton/index.tsx`

**功能**：
- 胶囊形按钮
- 飞猪黄色背景
- 触发搜索逻辑

**Props**：
```typescript
interface SearchButtonProps {
  className?: string
  onClick?: () => void
}
```

**使用示例**：
```tsx
<SearchButton onClick={handleSearch} />
```

---

### 6. HotKeywords 热搜词
**文件**：`src/components/business/HotKeywords/index.tsx`

**功能**：
- 横向滚动热搜词列表
- 点击填充搜索框

**Props**：
```typescript
interface HotKeywordsProps {
  className?: string
}
```

**使用示例**：
```tsx
<HotKeywords />
```

---

### 7. CalendarSheet 日历浮层
**文件**：`src/components/business/CalendarSheet/index.tsx`

**功能**：
- 底部滑出浮层
- 支持任意顺序选择两个日期
- 自动解析入住/离店
- 历史日期禁用
- 锚定滚动到选中日期

**Props**：无（依赖 Zustand store）

**使用示例**：
```tsx
<CalendarSheet />
```

**依赖**：Zustand store (checkInDate, checkOutDate, calendarData, ...)

---

## 组合组件

### SearchArea 搜索区域
**文件**：`src/components/business/SearchArea/index.tsx`

**功能**：组合所有搜索相关组件

**包含组件**：
- CitySelector
- SearchInput
- DatePicker
- GuestPicker + GuestPickerSheet
- HotKeywords
- SearchButton
- CalendarSheet

**Props**：
```typescript
interface SearchAreaProps {
  className?: string
}
```

**使用示例**：
```tsx
<SearchArea />
```

---

## 状态管理

所有业务组件依赖 Zustand store：`src/store/searchStore.ts`

**主要状态**：
- `selectedCity` - 选中城市
- `checkInDate/checkOutDate` - 入住/离店日期
- `roomCount/adultCount/childCount` - 人数
- `searchKeyword` - 搜索关键词
- 各浮层的开关状态

**主要方法**：
- `setSelectedCity(city)`
- `setDateRange(checkIn, checkOut)`
- `setGuestInfo(room, adult, child)`
- `open/closeXxx()` - 浮层控制
