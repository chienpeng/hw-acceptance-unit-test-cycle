class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default

    @movies = Movie.order(:release_date)
  end

  def index
    #@movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show = Array(nil)
    session[:ratings] = params[:ratings] if params[:sort] == nil
    session[:sort] = params[:sort] if params[:ratings] == nil
    
    if params[:show] == "1"
      @movies = Movie.with_ratings(session[:ratings]).order(session[:sort])
    elsif params[:sort].nil?
      @movies = Movie.with_ratings(session[:ratings])
    else
      @movies = Movie.with_ratings(session[:ratings]).order(params[:sort])
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
  
  def similar
    @movie = Movie.find(params[:id])
    if @movie.director.blank?
      flash[:notice] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    else
      @movies = Movie.find_movies_with_same_director(@movie.director)
    end
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
