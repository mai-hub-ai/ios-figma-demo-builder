import { setupWorker } from 'msw/browser'
import { searchHandlers } from './searchHandlers'
import { handlers } from './handlers'

// searchHandlers 优先注册，确保 /api/packages 列表路由被正确匹配
export const worker = setupWorker(...searchHandlers, ...handlers)
