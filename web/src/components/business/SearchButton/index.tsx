import { useNavigate } from 'react-router-dom'

interface SearchButtonProps {
  className?: string
}

export function SearchButton({ className = '' }: SearchButtonProps) {
  const navigate = useNavigate()

  const handleSearch = () => {
    // 参数已存储在store中，列表页可读取
    navigate('/packages')
  }

  return (
    <button
      onClick={handleSearch}
      className={`w-full py-3 bg-[#FFD700] text-gray-900 text-lg font-semibold rounded-lg shadow-sm active:shadow-inner transition-shadow ${className}`}
    >
      搜索
    </button>
  )
}
