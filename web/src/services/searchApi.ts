import axios from 'axios'
import type { 
  ApiResponse, 
  SearchPageInitData, 
  CalendarMonth, 
  Brand, 
  PackageListResponse,
  SortType
} from '@/types'

const api = axios.create({
  baseURL: '/api',
  timeout: 10000,
  headers: { 'Content-Type': 'application/json' },
})

// 响应拦截器
api.interceptors.response.use(
  (response) => response.data,
  (error) => Promise.reject(error),
)

/** 获取搜索页初始化数据 */
export function fetchSearchPageInit(cityCode: string) {
  return api.get<never, ApiResponse<SearchPageInitData>>('/search-page/init', {
    params: { cityCode },
  })
}

/** 获取城市列表 */
export function fetchCities() {
  return api.get<never, ApiResponse<{ cities: City[]; hotCities: City[] }>>('/cities')
}

/** 获取日历数据 */
export function fetchCalendar(cityCode: string, months: number = 3) {
  return api.get<never, ApiResponse<{ months: CalendarMonth[] }>>('/calendar', {
    params: { cityCode, months },
  })
}

/** 获取热搜词 */
export function fetchHotKeywords(cityCode: string) {
  return api.get<never, ApiResponse<{ keywords: HotKeyword[] }>>('/hot-keywords', {
    params: { cityCode },
  })
}

/** 获取页面配置 */
export function fetchPageConfig() {
  return api.get<never, ApiResponse<{ sloganImageUrl: string; sloganAlt: string }>>('/search-page/config')
}

/** 获取品牌列表 */
export function fetchBrands(cityCode: string) {
  return api.get<never, ApiResponse<{ brands: Brand[] }>>('/brands', {
    params: { cityCode },
  })
}

/** 获取套餐列表 */
export interface FetchPackagesParams {
  cityCode: string;
  checkInDate: string;
  checkOutDate: string;
  roomCount: number;
  adultCount: number;
  childCount: number;
  keyword?: string;
  sortType?: SortType;
  starLevel?: number | null;
  brandCode?: string | null;
  page?: number;
  pageSize?: number;
}

export function fetchPackages(params: FetchPackagesParams) {
  return api.get<never, ApiResponse<PackageListResponse>>('/packages', {
    params: {
      ...params,
      starLevel: params.starLevel ?? undefined,
      brandCode: params.brandCode ?? undefined,
    },
  })
}

// 重新导出类型
import type { City, HotKeyword } from '@/types'
