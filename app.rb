require 'sinatra'
require 'sinatra/content_for'
require "sinatra/json"
require 'tilt/erubis'

require_relative "database"

configure do
  enable :sessions
  set :erb, :escape_html => true
end

configure(:development) do
  require 'sinatra/reloader'
  also_reload "database.rb"
end

helpers do
  # Sort by not started, in progress, finished
  def sort_by_status(projects)
    not_started = []
    in_progress = []
    finished = []
    
    projects.each do |project|
      case project[:status]
        when 'Not Started'
          not_started << project
        when 'In Progress'
          in_progress << project
        when 'Finished'
          finished << project
      end
    end
    
    not_started + in_progress + finished
  end
  
  # add class based off of status
  def add_class(project)
    case project[:status]
      when 'Not Started'
        'not_started'
      when 'In Progress'
        'in_progress'
      when 'Finished'
        'finished'
    end
  end
end

before do
  @db = Database.new
end

after do
  @db.disconnect
end

get '/' do
  redirect '/projects'
end

get '/projects' do
  @title = "Mesa's Crochet Projects"
  @projects = @db.get_projects
  
  erb :projects
end

get '/projects/new' do
  erb :new
end

post '/projects/new' do
  name = params[:name]
  yarn = params[:yarn]
  colors = params[:colors]
  weight = params[:weight]
  making_for = params[:for]
  pattern = params[:pattern]
  pattern_link = params[:link]
  hook = params[:hook]
  status = params[:status]
  notes = params[:notes]
  
  @db.new_project(name, yarn, colors, weight, making_for, pattern, pattern_link, hook, status, notes)
  
  session[:success] = "'#{name}' project successfully added"
  redirect '/projects'
end

get '/projects/:id' do
  @id = params[:id].to_i
  @project = @db.get_project_info(@id).first
  
  erb :project
end

get '/projects/:id/edit' do
  @id = params[:id].to_i
  @project = @db.get_project_info(@id).first
  
  erb :edit
end

post '/projects/:id/edit' do
  id = params[:id]
  name = params[:name]
  yarn = params[:yarn]
  colors = params[:colors]
  weight = params[:weight]
  making_for = params[:for]
  pattern = params[:pattern]
  pattern_link = params[:link]
  hook = params[:hook]
  status = params[:status]
  notes = params[:notes]
  
  @db.update_project(id, name, yarn, colors, weight, making_for, pattern, pattern_link, hook, status, notes)
  
  session[:success] = "'#{name}' project successfully updated"
  redirect "/projects/#{id}"
end

get '/projects/:id/copy' do
  @id = params[:id].to_i
  @project = @db.get_project_info(@id).first
  
  erb :copy
end

post '/projects/:id/image' do
  id = params[:id]
  file = params[:file][:tempfile]
  filename = params[:file][:filename]
  path = "/project_images/#{filename}"
  
  File.open("public/#{path}", 'wb') do |f|
    f.write(file.read)
  end
  
  @db.update_project_image(id, path)
  session[:success] = "Image successfully added"
  redirect "/projects/#{id}"
end

post '/projects/:id/update_image' do
  id = params[:id]
  old_file = params[:old_image]
  file = params[:file][:tempfile]
  filename = params[:file][:filename]
  path = "/project_images/#{filename}"
  
  File.open("public/#{path}", 'wb') do |f|
    f.write(file.read)
  end
  
  @db.update_project_image(id, path)
  session[:success] = "Image successfully updated"
  redirect "/projects/#{id}"
end

post '/projects/:id/delete_image' do
  id = params[:id]
  old_file = params[:old_image]
  
  File.delete("public/#{old_file}")
  
  @db.update_project_image(id, nil)
  session[:success] = "Image successfully removed"
  redirect "/projects/#{id}"
end

post '/projects/:id/complete' do
  id = params[:id]
  @db.set_project_complete(id)
  session[:success] = "Project finished, nice job!"
  redirect "/projects/#{id}"
end

post '/projects/:id/delete' do
  id = params[:id]
  project_image = params[:project_image]
  puts id
  p project_image
  
  File.delete("public/#{project_image}") if project_image != ''
  @db.delete_project(id)
  session[:success] = "Project successfully deleted"
  redirect "/projects"
end

# ----------------- AJAX Requests

post '/projects/:id/update_pattern' do
  id = params[:id]
  pattern = params[:pattern]
  
  @db.update_pattern(id, pattern)
end

post '/projects/:id/update_notes' do
  id = params[:id]
  notes = params[:notes]
  
  @db.update_notes(id, notes)
end