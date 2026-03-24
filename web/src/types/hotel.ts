/** 酒店套餐状态 */
export type PackageStatus = 'available' | 'limited' | 'sold_out';

/** 房型 */
export interface RoomType {
  id: string;
  name: string;
  description: string;
  images: string[];
  bedType: string;
  area: number; // 平方米
  maxGuests: number;
  floor: string;
  facilities: string[];
}

/** 套餐权益 */
export interface PackageBenefit {
  id: string;
  icon: string;
  title: string;
  description: string;
}

/** 套餐价格信息 */
export interface PriceInfo {
  originalPrice: number;
  currentPrice: number;
  weekendSurcharge: number;
  childPrice?: number;
  breakfastPrice?: number;
}

/** 日期可用性 */
export interface DateAvailability {
  date: string; // YYYY-MM-DD
  available: boolean;
  price: number;
  remainingRooms: number;
  isWeekend: boolean;
  isHoliday: boolean;
}

/** 酒店套餐 */
export interface HotelPackage {
  id: string;
  hotelId: string;
  hotelName: string;
  hotelStar: number;
  hotelAddress: string;
  hotelLat: number;
  hotelLng: number;
  coverImage: string;
  images: string[];
  title: string;
  subtitle: string;
  tags: string[];
  roomType: RoomType;
  benefits: PackageBenefit[];
  priceInfo: PriceInfo;
  nights: number;
  includeBreakfast: boolean;
  breakfastCount: number; // 含几份早餐
  status: PackageStatus;
  salesCount: number;
  rating: number;
  reviewCount: number;
  validDateStart: string;
  validDateEnd: string;
  refundPolicy: string;
  notices: string[];
}

/** 入住人信息 */
export interface GuestInfo {
  name: string;
  phone: string;
  idType: 'id_card' | 'passport';
  idNumber: string;
}

/** 订单状态 */
export type OrderStatus =
  | 'pending_payment'
  | 'paid'
  | 'confirmed'
  | 'checked_in'
  | 'completed'
  | 'cancelled'
  | 'refunded';

/** 订单 */
export interface Order {
  id: string;
  orderNo: string;
  packageId: string;
  package: HotelPackage;
  checkInDate: string;
  checkOutDate: string;
  nights: number;
  guestInfo: GuestInfo;
  adultCount: number;
  childCount: number;
  totalPrice: number;
  status: OrderStatus;
  paymentMethod?: string;
  paidAt?: string;
  createdAt: string;
  remark?: string;
}

/** API 统一响应格式 */
export interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}

/** 分页参数 */
export interface PaginationParams {
  page: number;
  pageSize: number;
}

/** 分页响应 */
export interface PaginatedData<T> {
  list: T[];
  total: number;
  page: number;
  pageSize: number;
}

/** 套餐筛选参数 */
export interface PackageFilterParams extends PaginationParams {
  keyword?: string;
  minPrice?: number;
  maxPrice?: number;
  includeBreakfast?: boolean;
  hotelStar?: number;
  sortBy?: 'price_asc' | 'price_desc' | 'rating' | 'sales';
}
