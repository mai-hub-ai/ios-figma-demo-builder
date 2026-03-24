import { test, expect } from '@playwright/test'

test.describe('飞猪酒店套餐 - 基础导航', () => {
  test('首页重定向到套餐列表', async ({ page }) => {
    await page.goto('/')
    await expect(page).toHaveURL('/packages')
  })

  test('套餐列表页可访问', async ({ page }) => {
    await page.goto('/packages')
    await expect(page.getByText('套餐列表')).toBeVisible()
  })
})
