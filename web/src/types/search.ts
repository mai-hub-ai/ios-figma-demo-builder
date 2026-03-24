/** 城市信息 */
export interface City {
  cityCode: string;
  cityName: string;
  pinyin?: string;
  firstLetter?: string;
}

/** 热搜词 */
export interface HotKeyword {
  id: number;
  text: string;
  type: 'location' | 'brand' | 'hotel';
}

/** 日历日期数据 */
export interface CalendarDay {
  date: string; // YYYY-MM-DD
  price: number;
  available: boolean;
  label: string; // 如 "今天"、"明天"、节假日名称
  isHoliday: boolean;
  holidayName: string;
}

/** 日历月份数据 */
export interface CalendarMonth {
  year: number;
  month: number;
  days: CalendarDay[];
}

/** 搜索参数 */
export interface SearchParams {
  // 城市
  cityCode: string;
  cityName: string;

  // 搜索词
  keyword: string;

  // 日期
  checkInDate: string; // YYYY-MM-DD
  checkOutDate: string; // YYYY-MM-DD
  nightCount: number;

  // 人数
  roomCount: number;
  adultCount: number;
  childCount: number;

  // 价格/星级（预留字段）
  priceMin?: number;
  priceMax?: number;
  starLevel?: number[];
}

/** 页面初始化响应 */
export interface SearchPageInitData {
  currentCity: City;
  hotCities: City[];
  hotKeywords: HotKeyword[];
  sloganImageUrl: string;
  sloganAlt: string;
  defaultCheckIn: string;
  defaultCheckOut: string;
}

/** 价格/星级筛选值（预留） */
export interface PriceStarFilter {
  priceRange: [number, number] | null;
  starLevels: number[];
}
