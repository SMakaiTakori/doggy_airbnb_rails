class ReservationsController < ApplicationController

    before_action :logged_in, :current_user

    def index    
        @reservation= Reservation.all
        @dog = Dog.find_by(id: session[:user_id])                 
    end

    def new         
        @reservation= Reservation.new 
        @reservation.hotel_id= params[:hotel_id]
        @reservation.dog_id = session[:user_id]  
        @dog = Dog.find_by(id: session[:user_id])
    end

    def create       
        @reservation= Reservation.new(reservation_params)
        @dog = Dog.find_by(id: session[:user_id])        
        @dog.update(dog_params[:dog]) 
        @reservation.dog = @dog       
        @reservation.save  

        redirect_to dog_reservation_path(@reservation.dog, @reservation)      
    end

    def show
        find_by_id            
        flash[:alert] = "Your Reservation has been confirmed."  
    end

    def edit
        if current_user 
            find_by_id
        else
            render :index
        end
    end

    def update
        find_by_id
        @dog.update(dog_params[:dog]) 
        @reservation.dog = @dog

        if @reservation.update(reservation_params)
            redirect_to dog_reservation_path(@reservation.dog, @reservation)
        else
            render :edit
        end
    end

    def destroy
        find_by_id  
        @reservation.destroy
        flash[:alert] = "Your Reservation has been cancelled"

        redirect_to dog_path(@dog)
    end    

    private
     
    def reservation_params               
        params.require(:reservation).permit(:date, :time, :hotel_id)         
    end

    def dog_params 
        params.require(:reservation).permit(dog: [             
            :age,               
            :email,
            :breed,
            :owner,
            :phone,
            :biography          
        ]
    )
    end

    def find_by_id
        @reservation = Reservation.find_by(id: params[:id])
        @dog = Dog.find_by(id: session[:user_id])     
    end 

end
