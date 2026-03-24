import { useState, useEffect, useRef } from 'react'
import { useSearchStore } from '@/store/searchStore'

export function CalendarSheet() {
  const { 
    checkInDate, 
    checkOutDate, 
    calendarData,
    isCalendarOpen, 
    closeCalendar,
    setDateRange
  } = useSearchStore()

  // 本地状态用于浮层内的选择 - 存储两个选中的日期
  const [firstSelected, setFirstSelected] = useState<string | null>(null)
  const [secondSelected, setSecondSelected] = useState<string | null>(null)
  
  // 滚动容器ref
  const scrollContainerRef = useRef<HTMLDivElement>(null)
  const selectedDateRef = useRef<HTMLButtonElement>(null)

  // 获取昨天日期（用于禁用历史日期）
  const getYesterday = () => {
    const yesterday = new Date()
    yesterday.setHours(0, 0, 0, 0)
    yesterday.setDate(yesterday.getDate() - 1)
    return yesterday
  }

  // 打开浮层时同步当前日期，并滚动到选中日期
  useEffect(() => {
    if (isCalendarOpen) {
      // 按时间顺序排序，早的作为first，晚的作为second
      const dates = [checkInDate, checkOutDate].sort()
      setFirstSelected(dates[0])
      setSecondSelected(dates[1])
      
      // 延迟滚动，等待DOM渲染
      setTimeout(() => {
        if (selectedDateRef.current && scrollContainerRef.current) {
          selectedDateRef.current.scrollIntoView({ 
            behavior: 'smooth', 
            block: 'center' 
          })
        }
      }, 100)
    }
  }, [isCalendarOpen, checkInDate, checkOutDate])

  if (!isCalendarOpen) return null

  // 计算临时选择的晚数
  const tempNightCount = firstSelected && secondSelected 
    ? Math.max(1, Math.round(
        (new Date(secondSelected).getTime() - new Date(firstSelected).getTime()) / (1000 * 60 * 60 * 24)
      ))
    : 1

  // 判断日期是否被选中（入住或离店）
  const isSelected = (dateStr: string) => {
    return dateStr === firstSelected || dateStr === secondSelected
  }

  // 判断日期是否在选中的区间内
  const isInRange = (dateStr: string) => {
    if (!firstSelected || !secondSelected) return false
    const date = new Date(dateStr)
    const start = new Date(firstSelected)
    const end = new Date(secondSelected)
    return date > start && date < end
  }

  // 判断日期是否是历史日期（昨天及之前）
  const isHistoryDate = (dateStr: string) => {
    const date = new Date(dateStr)
    date.setHours(0, 0, 0, 0)
    return date <= getYesterday()
  }

  // 处理日期点击 - 自由选择两个日期
  const handleDateClick = (dateStr: string) => {
    // 历史日期不可选
    if (isHistoryDate(dateStr)) return

    // 如果点击的是已选中的日期，取消选择
    if (dateStr === firstSelected) {
      setFirstSelected(null)
      return
    }
    if (dateStr === secondSelected) {
      setSecondSelected(null)
      return
    }

    // 如果两个都未选中，选为第一个
    if (!firstSelected && !secondSelected) {
      setFirstSelected(dateStr)
      return
    }

    // 如果只选中了一个，选为第二个
    if (firstSelected && !secondSelected) {
      setSecondSelected(dateStr)
      return
    }
    if (!firstSelected && secondSelected) {
      setFirstSelected(dateStr)
      return
    }

    // 如果两个都选中了，替换较远的那个
    if (firstSelected && secondSelected) {
      const clickedDate = new Date(dateStr)
      const firstDate = new Date(firstSelected)
      const secondDate = new Date(secondSelected)
      
      const distToFirst = Math.abs(clickedDate.getTime() - firstDate.getTime())
      const distToSecond = Math.abs(clickedDate.getTime() - secondDate.getTime())
      
      if (distToFirst > distToSecond) {
        // 替换第一个（较远的）
        setFirstSelected(dateStr)
      } else {
        // 替换第二个（较远的）
        setSecondSelected(dateStr)
      }
    }
  }

  // 确认选择 - 自动解析入住/离店
  const handleConfirm = () => {
    if (!firstSelected || !secondSelected) {
      closeCalendar()
      return
    }
    
    // 按时间排序，早的是入住，晚的是离店
    const dates = [firstSelected, secondSelected].sort()
    setDateRange(dates[0], dates[1])
    closeCalendar()
  }

  // 格式化显示日期
  const formatDisplayDate = (dateStr: string | null) => {
    if (!dateStr) return '--'
    const date = new Date(dateStr)
    return `${date.getMonth() + 1}月${date.getDate()}日`
  }

  // 获取日期标签（今天/明天）
  const getDateLabel = (dateStr: string) => {
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    const tomorrow = new Date(today)
    tomorrow.setDate(tomorrow.getDate() + 1)
    const target = new Date(dateStr)
    target.setHours(0, 0, 0, 0)
    
    if (target.getTime() === today.getTime()) return '今天'
    if (target.getTime() === tomorrow.getTime()) return '明天'
    return ''
  }

  // 计算入住和离店日期（按时间排序）
  const checkInStr = firstSelected && secondSelected 
    ? [firstSelected, secondSelected].sort()[0] 
    : firstSelected || checkInDate
  const checkOutStr = firstSelected && secondSelected
    ? [firstSelected, secondSelected].sort()[1]
    : secondSelected || checkOutDate

  return (
    <div className="fixed inset-0 z-50 bg-black/50" onClick={closeCalendar}>
      <div 
        className="absolute bottom-0 left-0 right-0 bg-white rounded-t-2xl h-[60vh] flex flex-col"
        onClick={(e) => e.stopPropagation()}
      >
        {/* 标题栏 */}
        <div className="flex items-center justify-between p-4 border-b border-gray-100 flex-shrink-0">
          <h3 className="text-xl font-semibold text-gray-900">选择日期</h3>
          <button onClick={closeCalendar} className="p-1">
            <svg className="w-7 h-7 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* 已选日期展示 - 自动解析入住/离店 */}
        <div className="flex items-center justify-between px-6 py-4 bg-gray-50 flex-shrink-0">
          <div className="text-center">
            <div className="text-sm text-gray-500 mb-1">入住</div>
            <div className="text-xl font-medium text-primary">
              {formatDisplayDate(checkInStr)}
            </div>
            <div className="text-sm text-gray-400">{checkInStr ? getDateLabel(checkInStr) : ''}</div>
          </div>
          
          <div className="flex items-center px-4">
            <div className="text-base text-gray-500">共{tempNightCount}晚</div>
          </div>
          
          <div className="text-center">
            <div className="text-sm text-gray-500 mb-1">离店</div>
            <div className="text-xl font-medium text-primary">
              {formatDisplayDate(checkOutStr)}
            </div>
            <div className="text-sm text-gray-400">{checkOutStr ? getDateLabel(checkOutStr) : ''}</div>
          </div>
        </div>

        {/* 日历内容 - 可滚动 */}
        <div 
          ref={scrollContainerRef}
          className="flex-1 overflow-y-auto p-4" 
          style={{ WebkitOverflowScrolling: 'touch' }}
        >
          {calendarData.map((monthData) => (
            <div key={`${monthData.year}-${monthData.month}`} className="mb-6">
              {/* 月份标题 */}
              <div className="text-center text-lg font-semibold text-gray-900 mb-3">
                {monthData.year}年{monthData.month}月
              </div>
              
              {/* 星期标题 */}
              <div className="grid grid-cols-7 mb-2">
                {['日', '一', '二', '三', '四', '五', '六'].map((day) => (
                  <div key={day} className="text-center text-sm text-gray-400 py-2">
                    {day}
                  </div>
                ))}
              </div>
              
              {/* 日期网格 */}
              <div className="grid grid-cols-7 gap-1">
                {monthData.days.map((day) => {
                  const selected = isSelected(day.date)
                  const inRange = isInRange(day.date)
                  const isHistory = isHistoryDate(day.date)
                  const label = getDateLabel(day.date)
                  
                  return (
                    <button
                      key={day.date}
                      ref={selected ? selectedDateRef : null}
                      onClick={() => handleDateClick(day.date)}
                      disabled={isHistory}
                      className={`
                        relative aspect-square flex flex-col items-center justify-center rounded-lg text-base
                        ${isHistory ? 'text-gray-300 cursor-not-allowed' : ''}
                        ${selected ? 'bg-primary text-white' : ''}
                        ${inRange ? 'bg-primary/10 text-primary' : ''}
                        ${!selected && !inRange && !isHistory ? 'text-gray-900 hover:bg-gray-100' : ''}
                      `}
                    >
                      <span className="font-medium text-base">{new Date(day.date).getDate()}</span>
                      {label && (
                        <span className={`text-xs ${selected ? 'text-white/80' : isHistory ? 'text-gray-300' : 'text-gray-400'}`}>
                          {label}
                        </span>
                      )}
                    </button>
                  )
                })}
              </div>
            </div>
          ))}
        </div>

        {/* 底部确认按钮 - 带安全距离 */}
        <div className="p-4 pb-safe-bottom border-t border-gray-100 bg-white flex-shrink-0">
          <button
            onClick={handleConfirm}
            className="w-full py-3 bg-primary text-white rounded-lg font-medium text-lg"
          >
            确认
          </button>
        </div>
      </div>
    </div>
  )
}
