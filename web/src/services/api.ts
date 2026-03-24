import axios from 'axios'
import type {
  ApiResponse,
  PaginatedData,
  HotelPackage,
  PackageFilterParams,
  DateAvailability,
  Order,
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

/** 获取套餐列表 */
export function fetchPackages(params: PackageFilterParams) {
  return api.get<never, ApiResponse<PaginatedData<HotelPackage>>>('/packages', { params })
}

/** 获取套餐详情 */
export function fetchPackageDetail(id: string) {
  return api.get<never, ApiResponse<HotelPackage>>(`/packages/${id}`)
}

/** 获取日期可用性 */
export function fetchDateAvailability(packageId: string, month: string) {
  return api.get<never, ApiResponse<DateAvailability[]>>(
    `/packages/${packageId}/availability`,
    { params: { month } },
  )
}

/** 创建订单 */
export function createOrder(data: {
  packageId: string
  checkInDate: string
  checkOutDate: string
  adultCount: number
  childCount: number
  guestName: string
  guestPhone: string
  guestIdType: string
  guestIdNumber: string
  remark?: string
}) {
  return api.post<never, ApiResponse<Order>>('/orders', data)
}

/** 获取订单详情 */
export function fetchOrderDetail(orderId: string) {
  return api.get<never, ApiResponse<Order>>(`/orders/${orderId}`)
}
