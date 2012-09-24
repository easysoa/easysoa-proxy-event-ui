class UnsecureareaController < ApplicationController

  ###################
  # @role send the authentication page
  # GET /connexion
  # GET /connexion.json
  def connexion
    @user = User.new
    @state = session[:state]

    respond_to do |format|
      format.html # connexion.html.erb
      format.json { render json: @user }
      format.json { render json: @state.to_json }
    end
  end

  #@role get the authentication form request and treat it
  # POST /connexion
  # POST /connexion.json
  def createconnexion
    @match = nil
    username = params[:username]
    password = params[:password]

    @user = User.find_all_by_username(username)
    if (@user.empty?)
      @user = User.new
      session[:state] = 0
      render 'connexion' and return
    end
    if (@user[0].password==password)
      session[:user_id] = @user[0].id
      session[:user_role_id] = @user[0].role.id
      session[:username] = @user[0].username
      redirect_to :controller => 'securearea', :action => 'welcome' and return
    else
      #mauvais password 1    login different 2
      session[:state] = 1

      redirect_to(:action => 'connexion') and return
    end
  end

  # GET /register
  # GET /register.json
  def register
    if (params[:user].nil?)
      @user = User.new
    else
      @user = User.new(params[:user])
      if !@user.valid?
        return
        respond_to do |format|
          format.html # register.html.erb
          format.json { render json: @user }
        end
      else
        @role = Role.where(:title => 'BusinessUser')
        @user.role = @role[0]
        @user.save
        redirect_to :action => 'userregistered' and return
      end
    end

    respond_to do |format|
      format.html # register.html.erb
      format.json { render json: @user }
    end
  end

  def userregistered
    respond_to do |format|
      format.html # userregistered.html.erb
    end
  end

  def disconnect
    session[:user_id]=nil
    session[:user_role_id]=nil
    session[:state]=nil
  end
end

