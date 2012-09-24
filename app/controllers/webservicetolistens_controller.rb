class WebservicetolistensController < ApplicationController
  # GET /webservicetolistens
  # GET /webservicetolistens.json
  def index
    @webservicetolistens = Webservicetolisten.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @webservicetolistens }
    end
  end

  # GET /webservicetolistens/1
  # GET /webservicetolistens/1.json
  def show
    @webservicetolisten = Webservicetolisten.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @webservicetolisten }
    end
  end

  # GET /webservicetolistens/new
  # GET /webservicetolistens/new.json
  def new
    @webservicetolisten = Webservicetolisten.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @webservicetolisten }
    end
  end

  # GET /webservicetolistens/1/edit
  def edit
    @webservicetolisten = Webservicetolisten.find(params[:id])
  end

  # POST /webservicetolistens
  # POST /webservicetolistens.json
  def create
    @webservicetolisten = Webservicetolisten.new(params[:webservicetolisten])

    respond_to do |format|
      if @webservicetolisten.save
        format.html { redirect_to @webservicetolisten, notice: 'Webservicetolisten was successfully created.' }
        format.json { render json: @webservicetolisten, status: :created, location: @webservicetolisten }
      else
        format.html { render action: "new" }
        format.json { render json: @webservicetolisten.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /webservicetolistens/1
  # PUT /webservicetolistens/1.json
  def update
    @webservicetolisten = Webservicetolisten.find(params[:id])

    respond_to do |format|
      if @webservicetolisten.update_attributes(params[:webservicetolisten])
        format.html { redirect_to @webservicetolisten, notice: 'Webservicetolisten was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @webservicetolisten.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webservicetolistens/1
  # DELETE /webservicetolistens/1.json
  def destroy
    @webservicetolisten = Webservicetolisten.find(params[:id])
    @webservicetolisten.destroy

    respond_to do |format|
      format.html { redirect_to webservicetolistens_url }
      format.json { head :no_content }
    end
  end
end
