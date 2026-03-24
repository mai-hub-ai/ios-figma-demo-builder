import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { 
  City, 
  HotKeyword, 
  CalendarMonth, 
  SearchParams,
  SearchPageInitData 
} from '@/types'
import { fetchSearchPageInit, fetchCalendar } from '@/services/searchApi'

interface SearchState {
  // === 搜索条件 ===
  selectedCity: City | null;
  keyword: string;
  checkInDate: string;
  checkOutDate: string;
  nightCount: number;
  roomCount: number;
  adultCount: number;
  childCount: number;

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

  // === Actions ===
  initPage: () => Promise<void>;
  setSelectedCity: (city: City) => void;
  setKeyword: (keyword: string) => void;
  setDateRange: (checkIn: string, checkOut: string) => void;
  setGuestInfo: (rooms: number, adults: number, children: number) => void;
  
  openCitySelector: () => void;
  closeCitySelector: () => void;
  openCalendar: () => Promise<void>;
  closeCalendar: () => void;
  openGuestPicker: () => void;
  closeGuestPicker: () => void;

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

      // === Actions ===
      initPage: async () => {
        set({ loading: true, error: null })
        try {
          const cityCode = get().selectedCity?.cityCode || 'SHA'
          const res = await fetchSearchPageInit(cityCode)
          const data: SearchPageInitData = res.data
          
          set({
            cityList: data.hotCities, // 简化：使用热门城市作为可选列表
            hotCities: data.hotCities,
            hotKeywords: data.hotKeywords,
            sloganImageUrl: data.sloganImageUrl,
            sloganAlt: data.sloganAlt,
            selectedCity: data.currentCity,
            checkInDate: data.defaultCheckIn,
            checkOutDate: data.defaultCheckOut,
            loading: false,
          })
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

      openCitySelector: () => set({ isCitySelectorOpen: true }),
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
