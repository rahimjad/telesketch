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

get '/stories/join' do 
  # binding.pry
  if logged_in?
    id = Story.oldest_incomplete_story(current_user.id).id
    story = Story.find(id)
    redirect "/stories/#{id}/play"
  else
    redirect '/'  
  end
end

post '/stories/new' do
  if logged_in?
    new_story = Story.create
    new_story_id = new_story.id
    Text.create(caption: params[:caption], story_id: new_story_id, user_id: current_user.id)
  else
    redirect '/'
  end
  redirect "/stories/#{new_story_id}"
end

get '/stories/:id' do |id|
 @story = Story.find(id)
 erb :'stories/show'
end

get '/users/:user_id' do |id|\
  @user = User.find(id)
  erb :'users/show'
end

get '/stories/:id/play' do |id|
  redirect '/' if !logged_in? 
  @story = Story.find(id)
  redirect '/' if @story.complete
  # binding.pry
  erb :'stories/play'
end

post '/users/login' do
  session[:user_id] = params[:user_id]
  redirect "/users/#{params[:user_id]}" 
end

post '/users/logout' do
  session[:user_id] = nil
  redirect '/'
end

post '/stories/:id/play' do |id|
  case params[:type]
  when "Text"
    Text.create(caption: params[:caption], story_id: params[:id], user_id: current_user.id)
    redirect "/stories/#{params[:id]}"
  when "Image"
    body = params[:data].to_s
    b64 = body.split(',')[1]
    data = Base64.decode64(b64)
    @image = Image.create(image_path: "default", story_id: params[:id], user_id: current_user.id)
    filepath = "public/uploads/drawings/image_id_#{@image.id}_story_id_#{@image.story_id}_user_id_#{current_user.id}.png"
    file = File.open(filepath, 'wb')
    file.write(data)
    file.close
    @image.update(image_path: filepath)
  else
    redirect '/'  
  end
  story = Story.find(params[:id])
  story.complete?
end


post '/stories/:id/rating' do
end


