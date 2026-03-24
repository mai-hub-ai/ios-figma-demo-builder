import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { SearchPage } from '@/pages'
import { PackageListPage } from '@/pages/PackageListPage'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/search" replace />} />
        <Route path="/search" element={<SearchPage />} />
        <Route path="/packages" element={<PackageListPage />} />
        <Route path="/packages/:id" element={<PlaceholderPage name="套餐详情" />} />
        <Route path="/calendar/:packageId" element={<PlaceholderPage name="日历选择" />} />
        <Route path="/order/confirm" element={<PlaceholderPage name="订单确认" />} />
        <Route path="/order/result/:orderId" element={<PlaceholderPage name="支付结果" />} />
      </Routes>
    </BrowserRouter>
  )
}

// 页面组件 - 后续由 Figma 高保真还原后替换
function PlaceholderPage({ name }: { name: string }) {
  return (
    <div className="flex items-center justify-center min-h-screen bg-white">
      <div className="text-center">
        <h1 className="text-2xl text-gray-800 mb-4">{name}</h1>
        <p className="text-gray-500">页面开发中...</p>
      </div>
    </div>
  )
}

export default App
