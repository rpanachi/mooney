class CategoriesController < ApplicationController

  before_filter :load_defaults

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  def new
    @category = Category.new(:user => current_user)
    respond_to do |format|
      if Category.can_create?(current_user)
        format.html # new.html.erb
      else
        flash[:error] = "Limite de 80 categorias por usuário atingido!"
        format.html { redirect_to categories_url }
      end
    end
  end

  def edit
    @category = Category.from_user(current_user).find(params[:id])
    @categories.delete_if {|c| c == @category }
  end

  def create
    @category = Category.new(params[:category])
    @category.user = current_user

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Categoria criada com sucesso.'
        format.html { redirect_to categories_url }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        load_defaults
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @category = Category.from_user(current_user).find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Categoria atualizada com sucesso.'
        format.html { redirect_to categories_url }
        format.xml  { head :ok }
      else
        load_defaults
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @category = Category.from_user(current_user).find(params[:id])
    @category.destroy

    respond_to do |format|
      flash[:notice] = 'Categoria excluída com sucesso'
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end

  def up
    @category = Category.from_user(current_user).find(params[:category_id])
    @category.move_up if @category
  
    respond_to do |format|
      flash[:notice] = 'Categoria movida para cima com sucesso'
      format.html { redirect_to categories_url }
      format.xml  { head :ok }
    end
  end

  def down
    @category = Category.from_user(current_user).find(params[:category_id])
    @category.move_down if @category

    respond_to do |format|
      flash[:notice] = 'Categoria movida para baixo com sucesso'
      format.html { redirect_to categories_url }
      format.xml  { head :ok }
    end
  end

  def create_defaults
    if current_user.categories.empty?
      current_user.load_categories
      flash[:notice] = "Categorias padrões criadas com sucesso"
    else
      flash[:notice] = "Categorias padrões já foram criadas!"
    end
    redirect_to categories_url
  end

  private 
  def load_defaults
    @categories = Category.from_user(current_user).roots.find(:all, :include => :children)
  end
end
