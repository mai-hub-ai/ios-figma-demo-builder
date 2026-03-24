import { useSearchStore } from '@/store/searchStore'

interface GuestPickerProps {
  className?: string
}

// 飞猪品牌色
const brandColor = '#FFE033'

export function GuestPicker({ className = '' }: GuestPickerProps) {
  const { roomCount, adultCount, childCount, openGuestPicker } = useSearchStore()

  return (
    <button
      onClick={openGuestPicker}
      className={`flex items-center justify-between w-full px-3 ${className}`}
      style={{ height: 42 }}
    >
      {/* 人数显示 - 字号按经验适配，始终显示儿童数 */}
      <span 
        className="flex-1 text-left text-gray-900"
        style={{ fontSize: 16 }}
      >
        {roomCount}间房 {adultCount}成人 {childCount}儿童
      </span>
      
      {/* 箭头 */}
      <svg 
        className="text-gray-400 flex-shrink-0" 
        style={{ width: 16, height: 16 }}
        fill="none" 
        stroke="currentColor" 
        viewBox="0 0 24 24"
      >
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
      </svg>
    </button>
  )
}

// 人数选择浮层组件 - 高度自适应
export function GuestPickerSheet() {
  const { 
    roomCount, 
    adultCount, 
    childCount, 
    isGuestPickerOpen, 
    closeGuestPicker,
    setGuestInfo 
  } = useSearchStore()

  if (!isGuestPickerOpen) return null

  const updateCount = (target: 'room' | 'adult' | 'child', delta: number) => {
    const newValues = {
      room: target === 'room' ? Math.max(1, roomCount + delta) : roomCount,
      adult: target === 'adult' ? Math.max(1, adultCount + delta) : adultCount,
      child: target === 'child' ? Math.max(0, childCount + delta) : childCount,
    }
    setGuestInfo(newValues.room, newValues.adult, newValues.child)
  }

  return (
    <div className="fixed inset-0 z-50 bg-black/50" onClick={closeGuestPicker}>
      <div 
        className="absolute bottom-0 left-0 right-0 bg-white rounded-t-2xl flex flex-col"
        style={{ maxHeight: '70vh' }}
        onClick={(e) => e.stopPropagation()}
      >
        {/* 标题栏 */}
        <div className="flex items-center justify-between p-4 border-b border-gray-100 flex-shrink-0">
          <h3 className="text-xl font-semibold text-gray-900">选择人数</h3>
          <button onClick={closeGuestPicker} className="p-1">
            <svg className="w-7 h-7 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* 房间数 */}
        <div className="flex items-center justify-between px-4 py-4 border-b border-gray-100">
          <span className="text-gray-900" style={{ fontSize: 16 }}>房间数</span>
          <div className="flex items-center gap-4">
            <button 
              onClick={() => updateCount('room', -1)}
              disabled={roomCount <= 1}
              className="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-30"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
              </svg>
            </button>
            <span className="font-medium w-10 text-center" style={{ fontSize: 18 }}>{roomCount}</span>
            <button 
              onClick={() => updateCount('room', 1)}
              className="w-10 h-10 rounded-full border flex items-center justify-center"
              style={{ borderColor: brandColor, color: '#202124' }}
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
              </svg>
            </button>
          </div>
        </div>

        {/* 成人数 */}
        <div className="flex items-center justify-between px-4 py-4 border-b border-gray-100">
          <span className="text-gray-900" style={{ fontSize: 16 }}>成人数</span>
          <div className="flex items-center gap-4">
            <button 
              onClick={() => updateCount('adult', -1)}
              disabled={adultCount <= 1}
              className="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-30"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
              </svg>
            </button>
            <span className="font-medium w-10 text-center" style={{ fontSize: 18 }}>{adultCount}</span>
            <button 
              onClick={() => updateCount('adult', 1)}
              className="w-10 h-10 rounded-full border flex items-center justify-center"
              style={{ borderColor: brandColor, color: '#202124' }}
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
              </svg>
            </button>
          </div>
        </div>

        {/* 儿童数 */}
        <div className="flex items-center justify-between px-4 py-4 border-b border-gray-100">
          <span className="text-gray-900" style={{ fontSize: 16 }}>儿童数</span>
          <div className="flex items-center gap-4">
            <button 
              onClick={() => updateCount('child', -1)}
              disabled={childCount <= 0}
              className="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-30"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
              </svg>
            </button>
            <span className="font-medium w-10 text-center" style={{ fontSize: 18 }}>{childCount}</span>
            <button 
              onClick={() => updateCount('child', 1)}
              className="w-10 h-10 rounded-full border flex items-center justify-center"
              style={{ borderColor: brandColor, color: '#202124' }}
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
              </svg>
            </button>
          </div>
        </div>

        {/* 确认按钮 - 底部安全距离 */}
        <div className="p-4 pb-safe-bottom flex-shrink-0">
          <button
            onClick={closeGuestPicker}
            className="w-full py-3 rounded-lg font-medium text-lg"
            style={{ backgroundColor: brandColor, color: '#202124' }}
          >
            确认
          </button>
        </div>
      </div>
    </div>
  )
}
