require 'base64'

helpers do

  def current_user 
    unless session[:user_id].nil?
      User.find(session[:user_id])
    end
  end

  def logged_in?
    !!current_user
  end
end

get '/' do
  erb :index
end

get '/stories' do

end

get '/stories/:id' do
end

get '/users/:id' do
end

get '/stories/:id/play' do

end

post '/stories/:id/play' do
end

post '/users/login' do
  session[:user_id] = params[:user_id]
  redirect '/users/:id' 
end

post '/stories/:id/rating' do
end

post '/stories/new' do 
end

post '/image/store' do
  body = request.body.read.to_s
  b64 = body.split(',')[1]#.gsub('+', ' ')
  data = Base64.decode64(b64)

  file = File.open('public/uploads/temp.png', 'wb')

  file.write(data)
  file.close


  "ok"
end