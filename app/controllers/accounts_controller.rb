class AccountsController < ApplicationController

  def index
    @accounts = Account.from_user(current_user).all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  def new
    @account = Account.new
    @account.user = current_user

    respond_to do |format|
      if Account.can_create?(current_user)
        format.html # new.html.erb
      else
        flash[:error] = "Limite de 5 contas por usuário atingido!"
        format.html { redirect_to accounts_path }
      end
    end
  end

  def edit
    @account = Account.from_user(current_user).find(params[:id])
  end

  def create
    @account = Account.new(params[:account])
    @account.user = current_user

    respond_to do |format|
      if @account.save
        flash[:notice] = 'Conta criada com sucesso'
        format.html { redirect_to accounts_url }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @account = Account.from_user(current_user).find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Conta atualizada com sucesso'
        format.html { redirect_to accounts_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @account = Account.from_user(current_user).find(params[:id])
    @account.destroy

    respond_to do |format|
      flash[:notice] = 'Conta excluída com sucesso'
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end

  def create_defaults
    if current_user.accounts.empty?
      current_user.load_accounts
      flash[:notice] = "Contas padrões criadas com sucesso"
    else
      flash[:notice] = "Contas padrões já foram criadas!"
    end
    redirect_to accounts_url
  end
end
