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
   
    #chosen_ratings is final parameter used for determining which ratings to include in list
    #logic below determines whether to fill that variable with current parameters or from session
    if chosen != nil
        #parameters exist currently, so save them into session and chosen_ratings
        session[:ratings] = chosen
        @chosen_ratings = session[:ratings]
    else
        if session[:ratings] 
           #no parameters (all ratings unchecked), so fill from session if there is a value in it
           @chosen_ratings = session[:ratings]
        else
            #no checked boxes and no session records, so default to checking all
            @chosen_ratings = @all_ratings
        end
    end
    
    
    #store values in session that save which column to hilite and sort by
    case params[:clicked]
    when 'title'
        session[:is_title_hilite] = "hilite"
        #make sure to remove hilite from other header in session
        session[:is_release_hilite] = ""
        session[:clicked] = 'title'
    when'release'
        session[:is_release_hilite] = "hilite"
        #make sure to remove hilite from other header in session
        session[:is_title_hilite] = ""
        session[:clicked] = 'release_date'
    end
    
    #if no session record exists to indicate sort column, default to sorting by movie id
    if not session[:clicked]
        session[:clicked] = 'id'
    end
    
    #apply session values to current variables
    @is_title_hilite = session[:is_title_hilite]
    @is_release_hilite = session[:is_release_hilite]
    
    #final movie list sort by column and/or ratings
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
    #determine if there are active rating parameters and return them if there are
    if params[:ratings]
        params[:ratings].keys
    else
        nil
    end
  end
end
