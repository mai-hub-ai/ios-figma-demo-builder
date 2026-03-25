import { http, HttpResponse, delay } from 'msw'
import {
  generateMockPackage,
  generateDateAvailability,
} from '@/services/mockData'
import type { Order } from '@/types'
import { faker } from '@faker-js/faker/locale/zh_CN'

export const handlers = [
  // GET /api/packages/:id - 获取套餐详情
  http.get('/api/packages/:id', async ({ params }) => {
    await delay(200)
    const { id: _id } = params
    const pkg = generateMockPackage({ id: _id as string })
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
    const { id: _id } = params
    const availability = generateDateAvailability(`${month}-01`, 30, 999)
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
    const pkg = generateMockPackage()
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
