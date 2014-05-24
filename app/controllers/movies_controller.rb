class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.AllowableRatings
    @ratings = params[:ratings]
    @sort = params[:sort_by]
    if session[:sort_by].nil? or (!session[:sort_by].eql?(@sort) and !@sort.nil?)
	session[:sort_by] = @sort

    end
    if session[:ratings].nil? or (!session[:ratings].eql?(@ratings) and !@ratings.nil?)
        session[:ratings] = @ratings

    end
    if session[:ratings].present? and session[:sort_by].present?
        @movies = Movie.where(:rating => session[:ratings].keys).order(session[:sort_by]).all
        

    elsif session[:ratings].present?
        @movies = Movie.where(:rating => session[:ratings].keys).all
        

    elsif session[:sort_by].present?
       	@movies = Movie.order(session[:sort_by]).all
        

    else
        @movies = Movie.all
 
    end

    if (!session[:sort_by].nil? or !session[:ratings].nil?) and @sort.nil? and @ratings.nil?
	redirect_to movies_path(:ratings => session[:ratings], :sort_by => session[:sort_by])
    end
    @movies
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:ratings => session[:ratings], :sort_by => session[:sort_by])
  end	

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movies_path(@movie, :ratings => session[:ratings], :sort_by => session[:sort_by])
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(:ratings => session[:ratings], :sort_by => session[:sort_by])
  end

end
