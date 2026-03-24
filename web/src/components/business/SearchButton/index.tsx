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
      className={`w-full text-gray-900 font-semibold active:shadow-inner transition-shadow ${className}`}
      style={{
        height: 42, // Figma 84px减半
        borderRadius: 66, // Figma 132px减半
        backgroundColor: '#FFE033', // Figma品牌色
        fontSize: 15, // 调整为15px
      }}
    >
      搜索酒店
    </button>
  )
}
