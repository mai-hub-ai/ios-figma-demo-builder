import { useSearchStore } from '@/store/searchStore'

interface DatePickerProps {
  className?: string
}

export function DatePicker({ className = '' }: DatePickerProps) {
  const { checkInDate, checkOutDate, nightCount, openCalendar } = useSearchStore()

  // 格式化日期显示
  const formatDateDisplay = (dateStr: string) => {
    const date = new Date(dateStr)
    const month = date.getMonth() + 1
    const day = date.getDate()
    return `${month}月${day}日`
  }

  // 获取日期标签
  const getDateLabel = (dateStr: string) => {
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    const tomorrow = new Date(today)
    tomorrow.setDate(tomorrow.getDate() + 1)
    
    const targetDate = new Date(dateStr)
    targetDate.setHours(0, 0, 0, 0)
    
    if (targetDate.getTime() === today.getTime()) return '今天'
    if (targetDate.getTime() === tomorrow.getTime()) return '明天'
    return ''
  }

  return (
    <button 
      onClick={openCalendar}
      className={`flex items-center justify-between w-full bg-white rounded-lg border border-gray-200 px-3 py-2 ${className}`}
    >
      {/* 入住日期 */}
      <div className="flex items-center gap-2">
        <div className="text-center">
          <div className="text-base font-medium text-gray-900">
            {formatDateDisplay(checkInDate)}
          </div>
          <div className="text-xs text-gray-500">
            {getDateLabel(checkInDate) || '入住'}
          </div>
        </div>
      </div>

      {/* 间隔晚数 */}
      <div className="flex items-center gap-1 px-3 py-1 bg-gray-50 rounded-full">
        <span className="text-sm font-medium text-gray-700">{nightCount}晚</span>
        <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
        </svg>
      </div>

      {/* 离店日期 */}
      <div className="flex items-center gap-2">
        <div className="text-center">
          <div className="text-base font-medium text-gray-900">
            {formatDateDisplay(checkOutDate)}
          </div>
          <div className="text-xs text-gray-500">
            {getDateLabel(checkOutDate) || '离店'}
          </div>
        </div>
      </div>
    </button>
  )
}
