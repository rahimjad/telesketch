helpers do

 def current_user 
   unless session[:user_id].nil?
     User.find(session[:user_id])
   end
 end

 def logged_in?
   !!current_user
 end

 def render_image_play
   erb :'_image_capture'  
 end

 def render_text_play
   erb :'_text_capture' 
 end

end

get '/' do
 erb :index
end

get '/stories' do
 @stories = Story.all
 erb :'stories/index'
end

get '/stories/:id' do |id|
 @story = Story.find(id)
 erb :'stories/show'
end

get '/users/:id' do |id|
  @user = User.find(id)
  erb :'users/show'
end

get '/stories/:id/play' do |id|
  # redirect '/' if !logged_in?
  @story = Story.find(id)
  erb :'stories/play'
end


post '/stories/:id/play/' do

end

post '/users/login' do
 session[:user_id] = params[:user_id]
 redirect '/users/:id' 
end

post '/stories/:id/rating' do
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