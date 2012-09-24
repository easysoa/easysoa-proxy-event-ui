class ProxiesController < ApplicationController
  # GET /proxies
  # GET /proxies.json
  def index
    @proxies = Proxy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proxies }
    end
  end

  # GET /proxies/1
  # GET /proxies/1.json
  def show
    @proxy = Proxy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proxy }
    end
  end

  # GET /proxies/new
  # GET /proxies/new.json
  def new
    @proxy = Proxy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proxy }
    end
  end

  # GET /proxies/1/edit
  def edit
    @proxy = Proxy.find(params[:id])
  end

  # POST /proxies
  # POST /proxies.json
  def create
    @proxy = Proxy.new(params[:proxy])

    respond_to do |format|
      if @proxy.save
        format.html { redirect_to @proxy, notice: 'Proxy was successfully created.' }
        format.json { render json: @proxy, status: :created, location: @proxy }
      else
        format.html { render action: "new" }
        format.json { render json: @proxy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proxies/1
  # PUT /proxies/1.json
  def update
    @proxy = Proxy.find(params[:id])

    respond_to do |format|
      if @proxy.update_attributes(params[:proxy])
        format.html { redirect_to @proxy, notice: 'Proxy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proxy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proxies/1
  # DELETE /proxies/1.json
  def destroy
    @proxy = Proxy.find(params[:id])
    @proxy.destroy

    respond_to do |format|
      format.html { redirect_to proxies_url }
      format.json { head :no_content }
    end
  end
end
