class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :check_user, except: [:index, :show]
  before_action :check_email, only: [:buy_product]

  def index
    @products = current_user.nil? ? Product.ordinary : Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    redirect_to products_url unless current_user
    @product = current_user.products.create(product_params)
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

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

  def buy_product
    @product = set_product
    BuyProduct.new(current_user, @product).exec
  rescue RuntimeError => e
    render 'buy_error', locals: { message: e.message }
  end

  private

  def check_email
    match = /.+@.+\.(.+)/.match(current_user.email)
    flash[:notice] = 'Users with \'com\' emails prohibited from buying'
    MailSender.report_admins(current_user.email).deliver_now && redirect_to(products_path) if match[1] == 'com'
  end

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
