import { http, HttpResponse, delay } from 'msw'
import {
  generateMockPackages,
  generateMockPackage,
  generateDateAvailability,
} from '@/services/mockData'
import type { Order } from '@/types'
import { faker } from '@faker-js/faker/locale/zh_CN'

// 缓存生成的套餐数据，保证详情页和列表页数据一致
let cachedPackages = generateMockPackages(20)

export const handlers = [
  // GET /api/packages - 获取套餐列表
  http.get('/api/packages', async ({ request }) => {
    await delay(300)
    const url = new URL(request.url)
    const page = parseInt(url.searchParams.get('page') || '1')
    const pageSize = parseInt(url.searchParams.get('pageSize') || '10')
    const keyword = url.searchParams.get('keyword') || ''
    const sortBy = url.searchParams.get('sortBy') || 'sales'

    let filtered = [...cachedPackages]

    // 关键词筛选
    if (keyword) {
      filtered = filtered.filter(
        p => p.title.includes(keyword) || p.hotelName.includes(keyword)
      )
    }

    // 排序
    switch (sortBy) {
      case 'price_asc':
        filtered.sort((a, b) => a.priceInfo.currentPrice - b.priceInfo.currentPrice)
        break
      case 'price_desc':
        filtered.sort((a, b) => b.priceInfo.currentPrice - a.priceInfo.currentPrice)
        break
      case 'rating':
        filtered.sort((a, b) => b.rating - a.rating)
        break
      case 'sales':
      default:
        filtered.sort((a, b) => b.salesCount - a.salesCount)
        break
    }

    const start = (page - 1) * pageSize
    const list = filtered.slice(start, start + pageSize)

    return HttpResponse.json({
      code: 200,
      message: 'success',
      data: {
        list,
        total: filtered.length,
        page,
        pageSize,
      },
    })
  }),

  // GET /api/packages/:id - 获取套餐详情
  http.get('/api/packages/:id', async ({ params }) => {
    await delay(200)
    const { id } = params
    const pkg = cachedPackages.find(p => p.id === id) || generateMockPackage({ id: id as string })

    return HttpResponse.json({
      code: 200,
      message: 'success',
      data: pkg,
    })
  }),

  // GET /api/packages/:id/availability - 获取日期可用性
  http.get('/api/packages/:id/availability', async ({ request, params }) => {
    await delay(200)
    const url = new URL(request.url)
    const month = url.searchParams.get('month') || '2026-04'
    const { id } = params
    const pkg = cachedPackages.find(p => p.id === id)
    const basePrice = pkg?.priceInfo.currentPrice || 999

    const availability = generateDateAvailability(`${month}-01`, 30, basePrice)

    return HttpResponse.json({
      code: 200,
      message: 'success',
      data: availability,
    })
  }),

  // POST /api/orders - 创建订单
  http.post('/api/orders', async ({ request }) => {
    await delay(500)
    const body = await request.json() as Record<string, unknown>
    const pkg = cachedPackages.find(p => p.id === body.packageId) || generateMockPackage()

    const order: Order = {
      id: faker.string.uuid(),
      orderNo: faker.string.numeric(16),
      packageId: pkg.id,
      package: pkg,
      checkInDate: body.checkInDate as string,
      checkOutDate: body.checkOutDate as string,
      nights: pkg.nights,
      guestInfo: {
        name: body.guestName as string,
        phone: body.guestPhone as string,
        idType: (body.guestIdType as 'id_card' | 'passport') || 'id_card',
        idNumber: body.guestIdNumber as string,
      },
      adultCount: (body.adultCount as number) || 2,
      childCount: (body.childCount as number) || 0,
      totalPrice: pkg.priceInfo.currentPrice * pkg.nights,
      status: 'paid',
      paymentMethod: '支付宝',
      paidAt: new Date().toISOString(),
      createdAt: new Date().toISOString(),
      remark: body.remark as string,
    }

    return HttpResponse.json({
      code: 200,
      message: '下单成功',
      data: order,
    })
  }),

  // GET /api/orders/:id - 获取订单详情
  http.get('/api/orders/:id', async ({ params }) => {
    await delay(200)
    const pkg = generateMockPackage()

    const order: Order = {
      id: params.id as string,
      orderNo: faker.string.numeric(16),
      packageId: pkg.id,
      package: pkg,
      checkInDate: '2026-05-01',
      checkOutDate: '2026-05-03',
      nights: 2,
      guestInfo: {
        name: faker.person.fullName(),
        phone: faker.phone.number(),
        idType: 'id_card',
        idNumber: '330102199001011234',
      },
      adultCount: 2,
      childCount: 0,
      totalPrice: pkg.priceInfo.currentPrice * 2,
      status: 'paid',
      paymentMethod: '支付宝',
      paidAt: new Date().toISOString(),
      createdAt: new Date().toISOString(),
    }

    return HttpResponse.json({
      code: 200,
      message: 'success',
      data: order,
    })
  }),
]
