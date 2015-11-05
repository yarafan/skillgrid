class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :check_user, except: [:index]

  # GET /products
  # GET /products.json
  def index
    return @products = Product.where(pro: true) if current_user.try(:guest)
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    user = User.find(session[:user_id])
    redirect_to products_url unless user
    @product = user.products.create(product_params)
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  def make_pro
    product = Product.find(params[:id])
    product.toggle!(:pro)
    product.save
    redirect_to products_path, notice: "Product PRO status  changed to #{product.pro?}"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def check_user
    redirect_to root_url, notice: 'Please sign up or register' unless current_user
  end

  def product_params
    params.require(:product).permit(:title, :description, :image, :shop_title)
  end
end
