import { faker } from '@faker-js/faker/locale/zh_CN'
import type { HotelPackage, DateAvailability } from '@/types'

const HOTEL_NAMES = [
  '三亚亚特兰蒂斯酒店',
  '杭州西湖国宾馆',
  '上海外滩W酒店',
  '厦门安达仕酒店',
  '成都瑰丽酒店',
  '北京王府半岛酒店',
  '丽江金茂璞修酒店',
  '珠海长隆横琴湾酒店',
  '青岛涵碧楼酒店',
  '西双版纳万达文华度假酒店',
]

const ROOM_TYPES = [
  { name: '豪华大床房', bedType: '1.8m大床', area: 45 },
  { name: '海景双床房', bedType: '1.2m双床', area: 52 },
  { name: '亲子主题房', bedType: '1.8m大床+1.2m小床', area: 58 },
  { name: '行政套房', bedType: '2.0m大床', area: 75 },
  { name: '总统套房', bedType: '2.0m大床', area: 120 },
]

const PACKAGE_TAGS = [
  '限时特惠', '含双早', '免费取消', '连住优惠',
  '亲子专享', '蜜月推荐', '网红打卡', '含接送机',
]

const FACILITIES = [
  '免费WiFi', '独立卫浴', '迷你吧', '保险箱',
  '衣帽间', '浴缸', '阳台', '海景', '山景',
  '泳池', '健身房', '儿童乐园', '行政酒廊',
]

const BENEFITS_TEMPLATES = [
  { icon: 'breakfast', title: '精选自助早餐', description: '含中西式自助早餐' },
  { icon: 'pool', title: '无边泳池', description: '无限次使用泳池设施' },
  { icon: 'spa', title: 'SPA 体验', description: '赠送双人SPA一次' },
  { icon: 'transfer', title: '接送机服务', description: '含单程接送机' },
  { icon: 'minibar', title: '迷你吧畅饮', description: '房内迷你吧免费' },
  { icon: 'late_checkout', title: '延迟退房', description: '可延迟至14:00退房' },
  { icon: 'upgrade', title: '房型升级', description: '视可用性免费升级' },
  { icon: 'playground', title: '儿童乐园', description: '含儿童乐园门票' },
]

export function generateMockPackage(overrides?: Partial<HotelPackage>): HotelPackage {
  const roomTemplate = faker.helpers.arrayElement(ROOM_TYPES)
  const originalPrice = faker.number.int({ min: 800, max: 5000 })
  const discount = faker.helpers.arrayElement([0.6, 0.65, 0.7, 0.75, 0.8, 0.85])
  const nights = faker.helpers.arrayElement([1, 2, 3])
  const includeBreakfast = faker.datatype.boolean({ probability: 0.7 })

  return {
    id: faker.string.uuid(),
    hotelId: faker.string.uuid(),
    hotelName: faker.helpers.arrayElement(HOTEL_NAMES),
    hotelStar: faker.helpers.arrayElement([4, 5]),
    hotelAddress: faker.location.streetAddress(),
    hotelLat: faker.location.latitude({ min: 18, max: 45 }),
    hotelLng: faker.location.longitude({ min: 100, max: 122 }),
    coverImage: `https://picsum.photos/seed/${faker.string.alphanumeric(8)}/750/500`,
    images: Array.from({ length: faker.number.int({ min: 3, max: 8 }) }, () =>
      `https://picsum.photos/seed/${faker.string.alphanumeric(8)}/750/500`
    ),
    title: `${faker.helpers.arrayElement(HOTEL_NAMES)} · ${roomTemplate.name}${nights}晚套餐`,
    subtitle: `含${includeBreakfast ? '双早+' : ''}多项权益`,
    tags: faker.helpers.arrayElements(PACKAGE_TAGS, { min: 2, max: 4 }),
    roomType: {
      id: faker.string.uuid(),
      name: roomTemplate.name,
      description: `${roomTemplate.area}㎡ · ${roomTemplate.bedType}`,
      images: Array.from({ length: 3 }, () =>
        `https://picsum.photos/seed/${faker.string.alphanumeric(8)}/750/500`
      ),
      bedType: roomTemplate.bedType,
      area: roomTemplate.area,
      maxGuests: faker.helpers.arrayElement([2, 3, 4]),
      floor: `${faker.number.int({ min: 3, max: 30 })}-${faker.number.int({ min: 31, max: 50 })}层`,
      facilities: faker.helpers.arrayElements(FACILITIES, { min: 4, max: 8 }),
    },
    benefits: faker.helpers.arrayElements(BENEFITS_TEMPLATES, { min: 3, max: 6 }).map(b => ({
      ...b,
      id: faker.string.uuid(),
    })),
    priceInfo: {
      originalPrice,
      currentPrice: Math.round(originalPrice * discount),
      weekendSurcharge: faker.helpers.arrayElement([0, 100, 200, 300]),
      childPrice: faker.helpers.arrayElement([0, 99, 199]),
      breakfastPrice: includeBreakfast ? 0 : faker.helpers.arrayElement([68, 88, 128]),
    },
    nights,
    includeBreakfast,
    breakfastCount: includeBreakfast ? faker.helpers.arrayElement([1, 2]) : 0,
    status: faker.helpers.weightedArrayElement([
      { value: 'available' as const, weight: 8 },
      { value: 'limited' as const, weight: 2 },
      { value: 'sold_out' as const, weight: 1 },
    ]),
    salesCount: faker.number.int({ min: 100, max: 9999 }),
    rating: parseFloat(faker.number.float({ min: 4.0, max: 5.0, fractionDigits: 1 }).toFixed(1)),
    reviewCount: faker.number.int({ min: 50, max: 2000 }),
    validDateStart: '2026-04-01',
    validDateEnd: '2026-12-31',
    refundPolicy: faker.helpers.arrayElement([
      '预订后30分钟内免费取消',
      '入住前3天免费取消',
      '不可取消',
    ]),
    notices: [
      '入住时间：15:00后，退房时间：12:00前',
      '需携带有效身份证件办理入住',
      '套餐有效期内不可转让',
    ],
    ...overrides,
  }
}

export function generateMockPackages(count: number): HotelPackage[] {
  return Array.from({ length: count }, () => generateMockPackage())
}

export function generateDateAvailability(
  startDate: string,
  days: number,
  basePrice: number,
): DateAvailability[] {
  const result: DateAvailability[] = []
  const start = new Date(startDate)

  for (let i = 0; i < days; i++) {
    const date = new Date(start)
    date.setDate(start.getDate() + i)
    const dayOfWeek = date.getDay()
    const isWeekend = dayOfWeek === 0 || dayOfWeek === 6

    result.push({
      date: date.toISOString().split('T')[0],
      available: faker.datatype.boolean({ probability: 0.85 }),
      price: isWeekend ? basePrice + faker.helpers.arrayElement([100, 200, 300]) : basePrice,
      remainingRooms: faker.number.int({ min: 0, max: 10 }),
      isWeekend,
      isHoliday: false,
    })
  }

  return result
}
