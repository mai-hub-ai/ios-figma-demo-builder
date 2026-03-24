import axios from 'axios'
import type { ApiResponse, SearchPageInitData, CalendarMonth } from '@/types'

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

// 重新导出类型
import type { City, HotKeyword } from '@/types'
