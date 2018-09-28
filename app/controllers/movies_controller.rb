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
    #assign variable to method result
    @chosen_ratings = chosen
    
    #order movies and highlight the header indicated by the clicked parameter
    case params[:clicked]
    when 'title'
        @is_title_hilite = "hilite"
        @movies = Movie.where(rating: @chosen_ratings).order('title')
    when'release'
        @is_release_hilite = "hilite"
        @movies = Movie.where(rating: @chosen_ratings).order('release_date')
    else
        @movies = Movie.where(rating: @chosen_ratings)
    end
    
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
    #determine selected ratings
    if params(:ratingslist)
        params(:ratingslist).keys
    else
        Movie.ratings
    end
  end
end
