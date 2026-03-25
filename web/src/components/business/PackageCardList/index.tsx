import { useEffect, useRef } from 'react';
import { PackageCard } from '../PackageCard';
import type { PackageCard as PackageCardType } from '@/types';

interface PackageCardListProps {
  list: PackageCardType[];
  loading: boolean;
  hasMore: boolean;
  error: boolean;
  onLoadMore: () => void;
  onCardAction?: (packageId: string) => void;
}

export function PackageCardList({
  list,
  loading,
  hasMore,
  error,
  onLoadMore,
  onCardAction,
}: PackageCardListProps) {
  const observerRef = useRef<IntersectionObserver | null>(null);
  const loadMoreRef = useRef<HTMLDivElement>(null);

  // 无限滚动监听
  useEffect(() => {
    if (observerRef.current) {
      observerRef.current.disconnect();
    }

    observerRef.current = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && hasMore && !loading && !error) {
          onLoadMore();
        }
      },
      { threshold: 0.1, rootMargin: '200px' }
    );

    if (loadMoreRef.current) {
      observerRef.current.observe(loadMoreRef.current);
    }

    return () => {
      if (observerRef.current) {
        observerRef.current.disconnect();
      }
    };
  }, [hasMore, loading, error, onLoadMore]);

  if (list.length === 0 && !loading) {
    return (
      <div className="flex flex-col items-center justify-center py-12 text-gray-400">
        <svg className="w-16 h-16 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
        <p className="text-sm">暂无符合条件的酒店套餐</p>
      </div>
    );
  }

  return (
    <div className="px-4 py-4">
      {/* 单列布局 */}
      <div className="flex flex-col gap-3">
        {list.map((item) => (
          <PackageCard
            key={item.packageId}
            data={item}
            onActionClick={onCardAction}
          />
        ))}
      </div>

      {/* 加载更多触发器 */}
      <div ref={loadMoreRef} className="py-4">
        {loading && (
          <div className="flex items-center justify-center gap-2 text-gray-400">
            <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
            </svg>
            <span className="text-sm">加载中...</span>
          </div>
        )}

        {error && (
          <div className="flex flex-col items-center gap-2 text-gray-400">
            <p className="text-sm">加载失败</p>
            <button
              onClick={onLoadMore}
              className="px-4 py-2 text-sm rounded-lg"
              style={{ backgroundColor: '#FFE033', color: '#202124' }}
            >
              点击重试
            </button>
          </div>
        )}

        {!hasMore && list.length > 0 && !loading && (
          <div className="text-center text-sm text-gray-400 py-2">
            没有更多了
          </div>
        )}
      </div>
    </div>
  );
}
