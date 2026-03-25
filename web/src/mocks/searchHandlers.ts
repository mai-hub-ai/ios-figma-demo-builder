import { http, HttpResponse, delay } from 'msw'
import type { City, HotKeyword, CalendarMonth, CalendarDay, Brand, PackageCard } from '@/types'

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
  today.setHours(0, 0, 0, 0)
  
  for (let m = 0; m < months; m++) {
    const monthDate = new Date(today.getFullYear(), today.getMonth() + m, 1)
    const year = monthDate.getFullYear()
    const month = monthDate.getMonth() + 1
    
    const daysInMonth = new Date(year, month, 0).getDate()
    const days: CalendarDay[] = []
    
    for (let d = 1; d <= daysInMonth; d++) {
      const date = new Date(year, month - 1, d)
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
        available: date >= todayZero,
        label,
        isHoliday: false,
        holidayName: '',
      })
    }
    
    result.push({ year, month, days })
  }
  
  return result
}

// 品牌数据
const brands: Brand[] = [
  { brandCode: 'hilton', brandName: '希尔顿' },
  { brandCode: 'marriott', brandName: '万豪' },
  { brandCode: 'intercontinental', brandName: '洲际' },
  { brandCode: 'hyatt', brandName: '凯悦' },
  { brandCode: 'accor', brandName: '雅高' },
  { brandCode: 'shangri_la', brandName: '香格里拉' },
  { brandCode: 'jinjiang', brandName: '锦江' },
  { brandCode: 'huazhu', brandName: '华住' },
  { brandCode: 'home_inn', brandName: '如家' },
  { brandCode: 'atour', brandName: '亚朵' },
]

// 套餐Mock数据 - 30条，支持刷3屏
const packageMockData: PackageCard[] = [
  {
    packageId: 'pkg_001',
    hotelId: 'htl_001',
    hotelName: '上海外滩W酒店',
    packageTitle: '豪华江景房+双人自助晚餐+延迟退房',
    imageUrl: 'https://picsum.photos/400/300?random=1',
    score: 4.9,
    highlightText: '江景绝美，服务贴心',
    poiName: '外滩',
    distance: '0.3km',
    tags: ['免费升房', '含双早', '延迟退房'],
    salesCount: 5320,
    price: 1299,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_002',
    hotelId: 'htl_002',
    hotelName: '上海浦东丽思卡尔顿酒店',
    packageTitle: '行政套房+下午茶+SPA体验券',
    imageUrl: 'https://picsum.photos/400/300?random=2',
    score: 4.8,
    highlightText: '顶级奢华，服务一流',
    poiName: '陆家嘴',
    distance: '0.5km',
    tags: ['行政待遇', '免费停车'],
    salesCount: 3280,
    price: 2588,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_003',
    hotelId: 'htl_003',
    hotelName: '上海迪士尼乐园酒店',
    packageTitle: '主题房+双早+提前入园特权',
    imageUrl: 'https://picsum.photos/400/300?random=3',
    score: 4.7,
    highlightText: '亲子首选，童话体验',
    poiName: '迪士尼乐园',
    distance: '0.2km',
    tags: ['提前入园', '接驳巴士'],
    salesCount: 8650,
    price: 1688,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_004',
    hotelId: 'htl_004',
    hotelName: '上海静安香格里拉酒店',
    packageTitle: '豪华阁房+行政酒廊待遇+免费早餐',
    imageUrl: 'https://picsum.photos/400/300?random=4',
    score: 4.6,
    highlightText: '位置优越，设施完善',
    poiName: '静安寺',
    distance: '0.4km',
    tags: ['行政待遇', '含双早'],
    salesCount: 4520,
    price: 1188,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_005',
    hotelId: 'htl_005',
    hotelName: '上海外滩华尔道夫酒店',
    packageTitle: '江景套房+双人下午茶+接机服务',
    imageUrl: 'https://picsum.photos/400/300?random=5',
    score: 4.9,
    highlightText: '百年经典，极致奢华',
    poiName: '外滩',
    distance: '0.1km',
    tags: ['历史建筑', '管家服务'],
    salesCount: 2180,
    price: 3588,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_006',
    hotelId: 'htl_006',
    hotelName: '上海和平饭店',
    packageTitle: '经典房+九国套房参观+爵士酒吧体验',
    imageUrl: 'https://picsum.photos/400/300?random=6',
    score: 4.8,
    highlightText: '传奇酒店，老上海风情',
    poiName: '外滩',
    distance: '0.2km',
    tags: ['历史地标', '爵士乐'],
    salesCount: 3680,
    price: 1988,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_007',
    hotelId: 'htl_007',
    hotelName: '上海浦东文华东方酒店',
    packageTitle: '江景房+米其林餐厅午餐+SPA',
    imageUrl: 'https://picsum.photos/400/300?random=7',
    score: 4.7,
    highlightText: '东方美学，精致服务',
    poiName: '陆家嘴',
    distance: '0.6km',
    tags: ['米其林', '江景房'],
    salesCount: 2890,
    price: 2188,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_008',
    hotelId: 'htl_008',
    hotelName: '上海半岛酒店',
    packageTitle: '豪华房+劳斯莱斯接送+下午茶',
    imageUrl: 'https://picsum.photos/400/300?random=8',
    score: 4.9,
    highlightText: '顶级服务，传奇体验',
    poiName: '外滩',
    distance: '0.3km',
    tags: ['劳斯莱斯', '精品购物'],
    salesCount: 1520,
    price: 3888,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_009',
    hotelId: 'htl_009',
    hotelName: '上海世茂皇家艾美酒店',
    packageTitle: '行政房+南京路购物券+免费早餐',
    imageUrl: 'https://picsum.photos/400/300?random=9',
    score: 4.5,
    highlightText: '性价比高，购物方便',
    poiName: '南京路',
    distance: '0.1km',
    tags: ['购物优惠', '含早'],
    salesCount: 6320,
    price: 888,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_010',
    hotelId: 'htl_010',
    hotelName: '上海新天地朗廷酒店',
    packageTitle: '豪华房+唐阁午餐+健身房体验',
    imageUrl: 'https://picsum.photos/400/300?random=10',
    score: 4.7,
    highlightText: '时尚街区，美食天堂',
    poiName: '新天地',
    distance: '0.3km',
    tags: ['米其林餐厅', '网红打卡'],
    salesCount: 4280,
    price: 1488,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_011',
    hotelId: 'htl_011',
    hotelName: '上海金茂君悦大酒店',
    packageTitle: '云端房+高空下午茶+观光体验',
    imageUrl: 'https://picsum.photos/400/300?random=11',
    score: 4.6,
    highlightText: '云端体验，俯瞰上海',
    poiName: '陆家嘴',
    distance: '0.4km',
    tags: ['88层观光', '云端下午茶'],
    salesCount: 5820,
    price: 1388,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_012',
    hotelId: 'htl_012',
    hotelName: '上海虹桥康得思酒店',
    packageTitle: '豪华房+机场接送+SPA体验',
    imageUrl: 'https://picsum.photos/400/300?random=12',
    score: 4.5,
    highlightText: '机场便利，度假首选',
    poiName: '虹桥机场',
    distance: '1.2km',
    tags: ['机场接送', '无边泳池'],
    salesCount: 3450,
    price: 998,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_013',
    hotelId: 'htl_013',
    hotelName: '上海璞丽酒店',
    packageTitle: '静谧套房+私人茶室+瑜伽课程',
    imageUrl: 'https://picsum.photos/400/300?random=13',
    score: 4.8,
    highlightText: '都市隐居，禅意空间',
    poiName: '静安寺',
    distance: '0.5km',
    tags: ['禅意设计', '私人茶室'],
    salesCount: 2180,
    price: 2688,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_014',
    hotelId: 'htl_014',
    hotelName: '上海宝格丽酒店',
    packageTitle: '奢华套房+意大利下午茶+私厨晚餐',
    imageUrl: 'https://picsum.photos/400/300?random=14',
    score: 4.9,
    highlightText: '意式奢华，艺术之旅',
    poiName: '苏州河',
    distance: '0.8km',
    tags: ['艺术收藏', '意式风情'],
    salesCount: 1280,
    price: 4888,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_015',
    hotelId: 'htl_015',
    hotelName: '上海苏宁环球万怡酒店',
    packageTitle: '商务房+免费停车+自助早餐',
    imageUrl: 'https://picsum.photos/400/300?random=15',
    score: 4.4,
    highlightText: '商务首选，设施完善',
    poiName: '五角场',
    distance: '0.6km',
    tags: ['商务中心', '免费停车'],
    salesCount: 7280,
    price: 688,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_016',
    hotelId: 'htl_016',
    hotelName: '上海外滩悦榕庄酒店',
    packageTitle: '江景套房+浪漫晚餐+情侣SPA',
    imageUrl: 'https://picsum.photos/400/300?random=16',
    score: 4.8,
    highlightText: '浪漫之旅，私享江景',
    poiName: '外滩',
    distance: '0.2km',
    tags: ['情侣首选', '无边泳池'],
    salesCount: 2580,
    price: 2888,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_017',
    hotelId: 'htl_017',
    hotelName: '上海扬子江万丽大酒店',
    packageTitle: '行政房+商务中心+健身房',
    imageUrl: 'https://picsum.photos/400/300?random=17',
    score: 4.5,
    highlightText: '位置优越，商务便利',
    poiName: '虹桥开发区',
    distance: '0.3km',
    tags: ['商务会议', '交通便利'],
    salesCount: 5680,
    price: 788,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_018',
    hotelId: 'htl_018',
    hotelName: '上海外滩茂悦大酒店',
    packageTitle: '全景房+高空晚餐+江景早餐',
    imageUrl: 'https://picsum.photos/400/300?random=18',
    score: 4.6,
    highlightText: '无敌视野，尽览浦江',
    poiName: '外滩',
    distance: '0.4km',
    tags: ['全景落地窗', '高空餐厅'],
    salesCount: 4180,
    price: 1588,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_019',
    hotelId: 'htl_019',
    hotelName: '上海佘山世茂洲际酒店',
    packageTitle: '深坑房+地心探险+水下餐厅',
    imageUrl: 'https://picsum.photos/400/300?random=19',
    score: 4.7,
    highlightText: '世界奇迹，地心之旅',
    poiName: '佘山',
    distance: '0.5km',
    tags: ['网红打卡', '水下景观'],
    salesCount: 6120,
    price: 1988,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_020',
    hotelId: 'htl_020',
    hotelName: '上海静安瑞吉酒店',
    packageTitle: '行政套房+瑞吉管家服务+私人晚餐',
    imageUrl: 'https://picsum.photos/400/300?random=20',
    score: 4.8,
    highlightText: '传奇奢华，贴心服务',
    poiName: '静安寺',
    distance: '0.3km',
    tags: ['管家服务', '行政待遇'],
    salesCount: 2680,
    price: 2388,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_021',
    hotelId: 'htl_021',
    hotelName: '上海虹口三至喜来登酒店',
    packageTitle: '豪华房+亲子活动+儿童乐园',
    imageUrl: 'https://picsum.photos/400/300?random=21',
    score: 4.5,
    highlightText: '亲子欢乐，设施齐全',
    poiName: '北外滩',
    distance: '0.7km',
    tags: ['儿童乐园', '亲子活动'],
    salesCount: 4980,
    price: 888,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_022',
    hotelId: 'htl_022',
    hotelName: '上海豫园万丽酒店',
    packageTitle: '古典房+豫园门票+老城厢美食',
    imageUrl: 'https://picsum.photos/400/300?random=22',
    score: 4.4,
    highlightText: '古韵风情，美食之旅',
    poiName: '豫园',
    distance: '0.2km',
    tags: ['豫园门票', '老城美食'],
    salesCount: 5280,
    price: 758,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_023',
    hotelId: 'htl_023',
    hotelName: '上海龙之梦万丽酒店',
    packageTitle: '豪华房+购物优惠+自助晚餐',
    imageUrl: 'https://picsum.photos/400/300?random=23',
    score: 4.3,
    highlightText: '购物天堂，交通便利',
    poiName: '中山公园',
    distance: '0.1km',
    tags: ['商场直连', '地铁上盖'],
    salesCount: 6850,
    price: 668,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_024',
    hotelId: 'htl_024',
    hotelName: '上海浦东嘉里城香格里拉',
    packageTitle: '家庭房+儿童乐园+亲子早餐',
    imageUrl: 'https://picsum.photos/400/300?random=24',
    score: 4.6,
    highlightText: '亲子度假，欢乐时光',
    poiName: '花木路',
    distance: '0.3km',
    tags: ['儿童乐园', '亲子早餐'],
    salesCount: 5720,
    price: 1188,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_025',
    hotelId: 'htl_025',
    hotelName: '上海外滩浦华大酒店',
    packageTitle: '江景房+下午茶+免费停车',
    imageUrl: 'https://picsum.photos/400/300?random=25',
    score: 4.4,
    highlightText: '江景实惠，性价比高',
    poiName: '外滩',
    distance: '0.5km',
    tags: ['江景房', '免费停车'],
    salesCount: 6380,
    price: 968,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_026',
    hotelId: 'htl_026',
    hotelName: '上海外滩英迪格酒店',
    packageTitle: '设计房+创意鸡尾酒+艺术导览',
    imageUrl: 'https://picsum.photos/400/300?random=26',
    score: 4.6,
    highlightText: '设计感十足，艺术氛围',
    poiName: '外滩',
    distance: '0.3km',
    tags: ['艺术设计', '创意餐饮'],
    salesCount: 3580,
    price: 1288,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_027',
    hotelId: 'htl_027',
    hotelName: '上海徐汇瑞峰酒店',
    packageTitle: '商务房+会议室2小时+商务早餐',
    imageUrl: 'https://picsum.photos/400/300?random=27',
    score: 4.3,
    highlightText: '商务便利，设施完善',
    poiName: '徐家汇',
    distance: '0.4km',
    tags: ['会议室', '商务中心'],
    salesCount: 7820,
    price: 588,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_028',
    hotelId: 'htl_028',
    hotelName: '上海浦东喜来登由由酒店',
    packageTitle: '行政房+SPA抵用券+延迟退房',
    imageUrl: 'https://picsum.photos/400/300?random=28',
    score: 4.5,
    highlightText: '设施完善，服务周到',
    poiName: '陆家嘴',
    distance: '0.8km',
    tags: ['SPA', '延迟退房'],
    salesCount: 5480,
    price: 898,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_029',
    hotelId: 'htl_029',
    hotelName: '上海安曼纳卓悦大酒店',
    packageTitle: '豪华房+接机服务+免费停车',
    imageUrl: 'https://picsum.photos/400/300?random=29',
    score: 4.4,
    highlightText: '性价比高，位置便利',
    poiName: '南京西路',
    distance: '0.2km',
    tags: ['接机服务', '免费停车'],
    salesCount: 6680,
    price: 728,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
  {
    packageId: 'pkg_030',
    hotelId: 'htl_030',
    hotelName: '上海东湖宾馆',
    packageTitle: '经典房+老上海早餐+历史导览',
    imageUrl: 'https://picsum.photos/400/300?random=30',
    score: 4.2,
    highlightText: '老上海风情，经典体验',
    poiName: '淮海路',
    distance: '0.3km',
    tags: ['历史建筑', '经典早餐'],
    salesCount: 4280,
    price: 588,
    pricePrefix: '券后',
    priceSuffix: '起',
  },
]

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

  // GET /api/brands - 获取品牌列表
  http.get('/api/brands', async () => {
    await delay(200)
    return HttpResponse.json({
      code: 0,
      message: 'success',
      data: {
        brands,
      },
    })
  }),

  // GET /api/packages - 获取套餐列表
  http.get('/api/packages', async ({ request }) => {
    await delay(300)
    const url = new URL(request.url)
    const page = parseInt(url.searchParams.get('page') || '1')
    const pageSize = parseInt(url.searchParams.get('pageSize') || '10')
    const sortType = url.searchParams.get('sortType') || 'sales_desc'
    const brandCode = url.searchParams.get('brandCode')

    // 根据筛选条件过滤
    let filteredData = [...packageMockData]
    
    // 模拟品牌筛选
    if (brandCode) {
      filteredData = filteredData.filter((_, index) => index % 3 === brands.findIndex(b => b.brandCode === brandCode) % 3)
    }
    
    // 排序
    if (sortType === 'sales_desc') {
      filteredData.sort((a, b) => b.salesCount - a.salesCount)
    } else if (sortType === 'sales_asc') {
      filteredData.sort((a, b) => a.salesCount - b.salesCount)
    } else if (sortType === 'price_asc') {
      filteredData.sort((a, b) => a.price - b.price)
    } else if (sortType === 'price_desc') {
      filteredData.sort((a, b) => b.price - a.price)
    }

    // 分页
    const startIndex = (page - 1) * pageSize
    const endIndex = startIndex + pageSize
    const paginatedList = filteredData.slice(startIndex, endIndex)
    const hasMore = endIndex < filteredData.length

    return HttpResponse.json({
      code: 0,
      message: 'success',
      data: {
        total: filteredData.length,
        page,
        pageSize,
        hasMore,
        list: paginatedList,
      },
    })
  }),
]
