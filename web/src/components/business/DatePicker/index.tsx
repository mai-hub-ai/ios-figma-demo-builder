import { useSearchStore } from '@/store/searchStore'

interface DatePickerProps {
  className?: string
}

export function DatePicker({ className = '' }: DatePickerProps) {
  const { checkInDate, checkOutDate, nightCount, openCalendar } = useSearchStore()

  // 格式化日期显示 - 提取月和日
  const formatDateParts = (dateStr: string) => {
    const date = new Date(dateStr)
    const month = date.getMonth() + 1
    const day = date.getDate()
    return { month, day }
  }

  // 获取日期标签
  const getDateLabel = (dateStr: string): string => {
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

  const checkInParts = formatDateParts(checkInDate)
  const checkOutParts = formatDateParts(checkOutDate)
  const checkInLabel = getDateLabel(checkInDate)
  const checkOutLabel = getDateLabel(checkOutDate)

  return (
    <button 
      onClick={openCalendar}
      className={`flex items-center w-full bg-white rounded-lg border border-gray-200 px-4 py-3 ${className}`}
    >
      {/* 入住日期 - 居左 */}
      <div className="flex items-baseline gap-1">
        {/* 大号日期数字 */}
        <span 
          className="text-[48px] font-normal leading-none tracking-normal"
          style={{ fontFamily: 'Fliggy Sans 102, -apple-system, sans-serif' }}
        >
          {checkInParts.day}
        </span>
        {/* 月日文案 */}
        <span 
          className="text-[28px] font-normal leading-[140%] tracking-normal text-gray-900"
          style={{ fontFamily: 'PingFang SC, -apple-system, sans-serif' }}
        >
          {checkInParts.month}月
        </span>
        {/* 今天/明天标签 - 灰色 */}
        {checkInLabel && (
          <span 
            className="text-[28px] font-normal leading-[140%] tracking-normal text-gray-400 ml-1"
            style={{ fontFamily: 'PingFang SC, -apple-system, sans-serif' }}
          >
            {checkInLabel}
          </span>
        )}
      </div>

      {/* 间隔晚数 - 纯展示，不可点击 */}
      <div className="flex items-center justify-center flex-1">
        <div className="flex items-center gap-1 px-4">
          <span 
            className="text-[28px] font-normal leading-[140%] tracking-normal text-gray-500"
            style={{ fontFamily: 'PingFang SC, -apple-system, sans-serif' }}
          >
            {nightCount}晚
          </span>
        </div>
      </div>

      {/* 离店日期 */}
      <div className="flex items-baseline gap-1">
        {/* 大号日期数字 */}
        <span 
          className="text-[48px] font-normal leading-none tracking-normal"
          style={{ fontFamily: 'Fliggy Sans 102, -apple-system, sans-serif' }}
        >
          {checkOutParts.day}
        </span>
        {/* 月日文案 */}
        <span 
          className="text-[28px] font-normal leading-[140%] tracking-normal text-gray-900"
          style={{ fontFamily: 'PingFang SC, -apple-system, sans-serif' }}
        >
          {checkOutParts.month}月
        </span>
        {/* 今天/明天标签 - 灰色 */}
        {checkOutLabel && (
          <span 
            className="text-[28px] font-normal leading-[140%] tracking-normal text-gray-400 ml-1"
            style={{ fontFamily: 'PingFang SC, -apple-system, sans-serif' }}
          >
            {checkOutLabel}
          </span>
        )}
      </div>
    </button>
  )
}
