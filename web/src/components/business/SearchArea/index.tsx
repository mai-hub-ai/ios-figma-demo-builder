import { CitySelector } from '../CitySelector'
import { SearchInput } from '../SearchInput'
import { DatePicker } from '../DatePicker'
import { GuestPicker, GuestPickerSheet } from '../GuestPicker'
import { HotKeywords } from '../HotKeywords'
import { SearchButton } from '../SearchButton'
import { CalendarSheet } from '../CalendarSheet'

interface SearchAreaProps {
  className?: string
}

export function SearchArea({ className = '' }: SearchAreaProps) {
  return (
    <div className={`bg-white rounded-xl p-4 shadow-sm ${className}`}>
      {/* 第一行：城市选择 + 搜索输入框 */}
      <div className="flex items-center gap-2 pb-3 border-b border-gray-100">
        <CitySelector />
        <SearchInput />
      </div>

      {/* 第二行：日期选择 */}
      <div className="py-3 border-b border-gray-100">
        <DatePicker />
      </div>

      {/* 第三行：人数选择 */}
      <div className="py-3 border-b border-gray-100">
        <GuestPicker />
      </div>

      {/* 热搜词 */}
      <div className="pt-3 mb-2">
        <HotKeywords />
      </div>

      {/* 搜索按钮 */}
      <SearchButton />

      {/* 人数选择浮层 */}
      <GuestPickerSheet />

      {/* 日历选择浮层 */}
      <CalendarSheet />
    </div>
  )
}
