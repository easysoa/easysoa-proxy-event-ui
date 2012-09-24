require 'oauth'

class UsersController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        # self.oauthconnect
        return redirect_to :action => :connexion
        # format.html { redirect_to @user, notice: 'User was successfully created.' }
        #format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  ###################
  # @role send the authentication page
  # GET /users/connexion
  # GET /users/connexion.json
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
  # POST /users/connexion
  # POST /users/connexion.json
  def createconnexion
    @match = nil
    username = params[:username]
    password = params[:password]

#    session[:username] = username
#   session[:password] = password

    @user = User.find_all_by_username(username)
    if (@user.empty?)
      return redirect_to :action => :new
    end
    if (@user[0].password==password)
      session[:user_id] = @user[0].id
      return redirect_to :action => :welcome
    else
      #mauvais password
    end

  end


  # @role Oauthconnect get the nuxeo request token
  # Redirect the user on te Nuxeo authorization page
  def oauthconnect
    @request_token = @@consumer.get_request_token(:oauth_callback => "http://localhost:3000/users/callback")
    session[:request_token] = @request_token
    redirect_to @request_token.authorize_url
  end


  # @role This method get the access token
  # sent by Nuxeo after authentication
  # GET users/callback
  # GET users/callback.json
  def callback

    @request_token = session[:request_token]
    @access_token = @request_token.get_access_token
    @nuxeo_token = Nuxeotoken.new
    @nuxeo_token.token=@access_token.token;
    @nuxeo_token.secret=@access_token.secret;
    @nuxeo_token.user = User.find(session[:user_id])
    @nuxeo_token.save


    # pour le garder en session session[:access_token] = @access_token

    self.nuxeocall and return
    #redirect_to :action => :nuxeocall and return

    ##############
  end

  # @role Check if the user authenticate in  the rails application and the user connected in nuxeo is the same.
  def nuxeocall

    @user = User.find(session[:user_id])
    @nuxeo_token = @user.nuxeotoken
    @accesstoken = OAuth::AccessToken.new(@@consumer, @nuxeo_token.token, @nuxeo_token.secret)


    @result = @@consumer.request(:post,
                                 "/site/automation/UserWorkspace.Get", #url to query
                                 @access_token, #accesstoken
                                 {},
                                 '{"params":{"query":"SELECT * FROM Document WHERE ecm:path=/default-domain/UserWorkspaces/@{CurrentUser.name}"}}',
                                 {'Content-Type' => 'application/json+nxrequest; charset=UTF-8',
                                  'Accept' => 'application/json+nxentity, */*',
                                  'X-NXDocumentProperties' => '*'}
    )

    @parsed_json = ActiveSupport::JSON.decode(@result.body)
    @nuxeo_username = @parsed_json["properties"]['dc:creator'] #["dc:contributors"][0]

    if @user.username!= @nuxeo_username
      @nuxeo_token.destroy
      #@@state="f"
      #use the same username for both system
      redirect_to :action => :connexion and return

    else

      redirect_to :action => :welcome and return
    end

  end

  # @role Redirect the authenticate user to the  welcome page
  # GET /welcome
  # GET /welcome.json
  def welcome
    @user = User.find(session[:user_id])
    @nuxeo_token = @user.nuxeotoken

    if (@nuxeo_token.nil?)
      return self.oauthconnect

    end

    ##############

    @accesstoken = OAuth::AccessToken.new(@@consumer, @nuxeo_token.token, @nuxeo_token.secret)

    @result = @@consumer.request(:post,
                                 "/site/automation/UserWorkspace.Get", #url to query
                                 @accesstoken, #accesstoken
                                 {},
                                 '{"params":{"query":"SELECT * FROM Document WHERE ecm:path=/default-domain/UserWorkspaces/@{CurrentUser.name}"}}',
                                 {'Content-Type' => 'application/json+nxrequest; charset=UTF-8',
                                  'Accept' => 'application/json+nxentity, */*',
                                  'X-NXDocumentProperties' => '*'}
    )

    ##################

    respond_to do |format|
      format.html # welcome.html.erb
      format.json { render json: @user }
    end

  end

  # @role get all the nuxeo services
  # GET /nuxeo-services-list
  # GET /nuxeo-services-list.json
  def nuxeoserviceslist
    user_id = session[:user_id]
    @tab = self.getnuxeoservicelist

    respond_to do |format|
      format.html # nuxeoserviceslist.html.erb
      format.json { render json :@services }
      format.json { render json :@tab }
      format.json { render json: @user }
    end
  end


  # @role form return a new subscription form
  # GET /newsubscription
  # GET /newsubscription.json
  def newsubscription

    #page de souscription
    redirect_to :controller => "subscriptions", :action => "new"
  end

  # @role Show the details of the selected service
  # GET /showservice
  # GET /showservice.json
  def showservice
    @user = User.find(session[:user_id])
    @service = params[:service]
    respond_to do |format|
      format.html # showservice.html.erb
      format.json { render json :@service }
      format.json { render json: @user }
    end
  end


  # @role Show the details of the selected service
  # GET /listsubscripion
  # GET /listsubscription.json
  def listsubscriptions
    @user = User.find(session[:user_id])
    @subscriptions = @user.subscriptions
    respond_to do |format|
      format.html # listsubscripion.html.erb
      format.json { render json: @subscriptions }
    end
  end


end
