import type { PackageCard as PackageCardType } from '@/types';

interface PackageCardProps {
  data: PackageCardType;
  onActionClick?: (packageId: string) => void;
}

const INDIGO_COLOR = '#6666FF';
const PAY_COLOR = '#FF5533'; // --color_pay_1
const HOTEL_NAME_COLOR = '#805540';

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
        borderRadius: '16px 16px 0px 0px',
      }}
    >
      {/* 左侧图片 - 四周12px外边距，圆角12px */}
      <div className="flex-shrink-0" style={{ padding: '12px 0 12px 12px', width: '132px', boxSizing: 'border-box' }}>
        <img
          src={data.imageUrl}
          alt={data.hotelName}
          className="w-full object-cover"
          style={{ borderRadius: '12px', display: 'block', height: '100%', minHeight: '108px' }}
        />
      </div>

      {/* 右侧内容区域 */}
      <div className="flex-1 flex flex-col justify-between min-w-0" style={{ padding: '12px 12px 12px 18px' }}>
        {/* 上部：酒店名称 + 套餐标题同行 */}
        <div>
          <p className="line-clamp-2 mb-2" style={{ fontSize: '15px', fontFamily: 'PingFang SC, sans-serif', lineHeight: '1.4em', margin: '0 0 8px 0' }}>
            <span style={{ fontWeight: 500, color: HOTEL_NAME_COLOR }}>{data.hotelName}</span>
            <span style={{ fontWeight: 500, color: '#0F131A' }}> {data.packageTitle}</span>
          </p>
        </div>

        {/* 中部：评分、位置、标签 */}
        <div>
          {/* 评分色块 + 亮点文字 */}
          {data.score > 0 && (
            <div className="flex items-center mb-1 min-w-0" style={{ gap: '8px' }}>
              <span
                className="flex-shrink-0 flex items-center justify-center text-white"
                style={{
                  backgroundColor: INDIGO_COLOR,
                  borderRadius: '4px',
                  padding: '1px 4px',
                  fontSize: '13px',
                  fontFamily: 'Alibaba Sans 102, PingFang SC, sans-serif',
                  fontWeight: 700,
                  lineHeight: '1em',
                }}
              >
                {data.score.toFixed(1)}
              </span>
              {data.highlightText && (
                <span
                  className="truncate"
                  style={{
                    color: INDIGO_COLOR,
                    fontSize: '12px',
                    fontFamily: 'PingFang SC, sans-serif',
                    lineHeight: '1.4em',
                    maxWidth: 'calc(100% - 40px)',
                  }}
                >
                  {data.highlightText}
                </span>
              )}
            </div>
          )}

          {/* 位置距离 */}
          <div className="flex items-center mb-1" style={{ gap: '5px' }}>
            <svg className="flex-shrink-0" width="12" height="12" fill="none" stroke="#5C5F66" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            <span className="truncate" style={{ fontSize: '12px', fontFamily: 'PingFang SC, sans-serif', color: '#5C5F66', lineHeight: '1.4em' }}>
              近{data.poiName} {data.distance}
            </span>
          </div>

          {/* 优势标签 */}
          {data.tags.length > 0 && (
            <div className="flex items-center mb-1 overflow-hidden" style={{ gap: '6px' }}>
              {data.tags.slice(0, 2).map((tag, index) => (
                <span
                  key={index}
                  className="whitespace-nowrap"
                  style={{
                    border: '1px solid rgba(92, 95, 102, 0.5)',
                    borderRadius: '4px',
                    padding: '1px 5px',
                    fontSize: '10px',
                    fontFamily: 'PingFang SC, sans-serif',
                    color: '#5C5F66',
                    lineHeight: '1.4em',
                  }}
                >
                  {tag}
                </span>
              ))}
            </div>
          )}

          {/* 销量 */}
          {salesText && (
            <div style={{ fontSize: '12px', color: '#999', fontFamily: 'PingFang SC, sans-serif' }}>{salesText}</div>
          )}
        </div>

        {/* 底部：价格和按钮 */}
        <div className="flex items-center justify-between" style={{ marginTop: '6px' }}>
          <div className="flex items-baseline" style={{ gap: '2px' }}>
            <span style={{ color: PAY_COLOR, fontSize: '10px', fontFamily: 'PingFang SC, sans-serif', lineHeight: '1em' }}>{data.pricePrefix}</span>
            <span style={{ color: PAY_COLOR, fontSize: '12px', fontFamily: 'Alibaba Sans 102, PingFang SC, sans-serif', fontWeight: 700, lineHeight: '1em' }}>¥</span>
            <span style={{ color: PAY_COLOR, fontSize: '21px', fontFamily: 'Fliggy Sans 102, PingFang SC, sans-serif', fontWeight: 400, lineHeight: '0.64em' }}>{data.price}</span>
            <span style={{ color: PAY_COLOR, fontSize: '10px', fontFamily: 'PingFang SC, sans-serif', lineHeight: '1em' }}>{data.priceSuffix}</span>
          </div>

          <button
            onClick={() => onActionClick?.(data.packageId)}
            className="text-white"
            style={{
              backgroundColor: PAY_COLOR,
              borderRadius: '21px',
              padding: '5px 16px',
              fontSize: '12px',
              fontFamily: 'PingFang SC, sans-serif',
              fontWeight: 500,
              lineHeight: '1.4em',
              border: 'none',
              cursor: 'pointer',
            }}
          >
            立即抢
          </button>
        </div>
      </div>
    </div>
  );
}
