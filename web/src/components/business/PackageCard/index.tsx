import type { PackageCard as PackageCardType } from '@/types';

interface PackageCardProps {
  data: PackageCardType;
  onActionClick?: (packageId: string) => void;
}

// 飞猪品牌色
const BRAND_COLOR = '#FFE033';
const INDIGO_COLOR = '#6666FF';

// 销量模糊化
function formatSalesCount(count: number): string {
  if (count < 100) return '';
  if (count < 1000) {
    const hundred = Math.floor(count / 100) * 100;
    return `热销${hundred}+`;
  }
  if (count < 10000) {
    const thousand = Math.floor(count / 1000) * 1000;
    return `热销${thousand}+`;
  }
  if (count < 100000) {
    const tenThousand = Math.floor(count / 10000);
    return `热销${tenThousand}万+`;
  }
  const hundredThousand = Math.floor(count / 10000);
  return `热销${hundredThousand}万+`;
}

export function PackageCard({ data, onActionClick }: PackageCardProps) {
  const salesText = formatSalesCount(data.salesCount);

  return (
    <div 
      className="bg-white overflow-hidden shadow-sm flex"
      style={{ 
        width: '100%', 
        height: 'auto',
        minHeight: '180px',
        borderRadius: '16px 16px 16px 16px'
      }}
    >
      {/* 左侧图片 - Figma 750÷2=375, 图片约占1/3 */}
      <div className="flex-shrink-0" style={{ width: '120px', height: '150px' }}>
        <img
          src={data.imageUrl}
          alt={data.hotelName}
          className="w-full h-full object-cover"
          style={{ borderRadius: '16px 0 0 16px' }}
        />
      </div>

      {/* 右侧内容区域 */}
      <div className="flex-1 p-3 flex flex-col justify-between">
        {/* 上部：酒店名称、套餐标题 */}
        <div>
          <h3 className="text-base font-semibold text-gray-900 truncate mb-1">
            {data.hotelName}
          </h3>
          <p className="text-sm text-gray-600 line-clamp-2 mb-2">
            {data.packageTitle}
          </p>
        </div>

        {/* 中部：评分、位置、标签 */}
        <div>
          {/* 评分与亮点 */}
          {data.score > 0 && (
            <div className="flex items-center gap-1 mb-1">
              <span className="text-xs font-medium" style={{ color: INDIGO_COLOR }}>
                {data.score.toFixed(1)}分
              </span>
              {data.highlightText && (
                <span 
                  className="text-xs px-2 py-0.5 rounded-full truncate max-w-[100px]"
                  style={{ backgroundColor: `${INDIGO_COLOR}15`, color: INDIGO_COLOR }}
                >
                  {data.highlightText}
                </span>
              )}
            </div>
          )}

          {/* 位置距离 */}
          <div className="flex items-center gap-1 text-xs text-gray-500 mb-1">
            <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            <span className="truncate">近{data.poiName} {data.distance}</span>
          </div>

          {/* 优势标签 - 只显示2个 */}
          {data.tags.length > 0 && (
            <div className="flex items-center gap-1 mb-1 overflow-hidden">
              {data.tags.slice(0, 2).map((tag, index) => (
                <span
                  key={index}
                  className="text-xs px-1.5 py-0.5 rounded border whitespace-nowrap"
                  style={{ borderColor: '#E5E5E5', color: '#666' }}
                >
                  {tag}
                </span>
              ))}
            </div>
          )}

          {/* 销量 */}
          {salesText && (
            <div className="text-xs text-gray-400">{salesText}</div>
          )}
        </div>

        {/* 底部：价格和按钮 */}
        <div className="flex items-center justify-between mt-2">
          <div className="flex items-baseline gap-0.5">
            <span className="text-xs text-gray-500">{data.pricePrefix}</span>
            <span className="text-sm text-gray-900">¥</span>
            <span className="text-xl font-bold text-gray-900">{data.price}</span>
            <span className="text-xs text-gray-500">{data.priceSuffix}</span>
          </div>

          <button
            onClick={() => onActionClick?.(data.packageId)}
            className="px-4 py-2 rounded-full text-sm font-medium"
            style={{ backgroundColor: BRAND_COLOR, color: '#202124' }}
          >
            立即抢
          </button>
        </div>
      </div>
    </div>
  );
}
