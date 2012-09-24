require 'net/http'

class SubscriptionsController < ApplicationController
  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    @subscription = Subscription.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new
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
    @result = @@consumer.request(:post,
                                 "/site/automation/Document.Query", #url to query
                                 @accesstoken, #accesstoken
                                 {},
                                 '{"params":{"query": "SELECT * FROM Document WHERE ecm:primaryType = \'Service\'"}}', # request or nuxeo services
                                 {'Content-Type' => 'application/json+nxrequest; charset=UTF-8',
                                  'Accept' => 'application/json+nxentity, */*',
                                  'X-NXDocumentProperties' => '*'}
    )
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
      format.html # new.html.erb
      format.json { render json: @service }
      format.json { render json: @myTab }
      format.json { render json: @proxies }
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create

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
    @result = @@consumer.request(:post,
                                 "/site/automation/Document.Query", #url to query
                                 @accesstoken, #accesstoken
                                 {},
                                 '{"params":{"query": "SELECT * FROM Document WHERE ecm:primaryType = \'Service\'"}}', # request or nuxeo services
                                 {'Content-Type' => 'application/json+nxrequest; charset=UTF-8',
                                  'Accept' => 'application/json+nxentity, */*',
                                  'X-NXDocumentProperties' => '*'}
    )
    @service1 = ActiveSupport::JSON.decode(@result.body)
    @services = @service1["entries"]

    @listCalls = []
    @services.each do |serv|
      # Do whatever you want to ‘object’ (your iterator)
      if (@myTab.include?(serv['uid']))
        listservice = Webservicetolaunch.find_all_by_nuxeouid(serv['uid'])
        if (listservice.empty?)
          webserv = Webservicetolaunch.new
          webserv.nuxeouid = serv['uid']
          webserv.description=serv[:title]
          webserv.url= serv['properties']['serv:url']
          webserv.save
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

    @listtoreturn = Subscription.all
    @listtoreturnXml = "<subscriptions>"
    @listtoreturn.each do |value|
      @listtoreturnXml << "<subscriptions>"
      #    tolaunch = Webservicetolaunch.find(value.webservicetolaunch_id)
      #   @listtoreturnXml << "<launchedservices><id>"<<tolaunch.id.to_s << "</id><url>"<<tolaunch.url<<"</url></launchedservices>"
      #  @listtoreturnXml << "<listenedservices><id>"<<value.webservicetolisten.id.to_s<< "</id><url>"<<value.webservicetolisten.url<< "</url></listenedservices>"
      #  @listtoreturnXml << "</subscriptions>"
    end
    @listtoreturnXml << "</subscriptions>"
    #sender = HttpUtils.new
    #sender.postToRuntime(@listtoreturnXml)

    @host = 'localhost'
    @port = '8084'
    @path = "/SubscriptionWebService/subscriptions"
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' => 'application/xml', 'Accept' => 'application/xml, */*'})
    request.body = @listtoreturnXml
    response = Net::HTTP.new(@host, @port).start { |http| http.request(request) }
    puts "Response #{response.code} #{response.message}: #{response.body}"


    ############################
    respond_to do |format|
      format.html { redirect_to @subscription, notice: 'Subscription was successfully created.' }
      format.json { render json: @subscription, status: :created, location: @subscription }
    end

  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to subscriptions_url }
      format.json { head :no_content }
    end
  end
end


