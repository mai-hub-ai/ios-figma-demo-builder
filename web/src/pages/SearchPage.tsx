import { useEffect } from 'react'
import { useSearchStore } from '@/store/searchStore'
import { SearchArea } from '@/components/business/SearchArea'
import { RecommendSection } from '@/components/business/RecommendSection'

export function SearchPage() {
  const { 
    initPage, 
    loading, 
    error,
    // Module 3: 筛选状态
    sortType,
    starLevel,
    brandCode,
    brandList,
    // Module 3: 列表状态
    packageList,
    packageLoading,
    packageHasMore,
    packageError,
    // Module 3: Actions
    setSortType,
    setStarLevel,
    setBrandCode,
    loadMorePackages,
  } = useSearchStore()

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
    <div style={{ minHeight: "100vh", background: "linear-gradient(to bottom, #1A73E8 0%, #F2F3F5 33%, #F2F3F5 100%)" }}>
      {/* 状态栏占位 */}
      <div className="h-safe-top" />
      
      {/* 页面标题 */}
      <div className="px-4 pt-6 pb-4">
        <h1 className="text-2xl font-bold text-white">酒店搜索</h1>
        <p className="text-white/80 text-sm mt-1">发现精选好价，安心入住</p>
      </div>

      {/* Module 2: 搜索区域 */}
      <SearchArea className="mt-4" />

      {/* Module 3: 推荐区域 */}
      <div className="mt-2 rounded-t-2xl overflow-hidden">
        <RecommendSection
          sortType={sortType}
          starLevel={starLevel}
          brandCode={brandCode}
          brandList={brandList}
          packageList={packageList}
          loading={packageLoading}
          hasMore={packageHasMore}
          error={packageError}
          onSortChange={setSortType}
          onStarChange={setStarLevel}
          onBrandChange={setBrandCode}
          onLoadMore={loadMorePackages}
          onCardAction={(packageId) => {
            console.log('点击套餐:', packageId)
            // TODO: 跳转到套餐详情页
          }}
        />
      </div>

      {/* 底部安全区 */}
      <div className="h-safe-bottom" />
    </div>
  )
}
