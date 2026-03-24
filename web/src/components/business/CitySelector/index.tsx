import { useState } from 'react'
import { useSearchStore } from '@/store/searchStore'
import type { City } from '@/types'

interface CitySelectorProps {
  className?: string
}

export function CitySelector({ className = '' }: CitySelectorProps) {
  const { selectedCity, hotCities, isCitySelectorOpen, openCitySelector, closeCitySelector, setSelectedCity } = useSearchStore()
  const [searchText, setSearchText] = useState('')

  const filteredCities = hotCities.filter(city => 
    city.cityName.includes(searchText) || 
    city.pinyin?.toLowerCase().includes(searchText.toLowerCase()) ||
    city.firstLetter?.toLowerCase().includes(searchText.toLowerCase())
  )

  const handleSelectCity = (city: City) => {
    setSelectedCity(city)
    closeCitySelector()
  }

  return (
    <div className={`relative ${className}`}>
      {/* 城市选择器触发器 */}
      <button
        onClick={openCitySelector}
        className="flex items-center gap-1 px-3 py-2 bg-white rounded-lg border border-gray-200"
      >
        <svg className="w-4 h-4 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
        <span className="text-base font-medium text-gray-900">
          {selectedCity?.cityName || '选择城市'}
        </span>
        <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {/* 城市选择浮层 */}
      {isCitySelectorOpen && (
        <div className="fixed inset-0 z-50 bg-black/50" onClick={closeCitySelector}>
          <div 
            className="absolute bottom-0 left-0 right-0 bg-white rounded-t-2xl max-h-[70vh] overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            {/* 标题栏 */}
            <div className="flex items-center justify-between p-4 border-b border-gray-100">
              <h3 className="text-lg font-semibold text-gray-900">选择城市</h3>
              <button onClick={closeCitySelector} className="p-1">
                <svg className="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            {/* 搜索框 */}
            <div className="p-3 border-b border-gray-100">
              <input
                type="text"
                value={searchText}
                onChange={(e) => setSearchText(e.target.value)}
                placeholder="搜索城市"
                className="w-full px-4 py-2 bg-gray-50 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20"
              />
            </div>

            {/* 热门城市 */}
            <div className="p-4">
              <h4 className="text-sm font-medium text-gray-500 mb-3">热门城市</h4>
              <div className="grid grid-cols-4 gap-2">
                {filteredCities.map((city) => (
                  <button
                    key={city.cityCode}
                    onClick={() => handleSelectCity(city)}
                    className={`px-3 py-2 text-sm rounded-lg transition-colors ${
                      selectedCity?.cityCode === city.cityCode
                        ? 'bg-primary text-white'
                        : 'bg-gray-50 text-gray-700 hover:bg-gray-100'
                    }`}
                  >
                    {city.cityName}
                  </button>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
