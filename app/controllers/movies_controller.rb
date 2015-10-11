class MoviesController < ApplicationController

  # See Section 4.5: Strong Parameters below for an explanation of this method:
  # http://guides.rubyonrails.org/action_controller_overview.html
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @all_ratings = Movie.all_ratings
    
    if( params[:ratings].nil? && session[:ratings].nil? ) then
      @filter_ratings = @all_ratings
    else
      @filter_ratings = params[:ratings] || session[:ratings]
    end
    
    sort_by = params[:sort_by] || session[:sort_by]
    
    if ( params[:sort_by] != session[:sort_by] ) then
      session[:sort_by] = sort_by
      redirect_to :sort_by => sort_by, :ratings => @filter_ratings and return
    end

    if ( params[:ratings] != session[:ratings] ) then
      session[:sort_by] = sort_by
      session[:ratings] = @filter_ratings
      redirect_to :sort_by => sort_by, :ratings => @filter_ratings and return
    end
    
    if( sort_by == 'release_date' ) then
      @release_header = 'hilite'
    else
      @title_header = 'hilite'
    end
    
    if( @filter_ratings.is_a?(Hash) ) then
      array_ratings = @filter_ratings.keys
    else
      array_ratings = @filter_ratings
    end
    
    @movies = Movie.where(rating: array_ratings).order(params[:sort_by])
    
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

  private :movie_params
  
end
