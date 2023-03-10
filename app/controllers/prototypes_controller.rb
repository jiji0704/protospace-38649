class PrototypesController < ApplicationController
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]
  before_action :move_to_index, except: [:index, :show]
  before_action :ensure_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index ]

  def index
    @prototypes = Prototype.all
  end
  
  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user) 
  end

  def edit
  end

  def update
    @prototype.update_attributes(prototype_params)
    if @prototype.save
      redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    @prototype.destroy
    redirect_to action: :index
  end


  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept,:image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to '/users/sign_in'
    end
  end
  
  def ensure_user
    if @prototype.user_id != current_user.id
      redirect_to action: :index
    end
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
  
end
