require 'aws-sdk'

s3 = Aws::S3::Resource.new(
  credentials: Aws::Credentials.new(ENV['S3_ACCESS_ID'], ENV['S3_SECRET_KEY']),
  region: 'us-east-1'
)

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
  @stories = Story.all.limit(5)
  erb :index
end

get '/stories' do
 @stories = Story.all.limit(5)
 erb :'stories/index'
end

get '/stories/join' do 
  if logged_in?
    oldest_incomplete_story = Story.oldest_incomplete_story(current_user.id)
    if !oldest_incomplete_story
      id = Story.create.id
    else
      id = oldest_incomplete_story.id 
    end
    story = Story.find(id)
    redirect "/stories/#{id}/play"
  else
    redirect 'auth/no_login' 
  end
end

get '/auth/no_login' do
  erb :'auth/not_logged_in'
end

post '/stories/new' do
  if logged_in?
    @story = Story.create
    Text.create(caption: params[:caption], story_id: @story.id, user_id: current_user.id)
    redirect "/stories/#{@story.id}"
  else
    redirect '/auth/no_login'
  end
end

get '/stories/:id' do |id|
 @story = Story.find(id)
 erb :'stories/show'
end

get '/users/new' do 
  erb :'users/new'
end

post "/signup" do
    @user = User.new(:name => params[:name], :image => params[:image], :email => params[:email], :password => params[:password])
    if @user.save
        redirect "/"
    else
        redirect "/auth/no_login"
    end
end



get '/users/:user_id' do |id|
  @user = User.find(id)
  erb :'users/show'
end

get '/stories/:id/play' do |id|
  redirect '/auth/no_login' if !logged_in?
  @story = Story.find(id)
  if !@story
    @story = Story.create
  end
  redirect "/stories/#{@story.id}" if @story.complete
  erb :'stories/play'
end

post '/users/login' do
  @user = User.find_by(:name => params[:name])
  if @user && @user.authenticate(params[:password])
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}"
  else
    redirect "/"
  end
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
    filepath = "/uploads/drawings/image_id_#{@image.id}_story_id_#{@image.story_id}_user_id_#{current_user.id}.png"
    file = File.open("public#{filepath}", 'wb')
    file.write(data)
    file.close
    @image.update(image_path: "image_id_#{@image.id}_story_id_#{@image.story_id}_user_id_#{current_user.id}.png")
    obj = s3.bucket(ENV['S3_BUCKET_NAME']).object("image_id_#{@image.id}_story_id_#{@image.story_id}_user_id_#{current_user.id}.png")
    obj.upload_file("./public/uploads/drawings/image_id_#{@image.id}_story_id_#{@image.story_id}_user_id_#{current_user.id}.png", acl:'public-read')
    redirect "/stories/#{params[:id]}"
  else
    redirect '/'  
  end
  story = Story.find(params[:id])
  story.complete?
end

post '/stories/:id/rating' do 
  @story = Story.find(params[:id])
  @rating = Rating.create(story_id: params[:id], user_id: current_user.id, score: params[:rating])
  redirect "/stories/#{params[:id]}"
end








