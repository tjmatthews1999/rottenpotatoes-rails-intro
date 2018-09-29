class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #fill all_ratings with all possible ratings
    @all_ratings = Movie.ratings
    #assign variable to method result
   
        
    if chosen != nil
        session[:ratings] = chosen
        @chosen_ratings = session[:ratings]
    else
        if session[:ratings] 
            @chosen_ratings = session[:ratings]
        else
            @chosen_ratings = @all_ratings
        end
    end
    
    
    #order movies and highlight the header indicated by the clicked parameter
    case params[:clicked]
    when 'title'
        session[:is_title_hilite] = "hilite"
        session[:clicked] = 'title'
    when'release'
        session[:is_release_hilite] = "hilite"
        session[:clicked] = 'release_date'
    end
    
    if not session[:clicked]
        session[:clicked] = 'id'
    end
    
    @is_title_hilite = session[:is_title_hilite]
    @is_release_hilite = session[:is_release_hilite]
    
    @movies = Movie.where(rating: @chosen_ratings).order(session[:clicked])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def chosen
    #fill chosen ratings object
    if params[:ratings]
        params[:ratings].keys
    else
        nil
    end
  end
end
