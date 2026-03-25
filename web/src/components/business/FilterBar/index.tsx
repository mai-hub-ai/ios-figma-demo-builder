import { useState, useRef, useEffect } from 'react';
import type { SortType, SortOption, StarOption, Brand } from '@/types';

interface FilterBarProps {
  sortType: SortType;
  starLevel: number | null;
  brandCode: string | null;
  brandList: Brand[];
  onSortChange: (sortType: SortType) => void;
  onStarChange: (starLevel: number | null) => void;
  onBrandChange: (brandCode: string | null) => void;
}

// 排序选项配置
const SORT_OPTIONS: SortOption[] = [
  { value: 'sales_desc', label: '销量从高到低' },
  { value: 'sales_asc', label: '销量从低到高' },
  { value: 'price_asc', label: '价格从低到高' },
  { value: 'price_desc', label: '价格从高到低' },
];

// 星级选项配置
const STAR_OPTIONS: StarOption[] = [
  { value: 2, label: '二星/经济' },
  { value: 3, label: '三星/舒适' },
  { value: 4, label: '四星/高档' },
  { value: 5, label: '五星/豪华' },
];

// 飞猪品牌色
const BRAND_COLOR = '#FF9500'; // 橙色

export function FilterBar({
  sortType,
  starLevel,
  brandCode,
  brandList,
  onSortChange,
  onStarChange,
  onBrandChange,
}: FilterBarProps) {
  const [openDropdown, setOpenDropdown] = useState<'sort' | 'star' | 'brand' | null>(null);
  
  const sortRef = useRef<HTMLDivElement>(null);
  const starRef = useRef<HTMLDivElement>(null);
  const brandRef = useRef<HTMLDivElement>(null);

  // 点击外部关闭下拉
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as Node;
      if (
        sortRef.current && !sortRef.current.contains(target) &&
        starRef.current && !starRef.current.contains(target) &&
        brandRef.current && !brandRef.current.contains(target)
      ) {
        setOpenDropdown(null);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // 获取当前选中的排序标签
  const getSortLabel = () => {
    const option = SORT_OPTIONS.find(o => o.value === sortType);
    return option?.label || '销量排序';
  };

  // 获取当前选中的星级标签
  const getStarLabel = () => {
    if (!starLevel) return '酒店星级';
    const option = STAR_OPTIONS.find(o => o.value === starLevel);
    return option?.label || '酒店星级';
  };

  // 获取当前选中的品牌标签
  const getBrandLabel = () => {
    if (!brandCode) return '酒店品牌';
    const brand = brandList.find(b => b.brandCode === brandCode);
    return brand?.brandName || '酒店品牌';
  };

  // 处理排序选择
  const handleSortSelect = (value: SortType) => {
    onSortChange(value);
    setOpenDropdown(null);
  };

  // 处理星级选择
  const handleStarSelect = (value: number | null) => {
    onStarChange(value);
    setOpenDropdown(null);
  };

  // 处理品牌选择
  const handleBrandSelect = (value: string | null) => {
    onBrandChange(value);
    setOpenDropdown(null);
  };

  // 判断筛选项是否激活
  const isSortActive = sortType !== 'sales_desc';
  const isStarActive = !!starLevel;
  const isBrandActive = !!brandCode;

  return (
    <div className="flex items-center justify-between px-4 py-3 bg-white border-b border-gray-100 sticky top-0 z-10">
      {/* 销量排序 */}
      <div ref={sortRef} className="relative flex-1 flex justify-center">
        <button
          onClick={() => setOpenDropdown(openDropdown === 'sort' ? null : 'sort')}
          className="flex items-center gap-1 text-sm font-medium whitespace-nowrap"
          style={{ color: isSortActive ? BRAND_COLOR : '#666' }}
        >
          <span className="truncate max-w-[100px]">{getSortLabel()}</span>
          <svg 
            className="w-4 h-4 transition-transform flex-shrink-0" 
            style={{ transform: openDropdown === 'sort' ? 'rotate(180deg)' : 'rotate(0deg)' }}
            fill="none" 
            stroke="currentColor" 
            viewBox="0 0 24 24"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </button>
        
        {openDropdown === 'sort' && (
          <div className="absolute top-full left-1/2 -translate-x-1/2 mt-1 bg-white rounded-lg shadow-lg border border-gray-100 py-2 min-w-[140px]">
            {SORT_OPTIONS.map((option) => (
              <button
                key={option.value}
                onClick={() => handleSortSelect(option.value)}
                className="w-full px-4 py-2 text-left text-sm hover:bg-gray-50"
                style={{ color: sortType === option.value ? BRAND_COLOR : '#333' }}
              >
                {option.label}
              </button>
            ))}
          </div>
        )}
      </div>

      {/* 酒店星级 */}
      <div ref={starRef} className="relative flex-1 flex justify-center">
        <button
          onClick={() => setOpenDropdown(openDropdown === 'star' ? null : 'star')}
          className="flex items-center gap-1 text-sm font-medium whitespace-nowrap"
          style={{ color: isStarActive ? BRAND_COLOR : '#666' }}
        >
          <span className="truncate max-w-[100px]">{getStarLabel()}</span>
          <svg 
            className="w-4 h-4 transition-transform flex-shrink-0" 
            style={{ transform: openDropdown === 'star' ? 'rotate(180deg)' : 'rotate(0deg)' }}
            fill="none" 
            stroke="currentColor" 
            viewBox="0 0 24 24"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </button>
        
        {openDropdown === 'star' && (
          <div className="absolute top-full left-1/2 -translate-x-1/2 mt-1 bg-white rounded-lg shadow-lg border border-gray-100 py-2 min-w-[120px]">
            {starLevel && (
              <button
                onClick={() => handleStarSelect(null)}
                className="w-full px-4 py-2 text-left text-sm text-gray-500 hover:bg-gray-50 border-b border-gray-100"
              >
                取消筛选
              </button>
            )}
            {STAR_OPTIONS.map((option) => (
              <button
                key={option.value}
                onClick={() => handleStarSelect(option.value)}
                className="w-full px-4 py-2 text-left text-sm hover:bg-gray-50"
                style={{ color: starLevel === option.value ? BRAND_COLOR : '#333' }}
              >
                {option.label}
              </button>
            ))}
          </div>
        )}
      </div>

      {/* 酒店品牌 */}
      <div ref={brandRef} className="relative flex-1 flex justify-center">
        <button
          onClick={() => setOpenDropdown(openDropdown === 'brand' ? null : 'brand')}
          className="flex items-center gap-1 text-sm font-medium whitespace-nowrap"
          style={{ color: isBrandActive ? BRAND_COLOR : '#666' }}
        >
          <span className="truncate max-w-[100px]">{getBrandLabel()}</span>
          <svg 
            className="w-4 h-4 transition-transform flex-shrink-0" 
            style={{ transform: openDropdown === 'brand' ? 'rotate(180deg)' : 'rotate(0deg)' }}
            fill="none" 
            stroke="currentColor" 
            viewBox="0 0 24 24"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </button>
        
        {openDropdown === 'brand' && (
          <div className="absolute top-full left-1/2 -translate-x-1/2 mt-1 bg-white rounded-lg shadow-lg border border-gray-100 py-2 min-w-[120px] max-h-[300px] overflow-y-auto">
            {brandCode && (
              <button
                onClick={() => handleBrandSelect(null)}
                className="w-full px-4 py-2 text-left text-sm text-gray-500 hover:bg-gray-50 border-b border-gray-100"
              >
                取消筛选
              </button>
            )}
            {brandList.map((brand) => (
              <button
                key={brand.brandCode}
                onClick={() => handleBrandSelect(brand.brandCode)}
                className="w-full px-4 py-2 text-left text-sm hover:bg-gray-50"
                style={{ color: brandCode === brand.brandCode ? BRAND_COLOR : '#333' }}
              >
                {brand.brandName}
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
