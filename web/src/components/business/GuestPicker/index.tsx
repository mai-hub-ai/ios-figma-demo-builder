import { useSearchStore } from '@/store/searchStore'

interface GuestPickerProps {
  className?: string
}

export function GuestPicker({ className = '' }: GuestPickerProps) {
  const { roomCount, adultCount, childCount, openGuestPicker } = useSearchStore()

  return (
    <button
      onClick={openGuestPicker}
      className={`flex items-center justify-between w-full bg-white rounded-lg border border-gray-200 px-3 py-2 ${className}`}
    >
      {/* 图标 */}
      <svg className="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
      </svg>
      
      {/* 人数显示 */}
      <span className="flex-1 ml-2 text-left text-base text-gray-900">
        {roomCount}间房 {adultCount}成人 {childCount > 0 && `${childCount}儿童`}
      </span>
      
      {/* 箭头 */}
      <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
      </svg>
    </button>
  )
}

// 人数选择浮层组件
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
        className="absolute bottom-0 left-0 right-0 bg-white rounded-t-2xl"
        onClick={(e) => e.stopPropagation()}
      >
        {/* 标题栏 */}
        <div className="flex items-center justify-between p-4 border-b border-gray-100">
          <h3 className="text-lg font-semibold text-gray-900">选择人数</h3>
          <button onClick={closeGuestPicker} className="p-1">
            <svg className="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* 房间数 */}
        <div className="flex items-center justify-between px-4 py-3 border-b border-gray-100">
          <span className="text-base text-gray-900">房间数</span>
          <div className="flex items-center gap-4">
            <button 
              onClick={() => updateCount('room', -1)}
              disabled={roomCount <= 1}
              className="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-30"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
              </svg>
            </button>
            <span className="text-lg font-medium w-8 text-center">{roomCount}</span>
            <button 
              onClick={() => updateCount('room', 1)}
              className="w-8 h-8 rounded-full border border-primary text-primary flex items-center justify-center"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
              </svg>
            </button>
          </div>
        </div>

        {/* 成人数 */}
        <div className="flex items-center justify-between px-4 py-3 border-b border-gray-100">
          <span className="text-base text-gray-900">成人数</span>
          <div className="flex items-center gap-4">
            <button 
              onClick={() => updateCount('adult', -1)}
              disabled={adultCount <= 1}
              className="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-30"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
              </svg>
            </button>
            <span className="text-lg font-medium w-8 text-center">{adultCount}</span>
            <button 
              onClick={() => updateCount('adult', 1)}
              className="w-8 h-8 rounded-full border border-primary text-primary flex items-center justify-center"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
              </svg>
            </button>
          </div>
        </div>

        {/* 儿童数 */}
        <div className="flex items-center justify-between px-4 py-3 border-b border-gray-100">
          <span className="text-base text-gray-900">儿童数</span>
          <div className="flex items-center gap-4">
            <button 
              onClick={() => updateCount('child', -1)}
              disabled={childCount <= 0}
              className="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-30"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 12H4" />
              </svg>
            </button>
            <span className="text-lg font-medium w-8 text-center">{childCount}</span>
            <button 
              onClick={() => updateCount('child', 1)}
              className="w-8 h-8 rounded-full border border-primary text-primary flex items-center justify-center"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
              </svg>
            </button>
          </div>
        </div>

        {/* 确认按钮 */}
        <div className="p-4">
          <button
            onClick={closeGuestPicker}
            className="w-full py-3 bg-primary text-white rounded-lg font-medium"
          >
            确认
          </button>
        </div>
      </div>
    </div>
  )
}
