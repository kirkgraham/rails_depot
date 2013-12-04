require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products

	def new_product(title, price, image_url)
		Product.new(
			title: title || products(:ruby).title,
			description: products(:ruby).description,
			price: price || 1,
			image_url: image_url || products(:ruby).image_url)
	end

	test "product attributes must not be empty" do
		product = Product.new
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:price].any?
		assert product.errors[:image_url].any?
	end

	test "product price must be positive" do
		product = new_product(nil, -1, nil)
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"],
			product.errors[:price]

		product = new_product(nil, 0, nil)
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"],
			product.errors[:price]

		product = new_product("Test Title", 1, nil)
		assert product.valid?
	end

	test "image url" do
		title = "My Book Title"

		ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
		bad = %w{ fred.doc fred.gif/more fred.gif.more }

		ok.each do |name|
			assert new_product(title, nil, name).valid?, "#{name} should be valid."
		end

		bad.each do |name|
			assert new_product(title, nil, name).invalid?, "#{name} should NOT be valid."
		end
	end

	test "product is not valid without a unique title" do
		product = new_product(products(:ruby).title, nil, nil)
		assert product.invalid?
		assert_equal ["has already been taken"], product.errors[:title]
	end

	test "product is not valid without a unique title - i18n" do
		product = new_product(products(:ruby).title, nil, nil)
		assert product.invalid?
		assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
	end

	test "product title must be at least 10 characters long" do
		product = new_product("Hello World", nil, nil)
		assert product.valid?

		product = new_product("Hello", nil, nil)
		assert product.invalid?
		assert_equal ["is too short (minimum is 10 characters)"], product.errors[:title]
	end
end