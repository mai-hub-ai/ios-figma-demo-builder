import { useSearchStore } from '@/store/searchStore'

interface SloganBannerProps {
  className?: string
}

export function SloganBanner({ className = '' }: SloganBannerProps) {
  const { sloganImageUrl, sloganAlt } = useSearchStore()

  if (!sloganImageUrl) return null

  return (
    <div className={`px-4 py-3 ${className}`}>
      <img
        src={sloganImageUrl}
        alt={sloganAlt || '精选好价 安心入住'}
        className="w-full h-auto rounded-lg"
      />
    </div>
  )
}
