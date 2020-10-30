class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :new]
  
  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new  #newアクションでデータの入れ物を作成
  end

  def create
    @prototype = Prototype.new(prototype_params)   #リクエストのパラメータを使ってデータを作成
    if @prototype.save
      redirect_to root_path#(@prototype)
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless current_user.id == @prototype.user.id
      redirect_to action: :index
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
end
