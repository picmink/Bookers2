class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
    
    def show
        @book = Book.find(params[:id])
        @user = @book.user
        @books =Book.new
    end 
    
    def edit
        is_matching_login_user
        @book = Book.find(params[:id])
    end 
    
    def index
        @books = Book.all
        @book = Book.new
        @user = current_user
    end 
    
    def create
        @book = Book.new(book_params)
        @book.user_id = current_user.id
        if @book.save
           redirect_to book_path(@book.id)
        else
            @books = Book.all
            @user = current_user
            render :index
        end 
    end 
    
    def update
        is_matching_login_user
        @book = Book.find(params[:id])
        if @book.update(book_params)
           flash[:notice] = "You have updated book successfully." 
           redirect_to book_path(@book.id)
        end 
    end 
    
    def destroy
        is_matching_login_user
        book = Book.find(params[:id])
        book.destroy
        redirect_to books_path(book.id)
    end 
    
    
    private
    def book_params
        params.require(:book).permit(:title, :opinion)
    end 
    
    def is_matching_login_user
        book = Book.find(params[:id])
        unless book.user.id == current_user.id
          redirect_to books_path
        end
    end
    
end
