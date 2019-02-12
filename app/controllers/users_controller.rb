class UsersController < ApplicationController
    before_action :authorized
    skip_before_action :authorized, only: [:new, :create]

   def new
        flash[:error]=[]
        @user=User.new
   end
   
   def create
        user=User.new(user_params)
        byebug
        if params[:user][:password] == params[:user][:confirm_password]
            user.save
            session[:user_id]=user.id
            redirect_to "/home/users/#{user.id}"
        else
            flash[:error]=[]
            flash[:error]=user.errors.full_messages
            render :new
        end
   end

   def show
      @user=User.find(params[:id])
   end

   def edit
     @user=User.find(params[:id])
   end

   def update
      @user=User.find(params[:id])
      if @user.valid? && params[:user][:password] == params[:user][:confirm_password]
        @user.update(user_params)
        redirect_to "/home/users/#{@user.id}"
    else
        flash[:error]=[]
        flash[:error]=user.errors.full_messages
        render :new
    end
   end

   def destroy
      User.find(params[:id]).destroy
      session.delete :user_id
      redirect_to "/home"
   end

   private

   def user_params
     params.require(:user).permit(:first_name, :last_name, :email, :display_name, :password)
   end
end
