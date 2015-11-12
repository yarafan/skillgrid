require 'net/http'
require 'json'
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :check_user, except: [:index, :show]
  before_action :check_email, only: [:buy_product]

  def index
    ordinary_products = Product.ordinary
    pro_products = Product.pro
    @products = { ordinary:  ordinary_products, pro: pro_products }
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

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
    product = Product.find(params[:id])
    record = json_record
    if check_record(record)
      image_path = json_image(record['thumbnailUrl'])
      mail_user(current_user, product, image_path)
      notify_admins
    else
      MailSender.report_admins(current_user.email).deliver_now
      redirect_to products_path, notice: 'ThumbnailUrl is bigger than url'
    end
  end

  private

  def external_request(url)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host) do |http|
      http.get(uri.request_uri)
    end
  end

  def external_post(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    http.request(request)
  end

  def mail_user(user, product, image_path)
    user_mail = MailSender.buy_success(user, product)
    user_mail.attachments[File.basename(image_path)] = File.read(image_path)
    user_mail.deliver_now
    File.delete(image_path)
  end

  def notify_admins
    response = external_post('http://jsonplaceholder.typicode.com/todos')
    record = JSON.parse(response.body)
    MailSender.mail_admins(record['id']).deliver_now
  end

  def json_image(url)
    response = external_request(url)
    path = "#{Rails.root}/tmp/#{last_part(url)}.png"
    write_image(path, response.body) if response.code == '200'
    write_image(path, external_request(response['location']).body) if response.code == '301'
    redirect_to products_path, notice: 'Unable to write image' unless response.code == '200' || response.code == '301'
    path
  end

  def write_image(path, body)
    File.open(path, 'w+b') do |f|
      f.puts(body)
    end
  end

  def check_record(record)
    thumb = last_part(record['thumbnailUrl'])
    url = last_part(record['url'])
    thumb > url
  end

  def last_part(string)
    match = %r{.+/(.+)\Z}.match(string)
    match[1]
  end

  def json_record
    response = external_request('http://jsonplaceholder.typicode.com/photos/')
    return JSON.parse(response.body).sample if response.code == '200'
    return JSON.parse(external_request(response['location']).body).sample if response.code == '301'
    redirect_to products_path, notice: 'Unnable to get image' unless response.code == '200' || response.code == '301'
  end

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
