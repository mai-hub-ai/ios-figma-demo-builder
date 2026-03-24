import { useSearchStore } from '@/store/searchStore'

interface HotKeywordsProps {
  className?: string
}

export function HotKeywords({ className = '' }: HotKeywordsProps) {
  const { hotKeywords, setKeyword } = useSearchStore()

  const handleKeywordClick = (text: string) => {
    setKeyword(text)
  }

  if (hotKeywords.length === 0) return null

  return (
    <div className={`${className}`}>
      <div className="flex items-center gap-2 overflow-x-auto pb-2 scrollbar-hide">
        {hotKeywords.map((keyword) => (
          <button
            key={keyword.id}
            onClick={() => handleKeywordClick(keyword.text)}
            className="flex-shrink-0 px-3 py-1.5 bg-gray-50 text-gray-600 text-sm rounded-full whitespace-nowrap hover:bg-gray-100 transition-colors"
          >
            {keyword.text}
          </button>
        ))}
      </div>
    </div>
  )
}
