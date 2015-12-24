class BuyProduct
  def initialize(user, product)
    @user = user
    @product = product
  end

  def exec
    record = json_record
    if check_record(record)
      image_path = json_image(record['thumbnailUrl'])
      mail_user(@user, image_path)
      notify_admins
    else
      AdminSender.report_admins(@user.email).deliver_now
      fail 'Thumbnail is bigger then url'
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

  def mail_user(user, image_path)
    user_mail = UserSender.buy_success(user, @product)
    user_mail.attachments[File.basename(image_path)] = File.read(image_path)
    user_mail.deliver_now
    File.delete(image_path)
  end

  def notify_admins
    response = external_post('http://jsonplaceholder.typicode.com/todos')
    record = JSON.parse(response.body)
    AdminSender.mail_admins(record['id']).deliver_now
  end

  def json_image(url)
    response = external_request(url)
    path = "#{Rails.root}/tmp/#{last_part(url)}.png"
    write_image(path, response.body) if response.code == '200'
    write_image(path, external_request(response['location']).body) if response.code == '301'
    fail 'Unable to write image' unless response.code == '200' || response.code == '301'
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
    fail 'Unable to get image' unless response.code == '200' || response.code == '301'
  end
end
