import { http, HttpResponse, delay } from 'msw'
import type { City, HotKeyword, CalendarMonth, CalendarDay } from '@/types'

// 热门城市数据
const hotCities: City[] = [
  { cityCode: 'SHA', cityName: '上海', pinyin: 'shanghai', firstLetter: 'S' },
  { cityCode: 'BJS', cityName: '北京', pinyin: 'beijing', firstLetter: 'B' },
  { cityCode: 'HZH', cityName: '杭州', pinyin: 'hangzhou', firstLetter: 'H' },
  { cityCode: 'NAN', cityName: '南京', pinyin: 'nanjing', firstLetter: 'N' },
  { cityCode: 'CDE', cityName: '成都', pinyin: 'chengdu', firstLetter: 'C' },
  { cityCode: 'GZH', cityName: '广州', pinyin: 'guangzhou', firstLetter: 'G' },
  { cityCode: 'SZH', cityName: '深圳', pinyin: 'shenzhen', firstLetter: 'S' },
  { cityCode: 'SUZ', cityName: '苏州', pinyin: 'suzhou', firstLetter: 'S' },
]

// 所有城市数据
const allCities: City[] = [
  ...hotCities,
  { cityCode: 'TIJ', cityName: '天津', pinyin: 'tianjin', firstLetter: 'T' },
  { cityCode: 'WUH', cityName: '武汉', pinyin: 'wuhan', firstLetter: 'W' },
  { cityCode: 'XIA', cityName: '西安', pinyin: 'xian', firstLetter: 'X' },
  { cityCode: 'CHQ', cityName: '重庆', pinyin: 'chongqing', firstLetter: 'C' },
  { cityCode: 'KUN', cityName: '昆明', pinyin: 'kunming', firstLetter: 'K' },
  { cityCode: 'SYA', cityName: '三亚', pinyin: 'sanya', firstLetter: 'S' },
  { cityCode: 'XMN', cityName: '厦门', pinyin: 'xiamen', firstLetter: 'X' },
]

// 热搜词数据
const generateHotKeywords = (): HotKeyword[] => [
  { id: 1, text: '外滩', type: 'location' },
  { id: 2, text: '迪士尼', type: 'location' },
  { id: 3, text: '希尔顿', type: 'brand' },
  { id: 4, text: '万豪', type: 'brand' },
  { id: 5, text: '浦东机场', type: 'location' },
  { id: 6, text: '和平饭店', type: 'hotel' },
  { id: 7, text: '南京路', type: 'location' },
  { id: 8, text: '陆家嘴', type: 'location' },
  { id: 9, text: '香格里拉', type: 'brand' },
  { id: 10, text: '静安寺', type: 'location' },
]

// 日历数据生成
const generateCalendarData = (months: number): CalendarMonth[] => {
  const result: CalendarMonth[] = []
  const today = new Date()
  // 将today设为当天0点，确保比较正确
  today.setHours(0, 0, 0, 0)
  
  for (let m = 0; m < months; m++) {
    const monthDate = new Date(today.getFullYear(), today.getMonth() + m, 1)
    const year = monthDate.getFullYear()
    const month = monthDate.getMonth() + 1
    
    const daysInMonth = new Date(year, month, 0).getDate()
    const days: CalendarDay[] = []
    
    for (let d = 1; d <= daysInMonth; d++) {
      const date = new Date(year, month - 1, d)
      // 将date也设为0点进行比较
      date.setHours(0, 0, 0, 0)
      const dateStr = `${year}-${String(month).padStart(2, '0')}-${String(d).padStart(2, '0')}`
      
      const todayZero = new Date(today)
      todayZero.setHours(0, 0, 0, 0)
      
      const isToday = date.getTime() === todayZero.getTime()
      
      const tomorrow = new Date(todayZero)
      tomorrow.setDate(tomorrow.getDate() + 1)
      const isTomorrow = date.getTime() === tomorrow.getTime()
      
      const dayOfWeek = date.getDay()
      const isWeekend = dayOfWeek === 0 || dayOfWeek === 6
      
      let label = ''
      if (isToday) label = '今天'
      else if (isTomorrow) label = '明天'
      
      const basePrice = 388 + Math.floor(Math.random() * 200)
      const weekendSurcharge = isWeekend ? 50 : 0
      
      days.push({
        date: dateStr,
        price: basePrice + weekendSurcharge,
        available: date >= todayZero, // 今天及之后都可用
        label,
        isHoliday: false,
        holidayName: '',
      })
    }
    
    result.push({ year, month, days })
  }
  
  return result
}

export const searchHandlers = [
  // GET /api/search-page/init - 页面初始化
  http.get('/api/search-page/init', async ({ request }) => {
    await delay(300)
    const url = new URL(request.url)
    const cityCode = url.searchParams.get('cityCode') || 'SHA'
    const currentCity = hotCities.find(c => c.cityCode === cityCode) || hotCities[0]
    
    const today = new Date()
    const tomorrow = new Date(today)
    tomorrow.setDate(tomorrow.getDate() + 1)
    
    const formatDate = (d: Date) => d.toISOString().split('T')[0]
    
    return HttpResponse.json({
      code: 0,
      message: 'success',
      data: {
        currentCity,
        hotCities,
        hotKeywords: generateHotKeywords(),
        sloganImageUrl: 'https://picsum.photos/400/60?random=1',
        sloganAlt: '精选好价 安心入住',
        defaultCheckIn: formatDate(today),
        defaultCheckOut: formatDate(tomorrow),
      },
    })
  }),

  // GET /api/cities - 获取城市列表
  http.get('/api/cities', async () => {
    await delay(200)
    return HttpResponse.json({
      code: 0,
      message: 'success',
      data: {
        cities: allCities,
        hotCities,
      },
    })
  }),

  // GET /api/calendar - 获取日历数据
  http.get('/api/calendar', async ({ request }) => {
    await delay(300)
    const url = new URL(request.url)
    const months = parseInt(url.searchParams.get('months') || '3')
    return HttpResponse.json({
      code: 0,
      message: 'success',
      data: {
        months: generateCalendarData(months),
      },
    })
  }),

  // GET /api/hot-keywords - 获取热搜词
  http.get('/api/hot-keywords', async () => {
    await delay(200)
    
    return HttpResponse.json({
      code: 0,
      message: 'success',
      data: {
        keywords: generateHotKeywords(),
      },
    })
  }),

  // GET /api/search-page/config - 获取页面配置
  http.get('/api/search-page/config', async () => {
    await delay(100)
    return HttpResponse.json({
      code: 0,
      message: 'success',
      data: {
        sloganImageUrl: 'https://picsum.photos/400/60?random=1',
        sloganAlt: '精选好价 安心入住',
      },
    })
  }),
]
