import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { 
  City, 
  HotKeyword, 
  CalendarMonth, 
  SearchParams,
  SearchPageInitData,
  SortType,
  PackageCard,
  Brand,
  PackageListResponse
} from '@/types'
import { 
  fetchSearchPageInit, 
  fetchCalendar, 
  fetchCities,
  fetchBrands,
  fetchPackages
} from '@/services/searchApi'

interface SearchState {
  // === Module 2: 搜索条件 ===
  selectedCity: City | null;
  keyword: string;
  checkInDate: string;
  checkOutDate: string;
  nightCount: number;
  roomCount: number;
  adultCount: number;
  childCount: number;

  // === Module 3: 筛选状态 ===
  sortType: SortType;
  starLevel: number | null;
  brandCode: string | null;

  // === Module 3: 列表状态 ===
  packageList: PackageCard[];
  packagePage: number;
  packagePageSize: number;
  packageTotal: number;
  packageHasMore: boolean;
  packageLoading: boolean;
  packageError: boolean;

  // === UI 状态 ===
  isCitySelectorOpen: boolean;
  isCalendarOpen: boolean;
  isGuestPickerOpen: boolean;
  loading: boolean;
  error: string | null;

  // === 服务端数据 ===
  cityList: City[];
  hotCities: City[];
  hotKeywords: HotKeyword[];
  calendarData: CalendarMonth[];
  sloganImageUrl: string;
  sloganAlt: string;
  brandList: Brand[];

  // === Actions: Module 2 ===
  initPage: () => Promise<void>;
  setSelectedCity: (city: City) => void;
  setKeyword: (keyword: string) => void;
  setDateRange: (checkIn: string, checkOut: string) => void;
  setGuestInfo: (rooms: number, adults: number, children: number) => void;
  openCitySelector: () => Promise<void>;
  closeCitySelector: () => void;
  openCalendar: () => Promise<void>;
  closeCalendar: () => void;
  openGuestPicker: () => void;
  closeGuestPicker: () => void;

  // === Actions: Module 3 ===
  setSortType: (sortType: SortType) => void;
  setStarLevel: (starLevel: number | null) => void;
  setBrandCode: (brandCode: string | null) => void;
  loadBrands: () => Promise<void>;
  loadPackages: (isReset?: boolean) => Promise<void>;
  loadMorePackages: () => Promise<void>;
  resetFilters: () => void;

  getSearchParams: () => SearchParams;
  resetSearch: () => void;
}

// 默认日期：今天和明天
const getDefaultDates = () => {
  const today = new Date()
  const tomorrow = new Date(today)
  tomorrow.setDate(tomorrow.getDate() + 1)
  
  const formatDate = (d: Date) => d.toISOString().split('T')[0]
  
  return {
    checkIn: formatDate(today),
    checkOut: formatDate(tomorrow),
  }
}

export const useSearchStore = create<SearchState>()(
  persist(
    (set, get) => ({
      // === 初始状态 ===
      selectedCity: null,
      keyword: '',
      checkInDate: getDefaultDates().checkIn,
      checkOutDate: getDefaultDates().checkOut,
      nightCount: 1,
      roomCount: 1,
      adultCount: 2,
      childCount: 0,

      // Module 3: 筛选状态
      sortType: 'sales_desc',
      starLevel: null,
      brandCode: null,

      // Module 3: 列表状态
      packageList: [],
      packagePage: 1,
      packagePageSize: 10,
      packageTotal: 0,
      packageHasMore: true,
      packageLoading: false,
      packageError: false,

      isCitySelectorOpen: false,
      isCalendarOpen: false,
      isGuestPickerOpen: false,
      loading: false,
      error: null,

      cityList: [],
      hotCities: [],
      hotKeywords: [],
      calendarData: [],
      sloganImageUrl: '',
      sloganAlt: '',
      brandList: [],

      // === Actions: Module 2 ===
      initPage: async () => {
        set({ loading: true, error: null })
        try {
          const cityCode = get().selectedCity?.cityCode || 'SHA'
          const res = await fetchSearchPageInit(cityCode)
          const data: SearchPageInitData = res.data
          
          set({
            cityList: data.hotCities,
            hotCities: data.hotCities,
            hotKeywords: data.hotKeywords,
            sloganImageUrl: data.sloganImageUrl,
            sloganAlt: data.sloganAlt,
            selectedCity: data.currentCity,
            checkInDate: data.defaultCheckIn,
            checkOutDate: data.defaultCheckOut,
            loading: false,
          })

          // 加载品牌列表和首屏商品
          await get().loadBrands()
          await get().loadPackages(true)
        } catch {
          set({ error: '加载失败，请重试', loading: false })
        }
      },

      setSelectedCity: (city) => set({ selectedCity: city }),
      setKeyword: (keyword) => set({ keyword }),
      
      setDateRange: (checkIn, checkOut) => {
        const checkInDate = new Date(checkIn)
        const checkOutDate = new Date(checkOut)
        const nightCount = Math.round((checkOutDate.getTime() - checkInDate.getTime()) / (1000 * 60 * 60 * 24))
        set({ checkInDate: checkIn, checkOutDate: checkOut, nightCount })
      },
      
      setGuestInfo: (rooms, adults, children) => set({
        roomCount: rooms,
        adultCount: adults,
        childCount: children,
      }),

      openCitySelector: async () => {
        set({ isCitySelectorOpen: true, loading: true })
        try {
          const res = await fetchCities()
          set({ 
            cityList: res.data.cities,
            hotCities: res.data.hotCities,
            loading: false 
          })
        } catch {
          set({ loading: false })
        }
      },
      closeCitySelector: () => set({ isCitySelectorOpen: false }),
      
      openCalendar: async () => {
        set({ isCalendarOpen: true, loading: true })
        try {
          const cityCode = get().selectedCity?.cityCode || 'SHA'
          const res = await fetchCalendar(cityCode, 3)
          set({ calendarData: res.data.months, loading: false })
        } catch {
          set({ loading: false })
        }
      },
      closeCalendar: () => set({ isCalendarOpen: false }),
      
      openGuestPicker: () => set({ isGuestPickerOpen: true }),
      closeGuestPicker: () => set({ isGuestPickerOpen: false }),

      // === Actions: Module 3 ===
      setSortType: (sortType) => {
        set({ sortType })
        get().loadPackages(true)
      },

      setStarLevel: (starLevel) => {
        set({ starLevel })
        get().loadPackages(true)
      },

      setBrandCode: (brandCode) => {
        set({ brandCode })
        get().loadPackages(true)
      },

      loadBrands: async () => {
        try {
          const cityCode = get().selectedCity?.cityCode || 'SHA'
          const res = await fetchBrands(cityCode)
          set({ brandList: res.data.brands })
        } catch {
          // 静默失败，使用空列表
        }
      },

      loadPackages: async (isReset = false) => {
        const state = get()
        if (state.packageLoading) return

        set({ 
          packageLoading: true, 
          packageError: false,
          ...(isReset ? { packagePage: 1, packageList: [] } : {})
        })

        try {
          const page = isReset ? 1 : state.packagePage
          const res = await fetchPackages({
            cityCode: state.selectedCity?.cityCode || 'SHA',
            checkInDate: state.checkInDate,
            checkOutDate: state.checkOutDate,
            roomCount: state.roomCount,
            adultCount: state.adultCount,
            childCount: state.childCount,
            keyword: state.keyword,
            sortType: state.sortType,
            starLevel: state.starLevel,
            brandCode: state.brandCode,
            page,
            pageSize: state.packagePageSize,
          })

          const data: PackageListResponse = res.data

          set({
            packageList: isReset ? data.list : [...state.packageList, ...data.list],
            packagePage: page + 1,
            packageTotal: data.total,
            packageHasMore: data.hasMore,
            packageLoading: false,
          })
        } catch {
          set({ packageError: true, packageLoading: false })
        }
      },

      loadMorePackages: async () => {
        const state = get()
        if (!state.packageHasMore || state.packageLoading || state.packageError) return
        await get().loadPackages(false)
      },

      resetFilters: () => {
        set({
          sortType: 'sales_desc',
          starLevel: null,
          brandCode: null,
        })
        get().loadPackages(true)
      },

      getSearchParams: (): SearchParams => {
        const state = get()
        return {
          cityCode: state.selectedCity?.cityCode || '',
          cityName: state.selectedCity?.cityName || '',
          keyword: state.keyword,
          checkInDate: state.checkInDate,
          checkOutDate: state.checkOutDate,
          nightCount: state.nightCount,
          roomCount: state.roomCount,
          adultCount: state.adultCount,
          childCount: state.childCount,
        }
      },

      resetSearch: () => {
        const defaults = getDefaultDates()
        set({
          keyword: '',
          checkInDate: defaults.checkIn,
          checkOutDate: defaults.checkOut,
          nightCount: 1,
          roomCount: 1,
          adultCount: 2,
          childCount: 0,
          sortType: 'sales_desc',
          starLevel: null,
          brandCode: null,
          packageList: [],
          packagePage: 1,
          packageHasMore: true,
        })
      },
    }),
    {
      name: 'search-storage',
      partialize: (state) => ({
        selectedCity: state.selectedCity,
        roomCount: state.roomCount,
        adultCount: state.adultCount,
        childCount: state.childCount,
      }),
    }
  )
)
