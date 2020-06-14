class SessionsController < ApplicationController

    def new 
        @dog = Dog.new
    end

    def omniauth
        @dog = Dog.from_omniauth(auth)
        @dog.save
        session[:user_id] = @dog.id
        redirect_to root_path
      end
      
    def create
        @dog = Dog.find_by(email: params[:dog][:email])
        
        if @dog && @dog.authenticate(params[:dog][:password])
            session[:user_id] = @dog.id
            redirect_to dog_path(@dog)
        else
            redirect_to root_path
        end
    end    

    def destroy   
        if current_user
            session.delete :user_id
        redirect_to root_path
    end    

      private
      
      def auth
        request.env['omniauth.auth']
      end
  
end



