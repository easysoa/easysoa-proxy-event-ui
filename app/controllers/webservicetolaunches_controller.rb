class WebservicetolaunchesController < ApplicationController
  # GET /webservicetolaunches
  # GET /webservicetolaunches.json
  def index
    @webservicetolaunches = Webservicetolaunch.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @webservicetolaunches }
    end
  end

  # GET /webservicetolaunches/1
  # GET /webservicetolaunches/1.json
  def show
    @webservicetolaunch = Webservicetolaunch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @webservicetolaunch }
    end
  end

  # GET /webservicetolaunches/new
  # GET /webservicetolaunches/new.json
  def new
    @webservicetolaunch = Webservicetolaunch.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @webservicetolaunch }
    end
  end

  # GET /webservicetolaunches/1/edit
  def edit
    @webservicetolaunch = Webservicetolaunch.find(params[:id])
  end

  # POST /webservicetolaunches
  # POST /webservicetolaunches.json
  def create
    @webservicetolaunch = Webservicetolaunch.new(params[:webservicetolaunch])

    respond_to do |format|
      if @webservicetolaunch.save
        format.html { redirect_to @webservicetolaunch, notice: 'Webservicetolaunch was successfully created.' }
        format.json { render json: @webservicetolaunch, status: :created, location: @webservicetolaunch }
      else
        format.html { render action: "new" }
        format.json { render json: @webservicetolaunch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /webservicetolaunches/1
  # PUT /webservicetolaunches/1.json
  def update
    @webservicetolaunch = Webservicetolaunch.find(params[:id])

    respond_to do |format|
      if @webservicetolaunch.update_attributes(params[:webservicetolaunch])
        format.html { redirect_to @webservicetolaunch, notice: 'Webservicetolaunch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @webservicetolaunch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webservicetolaunches/1
  # DELETE /webservicetolaunches/1.json
  def destroy
    @webservicetolaunch = Webservicetolaunch.find(params[:id])
    @webservicetolaunch.destroy

    respond_to do |format|
      format.html { redirect_to webservicetolaunches_url }
      format.json { head :no_content }
    end
  end
end
