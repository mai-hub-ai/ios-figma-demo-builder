import { create } from 'zustand'
import type { HotelPackage, DateAvailability, Order } from '@/types'
import {
  fetchPackages,
  fetchPackageDetail,
  fetchDateAvailability,
  createOrder,
} from '@/services/api'

interface PackageListState {
  packages: HotelPackage[]
  total: number
  page: number
  loading: boolean
  error: string | null

  loadPackages: (page?: number, keyword?: string) => Promise<void>
  resetList: () => void
}

export const usePackageListStore = create<PackageListState>((set, get) => ({
  packages: [],
  total: 0,
  page: 1,
  loading: false,
  error: null,

  loadPackages: async (page = 1, keyword) => {
    set({ loading: true, error: null })
    try {
      const res = await fetchPackages({ page, pageSize: 10, keyword })
      const prev = page === 1 ? [] : get().packages
      set({
        packages: [...prev, ...res.data.list],
        total: res.data.total,
        page,
        loading: false,
      })
    } catch {
      set({ error: '加载失败，请重试', loading: false })
    }
  },

  resetList: () => set({ packages: [], total: 0, page: 1, error: null }),
}))

interface PackageDetailState {
  currentPackage: HotelPackage | null
  availability: DateAvailability[]
  loading: boolean

  loadDetail: (id: string) => Promise<void>
  loadAvailability: (packageId: string, month: string) => Promise<void>
}

export const usePackageDetailStore = create<PackageDetailState>((set) => ({
  currentPackage: null,
  availability: [],
  loading: false,

  loadDetail: async (id: string) => {
    set({ loading: true })
    try {
      const res = await fetchPackageDetail(id)
      set({ currentPackage: res.data, loading: false })
    } catch {
      set({ loading: false })
    }
  },

  loadAvailability: async (packageId: string, month: string) => {
    try {
      const res = await fetchDateAvailability(packageId, month)
      set({ availability: res.data })
    } catch {
      // silently fail
    }
  },
}))

interface OrderState {
  currentOrder: Order | null
  submitting: boolean

  submitOrder: (data: Parameters<typeof createOrder>[0]) => Promise<Order | null>
  setCurrentOrder: (order: Order | null) => void
}

export const useOrderStore = create<OrderState>((set) => ({
  currentOrder: null,
  submitting: false,

  submitOrder: async (data) => {
    set({ submitting: true })
    try {
      const res = await createOrder(data)
      set({ currentOrder: res.data, submitting: false })
      return res.data
    } catch {
      set({ submitting: false })
      return null
    }
  },

  setCurrentOrder: (order) => set({ currentOrder: order }),
}))
