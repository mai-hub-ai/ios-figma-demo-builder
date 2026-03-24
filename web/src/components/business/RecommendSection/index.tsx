import { FilterBar } from '../FilterBar';
import { PackageCardList } from '../PackageCardList';
import type { SortType, PackageCard, Brand } from '@/types';

interface RecommendSectionProps {
  // 筛选状态
  sortType: SortType;
  starLevel: number | null;
  brandCode: string | null;
  brandList: Brand[];
  
  // 列表状态
  packageList: PackageCard[];
  loading: boolean;
  hasMore: boolean;
  error: boolean;
  
  // 回调
  onSortChange: (sortType: SortType) => void;
  onStarChange: (starLevel: number | null) => void;
  onBrandChange: (brandCode: string | null) => void;
  onLoadMore: () => void;
  onCardAction?: (packageId: string) => void;
}

export function RecommendSection({
  sortType,
  starLevel,
  brandCode,
  brandList,
  packageList,
  loading,
  hasMore,
  error,
  onSortChange,
  onStarChange,
  onBrandChange,
  onLoadMore,
  onCardAction,
}: RecommendSectionProps) {
  return (
    <div className="bg-gray-50 min-h-[400px]">
      {/* 筛选横条 */}
      <FilterBar
        sortType={sortType}
        starLevel={starLevel}
        brandCode={brandCode}
        brandList={brandList}
        onSortChange={onSortChange}
        onStarChange={onStarChange}
        onBrandChange={onBrandChange}
      />

      {/* 商品卡列表 */}
      <PackageCardList
        list={packageList}
        loading={loading}
        hasMore={hasMore}
        error={error}
        onLoadMore={onLoadMore}
        onCardAction={onCardAction}
      />
    </div>
  );
}
