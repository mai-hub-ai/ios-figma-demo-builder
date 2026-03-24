import { useEffect } from 'react'
import { useSearchStore } from '@/store/searchStore'
import { SearchArea } from '@/components/business/SearchArea'
import { SloganBanner } from '@/components/business/SloganBanner'

export function SearchPage() {
  const { initPage, loading, error } = useSearchStore()

  useEffect(() => {
    initPage()
  }, [initPage])

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-gray-500">加载中...</div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-red-500">{error}</div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#1A73E8] to-[#4285F4]">
      {/* 状态栏占位 */}
      <div className="h-safe-top" />
      
      {/* 页面标题 */}
      <div className="px-4 pt-6 pb-4">
        <h1 className="text-2xl font-bold text-white">酒店搜索</h1>
        <p className="text-white/80 text-sm mt-1">发现精选好价，安心入住</p>
      </div>

      {/* 搜索区域 */}
      <SearchArea className="mt-4" />

      {/* Slogan区 */}
      <SloganBanner className="mt-4" />

      {/* 底部安全区 */}
      <div className="h-safe-bottom" />
    </div>
  )
}
