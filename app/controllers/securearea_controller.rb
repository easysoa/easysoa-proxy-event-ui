class SecureareaController < ApplicationController

  layout 'securearea'
  before_filter :require_login

  def require_login
    if ((session[:user_id].nil?)||(session[:user_role_id].nil?))
      flash[:error] = "You must log in to access this section"
      #redirect_to :controller => 'unsecurearea', :action => 'connexion'
      return
      respond_to do |format|
        format.html # connexion.html.erb
        format.json { render json: @user }
      end
    end
  end

  def require_PowerUser_login
    if ((session[:user_id].nil?)||(session[:user_role_id].to_i!=1))
      flash[:error] = "You must be logged in as Power User to access this section"
      #redirect_to :controller => 'unsecurearea', :action => 'connexion'
      return
      respond_to do |format|
        format.html # connexion.html.erb
        format.json { render json: @user }
      end
    end
  end

  def getnuxeoservicelist

    @user = User.find(session[:user_id])
    @nuxeo_token = @user.nuxeotoken
    @accesstoken = OAuth::AccessToken.new(@@consumer, @nuxeo_token.token, @nuxeo_token.secret)
    @result = self.getnuxeoservices(@accesstoken)
    @service1 = ActiveSupport::JSON.decode(@result.body)
    @services = @service1["entries"]

    #Je filtre ici le tableau de tableau en retirant le service selectionné
    size = @services.size
    i=0
    j=0
    @tab = Array.new
    while i<size

      @tab[i] = Array.new
      @serv = @services[i]

      @uid = @serv["uid"]
      @title = @serv["title"]

      @tab[j][0] = @title
      @tab[j][1] = @uid
      i+=1
      j+=1
    end
  end

  # GET /secureArea/welcome
  # GET /secureArea/welcome.json
  def welcome
    begin
      @user = User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :controller => 'unsecurearea', :action => 'connexion' and return
    end
    @nuxeo_token = @user.nuxeotoken
    if (@nuxeo_token.nil?)
      return self.oauthconnect
    end

    @accesstoken = OAuth::AccessToken.new(@@consumer, @nuxeo_token.token, @nuxeo_token.secret)
    @result = self.getnuxeocurrentuser(@accesstoken)

    session[:state] = nil
    respond_to do |format|
      # format.html { render :template => "secure_area/welcome" }
      format.html # welcome.html.erb
      format.json { render json: @user }
    end

  end

  # GET /nuxeoservices
  # GET /nuxeoservices.json
  def nuxeoservices
    user_id = session[:user_id]
    @tab = self.getnuxeoservicelist
    respond_to do |format|
      format.html # nuxeoservices.html.erb
      format.json { render json :@services }
      format.json { render json :@tab }
      format.json { render json: @user }
    end
  end

  #####################################################
  # GET /newproxy
  # GET /newproxy.json
  def newproxy

    ######
    if (params[:proxy].nil?)
      @proxy= Proxy.new
    else
      @proxy = Proxy.new(params[:proxy])
      if !@proxy.valid?
        return
        respond_to do |format|
          format.html # newproxy.html.erb
          format.json { render json: @proxy }
        end
      else
        @proxy.save
        redirect_to :action => 'listproxy' and return
      end
    end

    respond_to do |format|
      format.html # newproxy.html.erb
      format.json { render json: @proxy }
    end
    #######

  end

  ######################################################

  # GET /listproxy
  # GET /listproxy.json
  def listproxy
    @proxies = Proxy.all

    respond_to do |format|
      format.html # listproxy.html.erb
      format.json { render json: @proxies }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def newsubscription
    @service = params[:service]
    @subscription = Subscription.new
    @proxies = Proxy.all

    @service = params[:service]
    uid = @service[:uid]
    @webs = Webservicetolisten.find_all_by_nuxeouid(uid)

    @user = User.find(session[:user_id])
    @nuxeo_token = @user.nuxeotoken
    @accesstoken = OAuth::AccessToken.new(@@consumer, @nuxeo_token.token, @nuxeo_token.secret)
    @request_list_nuxeo_services = "SELECT * FROM Document WHERE ecm:primaryType = 'Service'"
    @result =self.getnuxeoservices(@accesstoken)

    @service1 = ActiveSupport::JSON.decode(@result.body)
    @services = @service1["entries"]

    @myTab = []
    for serv in @services
      # Do whatever you want to ‘object’ (your iterator)
      if (serv['uid']!=uid)
        val =[]
        val[0]= serv['uid']
        val[1]= serv['title']
        @myTab << val
      end
    end

    if @webs.empty?
      @serv = Webservicetolisten.new
      @serv.nuxeouid = @service[:uid]
      @serv.title = @service[:title]
      @serv.archipath = @service['properties']['soa:archiPath']
      @serv.url = @service['properties']['serv:url']
      @serv.save
    end

    @webs = Webservicetolisten.find_all_by_nuxeouid(uid)
    session[:servicetolisten] = @webs[0].id

    session[:myTabLength] = @myTab.length

    respond_to do |format|
      format.html # newsubscription.html.erb
      format.json { render json: @service }
      format.json { render json: @myTab }
      format.json { render json: @proxies }
      format.json { render json: @subscription }
    end
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def createsubscription

    myTabLength = session[:myTabLength]
    @myTab = []
    i=0
    while (i<myTabLength)
      val = params[i.to_s]
      if (!val.nil?)
        @myTab << val
      end
      i=i+1
    end
    @user = User.find(session[:user_id])
    @subscription = Subscription.new(params[:subscription])

    proxy_id = params[:proxy_id]
    @proxy = Proxy.find(proxy_id)
    @subscription.user = @user
    @subscription.subscription_type = SubscriptionType.first
    @subscription.proxy = @proxy
    @subscription.webservicetolisten = Webservicetolisten.find(session[:servicetolisten])

    ############################

    @user = User.find(session[:user_id])
    @nuxeo_token = @user.nuxeotoken
    @accesstoken = OAuth::AccessToken.new(@@consumer, @nuxeo_token.token, @nuxeo_token.secret)
    @request_list_nuxeo_services = "SELECT * FROM Document WHERE ecm:primaryType = 'Service'"
    @result = self.getnuxeoservices(@accesstoken)
    @service1 = ActiveSupport::JSON.decode(@result.body)
    @services = @service1["entries"]

    @listCalls = []
    @services.each do |serv|
      # Do whatever you want to ‘object’ (your iterator)
      if (@myTab.include?(serv['uid']))
        listservice = Webservicetolaunch.find_all_by_nuxeouid(serv['uid'])
        if (listservice.empty?)
          @webserv = Webservicetolaunch.new
          @webserv.nuxeouid = serv['uid']
          @webserv.description=serv[:title]
          @webserv.url= serv['properties']['serv:url']
          @webserv.save
          @webcall = (Webservicetolaunch.find_all_by_nuxeouid(serv['uid']))[0]

        else
          @webcall = listservice[0]
        end
        @listCalls <<@webcall
      end
    end

    @subscription.save
    @subs = (Subscription.where(:user_id => @user.id, :description => @subscription.description, :proxy_id => @subscription.proxy_id))[0]

    @listCalls.each do |entry|
      @subs.webservicetolaunch << entry
    end

    ############################
    # Ici on doit envoyer en xml
    # les subcriptions presentes
    # dans la base de données
    ############################

    @listtoreturn = @proxy.subscriptions
    @listtoreturnXml = "<configuration>"

    if ((@proxy.nil?)||(@proxy.url.nil?))
      @listtoreturnXml << "<proxy/>"
    else
      @listtoreturnXml << "<proxy>"
      @listtoreturnXml << @proxy.url
      @listtoreturnXml << "</proxy>"
    end

    @listtoreturn.each do |value|
      @listtoreturnXml << "<subscriptions>"

      @listtoreturnXml << "<regexCondition>"
      @listtoreturnXml << "<regex>"
      @listtoreturnXml << value.webservicetolisten.url
      @listtoreturnXml << "</regex>"
      @listtoreturnXml << "</regexCondition>"

      @jxpathconditions = value.jxpathconditions

      @listtoreturnXml << "<jxPathCondition>"
      @jxpathconditions.each do |entry|
        @listtoreturnXml << "<jxPathRequest>"
        @listtoreturnXml << entry.value
        @listtoreturnXml << "</jxPathRequest>"
      end
      @listtoreturnXml << "</jxPathCondition>"

      @webToCall = value.webservicetolaunch
      @webToCall.each do |entry|
        @listtoreturnXml << "<launchedservices>"

        @listtoreturnXml << "<url>"
        @listtoreturnXml << entry.url
        @listtoreturnXml << "</url>"

        @listtoreturnXml << "</launchedservices>"
      end

      @listtoreturnXml << "</subscriptions>"
    end
    @listtoreturnXml << "</configuration>"

    @host = 'localhost'
    @port = '8084'
    @path = "/SubscriptionWebService/subscriptions"
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' => 'application/xml', 'Accept' => 'application/xml, */*'})
    request.body = @listtoreturnXml
    response = Net::HTTP.new(@host, @port).start { |http| http.request(request) }


    ##########################
    #{"configuration":{"subscriptions":{"regexCondition":{"regex":"http:\/\/mail.fr"},"launchedservices":[{"url":"http:\/\/Yahoo.fr"},{"url":"http:\/\/Yahorgeo.fr"}]},"proxy":"proxy USA, htpsedef15.3"}}

    ############################
    respond_to do |format|
      format.html { redirect_to :action => 'subscriptionslist' }
      format.json { render json: @subscription, status: :created, location: @subscription }
    end
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

  def deleteproxy
    @proxy = Proxy.find(params[:proxy])
    @proxy.destroy

    respond_to do |format|
      format.html { redirect_to :action => :listproxy }
      format.json { head :no_content }
    end
  end

  def deletesubscription
    @subscription = Subscription.find(params[:subscription])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to :action => :subscriptionslist }
      format.json { head :no_content }
    end
  end


  def addcustomjxpath
    @subscription = Subscription.find(params[:subscription])
    @cj = Customjxpath.all
    @subscription_id = params[:subscription]

  end

  def setupcustomjxpath

    value = params['value']
    @sub = Subscription.find(params['id'])
    @customjxath = Customjxpath.find(params['id'])
    @jxpathcondition = Jxpathcondition.new
    @jxpathcondition.description=@customjxath.description
    @jxpathcondition.subscription = @sub
    @jxpathcondition.value = @customjxath.value

    if @jxpathcondition.save
      redirect_to :action => 'subscriptionslist' and return
    else
      render :file => File.join(Rails.root, 'public', '500.html') and return
    end
    render :file => File.join(Rails.root, 'public', '500.html') and return
  end

  def setuptemplatejxpath
    value = params['value']
    @cj = Templatejxpath.find(params['id'])
    valeur = String.new(@cj.value.to_s)
    valeur['XXX']= value

    @jxpathcondition = Jxpathcondition.new
    @jxpathcondition.value = valeur
    @jxpathcondition.description = @cj.description
    @jxpathcondition.subscription = Subscription.find(params[:subscription])

    if @jxpathcondition.save
      redirect_to :action => 'subscriptionslist'
    else
      render :file => File.join(Rails.root, 'public', '500.html')
    end
  end

  def addtemplatejxpath
    @tj = Templatejxpath.all
    @subscription_id = params[:subscription]
  end

  def subscriptionslist
    @user = User.find(session[:user_id])
    @subscriptions = @user.subscriptions
  end

# @role Oauthconnect get the nuxeo request token
# Redirect the user on te Nuxeo authorization page
  def oauthconnect
    @request_token = @@consumer.get_request_token(:oauth_callback => "http://localhost:3000/user/callback")
    session[:request_token] = @request_token
    redirect_to @request_token.authorize_url
  end

# @role This method get the access token
# sent by Nuxeo after authentication
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

    @result =self.getnuxeocurrentuser(@accesstoken)

    @parsed_json = ActiveSupport::JSON.decode(@result.body)
    @nuxeo_username = @parsed_json["properties"]['dc:creator'] #["dc:contributors"][0]

    if @user.username!= @nuxeo_username
      @nuxeo_token.destroy

      session[:state] = 2
      #@@state="f"
      #use the same username for both system
      redirect_to :controller => 'unsecurearea', :action => :connexion and return
    else
      redirect_to :action => :welcome and return
    end

  end

  def listolisten
    @webserv = Webservicetolisten.all
    respond_to do |format|
      format.html # showservice.html.erb
      format.json { render json: @webserv }
    end
  end

  def listtolaunch
    @webserv = Webservicetolaunch.all
    respond_to do |format|
      format.html # showservice.html.erb
      format.json { render json: @webserv }
    end
  end


  def showconditions
    @subscription = Subscription.find(params['subscription'])
    @jxpathconditions = @subscription.jxpathconditions
    session[:subscription_id] = @subscription.id
  end

  def deletejxpathcondition
    @jxpathcondition = Jxpathcondition.find(params['condition'])
    if @jxpathcondition.destroy
      @subscription = Subscription.find(session[:subscription_id])
      @jxpathconditions = @subscription.jxpathconditions
      render 'showconditions' and return
    else
      render :file => File.join(Rails.root, 'public', '500.html') and return
    end
  end


  # Nuxeo Request

  # @param [Object] accesstoken
  def getnuxeoservices(accesstoken)
    @result = @@consumer.request(:post,
                                 "/site/automation/Document.Query", #url to query
                                 accesstoken, #accesstoken
                                 {},
                                 '{"params":{"query": "'<< Request_for_get_all_nuxeo_services << '"}}',
                                 {'Content-Type' => 'application/json+nxrequest; charset=UTF-8',
                                  'Accept' => 'application/json+nxentity, */*',
                                  'X-NXDocumentProperties' => '*'}
    )
    return @result
  end

  def getnuxeocurrentuser(accesstoken)
    @result = @@consumer.request(:post,
                                 "/site/automation/UserWorkspace.Get", #url to query
                                 accesstoken, #accesstoken
                                 {},
                                 '{"params":{"query":"'<< Request_for_get_nuxeo_current_user << '"}}',
                                 {'Content-Type' => 'application/json+nxrequest; charset=UTF-8',
                                  'Accept' => 'application/json+nxentity, */*',
                                  'X-NXDocumentProperties' => '*'}
    )
    return @result
  end

end