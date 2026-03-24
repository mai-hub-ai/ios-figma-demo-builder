import { useSearchStore } from '@/store/searchStore'

interface SearchInputProps {
  className?: string
}

export function SearchInput({ className = '' }: SearchInputProps) {
  const { keyword, setKeyword } = useSearchStore()

  const handleClear = () => {
    setKeyword('')
  }

  return (
    <div className={`relative flex-1 ${className}`}>
      <div className="flex items-center bg-white rounded-lg border border-gray-200 px-3 py-2">
        {/* 搜索图标 */}
        <svg className="w-5 h-5 text-gray-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        
        {/* 输入框 */}
        <input
          type="text"
          value={keyword}
          onChange={(e) => setKeyword(e.target.value)}
          placeholder="位置/品牌/酒店"
          className="flex-1 ml-2 text-base text-gray-900 placeholder-gray-400 focus:outline-none"
        />
        
        {/* 清除按钮 */}
        {keyword && (
          <button onClick={handleClear} className="flex-shrink-0 p-1">
            <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        )}
      </div>
    </div>
  )
}
