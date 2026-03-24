import { useState, useEffect } from 'react'
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

  // 本地状态用于浮层内的选择
  const [tempCheckIn, setTempCheckIn] = useState(checkInDate)
  const [tempCheckOut, setTempCheckOut] = useState(checkOutDate)
  const [selecting, setSelecting] = useState<'checkIn' | 'checkOut'>('checkIn')

  // 打开浮层时同步当前日期
  useEffect(() => {
    if (isCalendarOpen) {
      setTempCheckIn(checkInDate)
      setTempCheckOut(checkOutDate)
      setSelecting('checkIn')
    }
  }, [isCalendarOpen, checkInDate, checkOutDate])

  if (!isCalendarOpen) return null

  // 计算临时选择的晚数
  const tempNightCount = Math.round(
    (new Date(tempCheckOut).getTime() - new Date(tempCheckIn).getTime()) / (1000 * 60 * 60 * 24)
  )

  // 判断日期是否被选中
  const isSelected = (dateStr: string) => {
    if (selecting === 'checkIn') {
      return dateStr === tempCheckIn
    }
    return dateStr === tempCheckOut
  }

  // 判断日期是否在选中的区间内
  const isInRange = (dateStr: string) => {
    const date = new Date(dateStr)
    const start = new Date(tempCheckIn)
    const end = new Date(tempCheckOut)
    return date > start && date < end
  }

  // 处理日期点击
  const handleDateClick = (dateStr: string) => {
    if (selecting === 'checkIn') {
      setTempCheckIn(dateStr)
      // 如果新选择的入住日期晚于当前离店日期，自动调整离店日期
      const newCheckIn = new Date(dateStr)
      const currentCheckOut = new Date(tempCheckOut)
      if (newCheckIn >= currentCheckOut) {
        const nextDay = new Date(newCheckIn)
        nextDay.setDate(nextDay.getDate() + 1)
        setTempCheckOut(nextDay.toISOString().split('T')[0])
      }
      setSelecting('checkOut')
    } else {
      const newCheckOut = new Date(dateStr)
      const currentCheckIn = new Date(tempCheckIn)
      // 离店日期必须晚于入住日期
      if (newCheckOut > currentCheckIn) {
        setTempCheckOut(dateStr)
      }
    }
  }

  // 确认选择
  const handleConfirm = () => {
    setDateRange(tempCheckIn, tempCheckOut)
    closeCalendar()
  }

  // 格式化显示日期
  const formatDisplayDate = (dateStr: string) => {
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

        {/* 已选日期展示 */}
        <div className="flex items-center justify-between px-6 py-4 bg-gray-50 flex-shrink-0">
          <div className="text-center">
            <div className="text-sm text-gray-500 mb-1">入住</div>
            <div className={`text-xl font-medium ${selecting === 'checkIn' ? 'text-primary' : 'text-gray-900'}`}>
              {formatDisplayDate(tempCheckIn)}
            </div>
            <div className="text-sm text-gray-400">{getDateLabel(tempCheckIn)}</div>
          </div>
          
          <div className="flex items-center px-4">
            <div className="text-base text-gray-500">共{tempNightCount}晚</div>
          </div>
          
          <div className="text-center">
            <div className="text-sm text-gray-500 mb-1">离店</div>
            <div className={`text-xl font-medium ${selecting === 'checkOut' ? 'text-primary' : 'text-gray-900'}`}>
              {formatDisplayDate(tempCheckOut)}
            </div>
            <div className="text-sm text-gray-400">{getDateLabel(tempCheckOut)}</div>
          </div>
        </div>

        {/* 日历内容 - 可滚动 */}
        <div className="flex-1 overflow-y-auto p-4" style={{ WebkitOverflowScrolling: 'touch' }}>
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
                  const label = getDateLabel(day.date)
                  
                  return (
                    <button
                      key={day.date}
                      onClick={() => day.available && handleDateClick(day.date)}
                      disabled={!day.available}
                      className={`
                        relative aspect-square flex flex-col items-center justify-center rounded-lg text-base
                        ${!day.available ? 'text-gray-300' : ''}
                        ${selected ? 'bg-primary text-white' : ''}
                        ${inRange ? 'bg-primary/10 text-primary' : ''}
                        ${!selected && !inRange && day.available ? 'text-gray-900 hover:bg-gray-100' : ''}
                      `}
                    >
                      <span className="font-medium text-base">{new Date(day.date).getDate()}</span>
                      {label && (
                        <span className={`text-xs ${selected ? 'text-white/80' : 'text-gray-400'}`}>
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
