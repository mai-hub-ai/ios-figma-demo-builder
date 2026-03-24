import { useState, useMemo, useRef, useEffect } from 'react'
import { useSearchStore } from '@/store/searchStore'
import type { City } from '@/types'

interface CitySelectorProps {
  className?: string
}

export function CitySelector({ className = '' }: CitySelectorProps) {
  const { selectedCity, hotCities, cityList, isCitySelectorOpen, openCitySelector, closeCitySelector, setSelectedCity } = useSearchStore()
  const [searchText, setSearchText] = useState('')
  const scrollContainerRef = useRef<HTMLDivElement>(null)

  // 按首字母分组所有城市
  const groupedCities = useMemo(() => {
    const groups: Record<string, City[]> = {}
    cityList.forEach(city => {
      const letter = city.firstLetter?.toUpperCase() || '#'
      if (!groups[letter]) {
        groups[letter] = []
      }
      groups[letter].push(city)
    })
    // 按字母排序
    return Object.keys(groups).sort().reduce((acc, key) => {
      acc[key] = groups[key].sort((a, b) => a.cityName.localeCompare(b.cityName, 'zh-CN'))
      return acc
    }, {} as Record<string, City[]>)
  }, [cityList])

  // 获取所有字母索引
  const letterIndex = useMemo(() => Object.keys(groupedCities), [groupedCities])

  // 搜索过滤
  const filteredHotCities = useMemo(() => {
    if (!searchText) return hotCities
    return hotCities.filter(city => 
      city.cityName.includes(searchText) || 
      city.pinyin?.toLowerCase().includes(searchText.toLowerCase())
    )
  }, [hotCities, searchText])

  const filteredGroupedCities = useMemo(() => {
    if (!searchText) return groupedCities
    const result: Record<string, City[]> = {}
    Object.entries(groupedCities).forEach(([letter, cities]) => {
      const filtered = cities.filter(city => 
        city.cityName.includes(searchText) || 
        city.pinyin?.toLowerCase().includes(searchText.toLowerCase())
      )
      if (filtered.length) {
        result[letter] = filtered
      }
    })
    return result
  }, [groupedCities, searchText])

  const handleSelectCity = (city: City) => {
    setSelectedCity(city)
    closeCitySelector()
    setSearchText('')
  }

  // 点击字母索引滚动到对应位置
  const scrollToLetter = (letter: string) => {
    const element = document.getElementById(`city-group-${letter}`)
    if (element && scrollContainerRef.current) {
      const containerTop = scrollContainerRef.current.getBoundingClientRect().top
      const elementTop = element.getBoundingClientRect().top
      const scrollTop = elementTop - containerTop + scrollContainerRef.current.scrollTop
      scrollContainerRef.current.scrollTo({ top: scrollTop, behavior: 'smooth' })
    }
  }

  // 打开浮层时加载城市列表
  useEffect(() => {
    if (isCitySelectorOpen && cityList.length === 0) {
      // 触发加载
    }
  }, [isCitySelectorOpen, cityList.length])

  // 截断城市名（超过5个字）
  const truncateCityName = (name: string) => {
    if (name.length <= 5) return name
    return name.slice(0, 5) + '...'
  }

  return (
    <div className={`relative flex-shrink-0 ${className}`}>
      {/* 城市选择器触发器 - 宽度自适应，文字不换行 */}
      <button
        onClick={openCitySelector}
        className="flex items-center gap-1 px-3 py-2 bg-white rounded-lg border border-gray-200 whitespace-nowrap"
        style={{ height: 50 }}
      >
        <span 
          className="font-medium text-gray-900 truncate"
          style={{ fontSize: 18, maxWidth: 120 }} // 放宽宽度，最大120px，超出截断
          title={selectedCity?.cityName}
        >
          {truncateCityName(selectedCity?.cityName || '选择')}
        </span>
        <svg className="w-4 h-4 text-gray-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {/* 城市选择浮层 */}
      {isCitySelectorOpen && (
        <div className="fixed inset-0 z-50 bg-black/50" onClick={closeCitySelector}>
          <div 
            className="absolute bottom-0 left-0 right-0 bg-white rounded-t-2xl h-[60vh] flex flex-col"
            onClick={(e) => e.stopPropagation()}
          >
            {/* 标题栏 */}
            <div className="flex items-center justify-between p-4 border-b border-gray-100 flex-shrink-0">
              <h3 className="text-xl font-semibold text-gray-900">选择城市</h3>
              <button onClick={closeCitySelector} className="p-1">
                <svg className="w-7 h-7 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            {/* 搜索框 - 修复iOS键盘拉起 */}
            <div className="p-4 border-b border-gray-100 flex-shrink-0">
              <input
                type="text"
                inputMode="search"
                value={searchText}
                onChange={(e) => setSearchText(e.target.value)}
                placeholder="搜索城市"
                autoFocus
                className="w-full px-4 py-3 bg-gray-50 rounded-lg text-base focus:outline-none focus:ring-2 focus:ring-primary/20"
              />
            </div>

            {/* 城市列表 - 可滚动 */}
            <div className="flex-1 flex overflow-hidden">
              <div 
                ref={scrollContainerRef}
                className="flex-1 overflow-y-auto p-4"
                style={{ WebkitOverflowScrolling: 'touch' }}
              >
                {/* 热门城市 */}
                {!searchText && filteredHotCities.length > 0 && (
                  <div className="mb-6">
                    <h4 className="text-base font-medium text-gray-500 mb-3">热门城市</h4>
                    <div className="grid grid-cols-4 gap-3">
                      {filteredHotCities.map((city) => (
                        <button
                          key={city.cityCode}
                          onClick={() => handleSelectCity(city)}
                          className={`px-3 py-3 text-base rounded-lg transition-colors whitespace-nowrap overflow-hidden text-ellipsis ${
                            selectedCity?.cityCode === city.cityCode
                              ? 'bg-primary text-white'
                              : 'bg-gray-50 text-gray-700 hover:bg-gray-100'
                          }`}
                          title={city.cityName}
                        >
                          {city.cityName}
                        </button>
                      ))}
                    </div>
                  </div>
                )}

                {/* 字母索引城市 */}
                {Object.entries(filteredGroupedCities).map(([letter, cities]) => (
                  <div key={letter} id={`city-group-${letter}`} className="mb-4">
                    <h4 className="text-base font-medium text-gray-400 mb-2 px-1">{letter}</h4>
                    <div className="space-y-1">
                      {cities.map((city) => (
                        <button
                          key={city.cityCode}
                          onClick={() => handleSelectCity(city)}
                          className={`w-full text-left px-4 py-3 text-base rounded-lg transition-colors ${
                            selectedCity?.cityCode === city.cityCode
                              ? 'bg-primary text-white'
                              : 'text-gray-700 hover:bg-gray-50'
                          }`}
                        >
                          {city.cityName}
                        </button>
                      ))}
                    </div>
                  </div>
                ))}
              </div>

              {/* 右侧字母索引导航 */}
              {!searchText && letterIndex.length > 0 && (
                <div className="w-8 flex-shrink-0 flex flex-col items-center justify-center py-4 bg-gray-50/50">
                  {letterIndex.map((letter) => (
                    <button
                      key={letter}
                      onClick={() => scrollToLetter(letter)}
                      className="w-6 h-6 flex items-center justify-center text-xs text-gray-400 hover:text-primary transition-colors"
                    >
                      {letter}
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
