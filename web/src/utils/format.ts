/** 格式化价格 */
export function formatPrice(price: number): string {
  return `¥${price.toLocaleString('zh-CN')}`
}

/** 格式化日期 YYYY-MM-DD -> MM月DD日 */
export function formatDate(dateStr: string): string {
  const date = new Date(dateStr)
  return `${date.getMonth() + 1}月${date.getDate()}日`
}

/** 格式化日期范围 */
export function formatDateRange(start: string, end: string): string {
  return `${formatDate(start)} - ${formatDate(end)}`
}

/** 获取星级文本 */
export function getStarText(star: number): string {
  return '★'.repeat(star) + '☆'.repeat(5 - star)
}

/** 获取订单状态文本 */
export function getOrderStatusText(status: string): string {
  const map: Record<string, string> = {
    pending_payment: '待支付',
    paid: '已支付',
    confirmed: '已确认',
    checked_in: '已入住',
    completed: '已完成',
    cancelled: '已取消',
    refunded: '已退款',
  }
  return map[status] || status
}

/** 获取套餐状态文本 */
export function getPackageStatusText(status: string): string {
  const map: Record<string, string> = {
    available: '可预订',
    limited: '仅剩少量',
    sold_out: '已售罄',
  }
  return map[status] || status
}
